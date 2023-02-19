import 'package:drift/drift.dart';

import '../local/localdb.dart';

// class SupportModel {
//   SupportModel({required this.date});
//
//   final String date;
//
//   SupportModel.fromRow(final Support support) : date = date.date;
//
//   SupportsCompanion toRow() => SupportsCompanion.insert(
//         date: date,
//       );
//
//   SupportModel.fromJson(final String json) : date = json;
//
//   String toJson() => date;
// }

class SupportModel {
  SupportModel({
    required this.id,
    required this.field,
  });

  final int id;
  final Field field;

  SupportModel.fromRow(final Support support)
      : id = support.id,
        field = support.field;

  SupportsCompanion toRow() => SupportsCompanion.insert(
        id: id,
        field: field,
      );

  SupportModel.fromJson(final Map<String, dynamic> json)
      : id = json['id'],
        field = json['field'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'field': field,
      };
}

class EntityModel {
  EntityModel({
    this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
  });

  final int? id;
  final String date;
  final String type;
  final double amount;
  final String category;
  final String description;

  EntityModel.fromRow(final Entity finance)
      : id = finance.id,
        date = finance.date,
        type = finance.type,
        amount = finance.amount,
        category = finance.category,
        description = finance.description;

  EntitiesCompanion toRow() => EntitiesCompanion(
        id: id != null ? Value(id!) : const Value.absent(),
        date: Value(date),
        type: Value(type),
        amount: Value(amount),
        category: Value(category),
        description: Value(description),
      );

  EntityModel.fromJson(final Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        type = json['type'],
        amount = double.parse(json['amount'].toString()),
        category = json['category'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
      };

  @override
  String toString() {
    return 'id: $id , date: $date , type: $type, amount: $amount , category: $category , description: $description';
  }
}
