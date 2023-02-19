import 'package:drift/drift.dart';

import '../local/localdb.dart';

class DateModel {
  DateModel({required this.date});

  final String date;

  DateModel.fromRow(final Date date) : date = date.date;

  DatesCompanion toRow() => DatesCompanion.insert(
        date: date,
      );

  DateModel.fromJson(final String json) : date = json;

  String toJson() => date;
}

class FinanceModel {
  FinanceModel({
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

  FinanceModel.fromRow(final Finance finance)
      : id = finance.id,
        date = finance.date,
        type = finance.type,
        amount = finance.amount,
        category = finance.category,
        description = finance.description;

  FinancesCompanion toRow() => FinancesCompanion(
        id: id != null ? Value(id!) : const Value.absent(),
        date: Value(date),
        type: Value(type),
        amount: Value(amount),
        category: Value(category),
        description: Value(description),
      );

  FinanceModel.fromJson(final Map<String, dynamic> json)
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
