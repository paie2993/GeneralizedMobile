import 'package:base/model/top_model.dart';
import 'package:flutter/material.dart';

import '../model/progress_model.dart';

Widget buildWeekTile(
  final BuildContext context,
  final TimeSpan item,
) {
  final startDate = item.startDate;
  final endDate = item.endDate;
  return ListTile(
    leading: Icon(
      Icons.add_alarm,
      color: Colors.blue.shade500,
    ),
    title: Text(
      '${startDate.year}-${startDate.month}-${startDate.day} - ${endDate.year}-${endDate.month}-${endDate.day}',
    ),
    subtitle: Text('Amount: ${item.amount}'),
  );
}

Widget buildTopTile(
  final BuildContext context,
  final TransactionCategory item,
) {
  final category = item.category;
  final transactions = item.transactions;
  return ListTile(
    leading: Icon(
      Icons.account_balance,
      color: Colors.blue.shade500,
    ),
    title: Text('Category: $category'),
    subtitle: Text('Transactions: $transactions'),
  );
}
