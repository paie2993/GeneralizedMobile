// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localdb.dart';

// ignore_for_file: type=lint
class $EntitiesTable extends Entities with TableInfo<$EntitiesTable, Entity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, type, amount, category, description];
  @override
  String get aliasedName => _alias ?? 'entities';
  @override
  String get actualTableName => 'entities';
  @override
  VerificationContext validateIntegrity(Insertable<Entity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

class Entity extends DataClass implements Insertable<Entity> {
  final int id;
  final String date;
  final String type;
  final double amount;
  final String category;
  final String description;
  const Entity(
      {required this.id,
      required this.date,
      required this.type,
      required this.amount,
      required this.category,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    return map;
  }

  EntitiesCompanion toCompanion(bool nullToAbsent) {
    return EntitiesCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      amount: Value(amount),
      category: Value(category),
      description: Value(description),
    );
  }

  factory Entity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entity(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
    };
  }

  Entity copyWith(
          {int? id,
          String? date,
          String? type,
          double? amount,
          String? category,
          String? description}) =>
      Entity(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Entity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, amount, category, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entity &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.description == this.description);
}

class EntitiesCompanion extends UpdateCompanion<Entity> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> category;
  final Value<String> description;
  const EntitiesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
  });
  EntitiesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String type,
    required double amount,
    required String category,
    required String description,
  })  : date = Value(date),
        type = Value(type),
        amount = Value(amount),
        category = Value(category),
        description = Value(description);
  static Insertable<Entity> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
    });
  }

  EntitiesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? type,
      Value<double>? amount,
      Value<String>? category,
      Value<String>? description}) {
    return EntitiesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $SupportsTable extends Supports with TableInfo<$SupportsTable, Support> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [date];
  @override
  String get aliasedName => _alias ?? 'supports';
  @override
  String get actualTableName => 'supports';
  @override
  VerificationContext validateIntegrity(Insertable<Support> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  Support map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Support(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $SupportsTable createAlias(String alias) {
    return $SupportsTable(attachedDatabase, alias);
  }
}

class Support extends DataClass implements Insertable<Support> {
  final String date;
  const Support({required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    return map;
  }

  SupportsCompanion toCompanion(bool nullToAbsent) {
    return SupportsCompanion(
      date: Value(date),
    );
  }

  factory Support.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Support(
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
    };
  }

  Support copyWith({String? date}) => Support(
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('Support(')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => date.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Support && other.date == this.date);
}

class SupportsCompanion extends UpdateCompanion<Support> {
  final Value<String> date;
  const SupportsCompanion({
    this.date = const Value.absent(),
  });
  SupportsCompanion.insert({
    required String date,
  }) : date = Value(date);
  static Insertable<Support> custom({
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
    });
  }

  SupportsCompanion copyWith({Value<String>? date}) {
    return SupportsCompanion(
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupportsCompanion(')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$Local extends GeneratedDatabase {
  _$Local(QueryExecutor e) : super(e);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $SupportsTable supports = $SupportsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entities, supports];
}
