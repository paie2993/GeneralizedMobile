import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'localdb.g.dart';

@DataClassName('Finance')
class Finances extends Table {
  @override
  String get tableName => 'finances';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get date => text()();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  TextColumn get category => text()();

  TextColumn get description => text()();
}

@DataClassName('Date')
class Dates extends Table {
  @override
  String get tableName => 'dates';

  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [Finances, Dates])
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
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }

  Stream<List<Date>> get datesStream => select(dates).watch();

  StreamController<List<Finance>> currentFinancesStreamController =
      StreamController.broadcast();

  Stream<List<Finance>> get currentFinancesStream =>
      currentFinancesStreamController.stream;

  Future<bool> setDates(List<DatesCompanion> data) async {
    try {
      await delete(dates).go();
    } on Exception {
      developer.log(
        'Exception clearing the dates from the local database',
        name: 'Local:setDates',
      );
      return false;
    }
    developer.log(
      'Managed to clear the dates from the local database',
      name: 'Local:setDates',
    );

    try {
      await batch(
        (batch) {
          batch.insertAllOnConflictUpdate(dates, data);
        },
      );
    } on Exception {
      developer.log(
        'Exception adding the remote dates to the local database',
        name: 'Local:setDates',
      );
      return false;
    }

    developer.log(
      'Managed to add the remote dates to the local database',
      name: 'Local:setDates',
    );
    return true;
  }

  Future<bool> setFinances(
    final List<FinancesCompanion> data,
    final String date,
  ) async {
    try {
      await (delete(finances)..where((tbl) => tbl.date.equals(date))).go();
    } on Exception {
      developer.log(
        'Exception clearing the finances from the local database',
        name: 'Local:setFinances',
      );
      return false;
    }
    developer.log(
      'Managed to clear the finances from the local database',
      name: 'Local:setFinances',
    );

    try {
      await batch(
        (batch) {
          batch.insertAllOnConflictUpdate(finances, data);
        },
      );
    } on Exception {
      developer.log(
        'Exception adding the remote finances to the local database',
        name: 'Local:setFinances',
      );
      return false;
    }

    developer.log(
      'Managed to add the remote finances to the local database',
      name: 'Local:setFinances',
    );

    return true;
  }

  Future<bool> getFinances(final String date) async {
    final synced = _syncFinances(date);
    return synced;
  }

  Future<bool> addFinance(final FinancesCompanion finance) async {
    developer.log(
      'Adding finance locally: $finance',
      name: 'Local:addFinance',
    );
    try {
      await into(finances).insertOnConflictUpdate(finance);
    } on Exception {
      developer.log(
        'Failed to add finance locally',
        name: 'Local:addFinance',
      );
      return false;
    }

    final date = finance.date.value;
    final synced = _syncFinances(date);
    return synced;
  }

  Future<bool> deleteFinance(final int id, final String date) async {
    developer.log(
      'Deleting finance locally',
      name: 'Local:deleteFinance',
    );
    try {
      await (delete(finances)..where((tbl) => tbl.id.equals(id))).go();
    } on Exception {
      developer.log(
        'Failed to delete finance locally: database error',
        name: 'Local:deleteFinance',
      );
      return false;
    }
    final synced = await _syncFinances(date);
    return synced;
  }

  Future<bool> _syncFinances(final String date) async {
    final list = await _getFinances(date);
    if (list == null) {
      developer.log(
        'Failed to fetch local finances',
        name: 'Local:_syncFinances',
      );
      return false;
    }
    currentFinancesStreamController.sink.add(list);
    return true;
  }

  Future<List<Finance>?> _getFinances(final String date) async {
    late final List<Finance> list;
    try {
      list = await (select(finances)..where((t) => t.date.equals(date))).get();
    } on Exception {
      developer.log(
        'Exception fetching local finances',
        name: 'Local:_getFinances',
      );
      return null;
    }
    developer.log(
      'Fetched finances from local database: $list',
      name: 'Local:_getFinances',
    );
    return list;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    },
  );
}
