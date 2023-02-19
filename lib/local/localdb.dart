import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'localdb.g.dart';

@DataClassName('Entity')
class Entities extends Table {
  @override
  String get tableName => 'entities';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get date => text()();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  TextColumn get category => text()();

  TextColumn get description => text()();
}

@DataClassName('Support')
class Supports extends Table {
  @override
  String get tableName => 'supports';

  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [Entities, Supports])
class Local extends _$Local {
  Local() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await m.deleteTable('entities');
        await m.deleteTable('supports');
        await m.createAll();
      },
    );
  }

  Stream<List<Support>> get supportsStream => select(supports).watch();

  StreamController<List<Entity>> entitiesStreamController =
      StreamController.broadcast();

  Stream<List<Entity>> get entitiesStream => entitiesStreamController.stream;

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> setSupports(final List<SupportsCompanion> data) async {
    try {
      await delete(supports).go();
    } on Exception {
      developer.log(
        'Exception clearing the supports from the local database',
        name: 'Local:setSupports',
      );
      return false;
    }
    developer.log(
      'Managed to clear the supports from the local database',
      name: 'Local:setSupports',
    );

    try {
      await batch(
        (batch) {
          batch.insertAllOnConflictUpdate(supports, data);
        },
      );
    } on Exception {
      developer.log(
        'Exception adding the remote supports to the local database',
        name: 'Local:setSupports',
      );
      return false;
    }

    developer.log(
      'Managed to add the remote supports to the local database',
      name: 'Local:setSupports',
    );
    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> setEntities(
    final List<EntitiesCompanion> data,
    final Field field,
  ) async {
    try {
      await (delete(entities)..where((tbl) => tbl.field.equals(field))).go();
    } on Exception {
      developer.log(
        'Exception clearing the entities from the local database',
        name: 'Local:setEntities',
      );
      return false;
    }
    developer.log(
      'Managed to clear the entities from the local database',
      name: 'Local:setEntities',
    );

    try {
      await batch(
        (batch) {
          batch.insertAllOnConflictUpdate(entities, data);
        },
      );
    } on Exception {
      developer.log(
        'Exception adding the remote entities to the local database',
        name: 'Local:setEntities',
      );
      return false;
    }

    developer.log(
      'Managed to add the remote entities to the local database',
      name: 'Local:setEntities',
    );
    final synced = _syncEntities(field);
    return synced;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Entity?> getEntity(final Field field) async {
    late final Entity entity;
    try {
      entity = await (select(entities)..where((t) => t.field.equals(field)))
          .getSingle();
    } on Exception {
      developer.log(
        'Exception fetching local entity',
        name: 'Local:getEntity',
      );
      return null;
    }
    developer.log(
      'Fetched entity from local database: $entity',
      name: 'Local:_getEntities',
    );
    return entity;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<List<Entity>?> getEntities(final Field field) async {
    late final List<Entity> fetchedEntities;
    try {
      fetchedEntities =
          await (select(entities)..where((t) => t.field.equals(field))).get();
    } on Exception {
      developer.log(
        'Exception fetching local entities',
        name: 'Local:getEntity',
      );
      return null;
    }
    developer.log(
      'Fetched entities from local database: $fetchedEntities',
      name: 'Local:_getEntities',
    );
    return fetchedEntities;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> addEntity(final EntitiesCompanion entity) async {
    developer.log(
      'Adding entity locally: $entity',
      name: 'Local:addEntity',
    );
    try {
      await into(entities).insertOnConflictUpdate(entity);
    } on Exception {
      developer.log(
        'Failed to add entity locally',
        name: 'Local:addEntity',
      );
      return false;
    }

    final date = entity.date.value;
    final synced = _syncEntities(date);
    return synced;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> deleteEntity(final Field field) async {
    developer.log(
      'Deleting entity locally',
      name: 'Local:deleteEntity',
    );
    try {
      await (delete(entities)..where((tbl) => tbl.id.equals(id))).go();
    } on Exception {
      developer.log(
        'Failed to delete entity locally: database error',
        name: 'Local:deleteEntity',
      );
      return false;
    }
    final synced = await _syncEntities(field);
    return synced;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> _syncEntities(final Field field) async {
    final list = await _getEntities(field);
    if (list == null) {
      developer.log(
        'Failed to fetch local entities',
        name: 'Local:_syncEntities',
      );
      return false;
    }
    entitiesStreamController.sink.add(list);
    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<List<Entity>?> _getEntities(final Field field) async {
    late final List<Entity> list;
    try {
      list =
          await (select(entities)..where((t) => t.field.equals(field))).get();
    } on Exception {
      developer.log(
        'Exception fetching local entities',
        name: 'Local:_getEntities',
      );
      return null;
    }
    developer.log(
      'Fetched entities from local database: $list',
      name: 'Local:_getEntities',
    );
    return list;
  }
}

////////////////////////////////////////////////////////////////////////////////
LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    },
  );
}
