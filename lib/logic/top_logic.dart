import '../model/model.dart';
import '../model/top_model.dart';
import 'dart:developer' as developer;

List<TransactionCategory> buildCategories(final List<FinanceModel> list) {
  developer.log(
    'Aggregating (and limit 3) categories by the number of transactions; input: $list',
    name: 'top_logic:buildCategories',
  );

  final map = _accumulateTransactionsByCategory(list);

  final categories = _mapToList(map);

  _sortCategoriesByTransactionsDescending(categories);

  final topThree = categories.sublist(0, 3);

  developer.log(
    'Aggregating (and limit 3) categories by the number of transactions; output: $topThree',
    name: 'top_logic:buildCategories',
  );

  return topThree;
}

Map<String, int> _accumulateTransactionsByCategory(
  final List<FinanceModel> list,
) {
  developer.log(
    'Accumulating categories by number of transactions into a map; input: $list',
    name: 'top_logic:_accumulateTransactionsByCategory',
  );

  final Map<String, int> map = {};

  list.map((e) => e.category).forEach((category) {
    map.update(
      category,
      (value) => map[category]! + 1,
      ifAbsent: () => 0,
    );
  });

  developer.log(
    'Accumulating categories by number of transactions into a map; output: $map',
    name: 'top_logic:_accumulateTransactionsByCategory',
  );

  return map;
}

List<TransactionCategory> _mapToList(final Map<String, int> map) {
  developer.log(
    'Converting aggregation map to list; input: $map',
    name: 'top_logic:_mapToList',
  );

  final categories = map.entries
      .map((e) => TransactionCategory(
            category: e.key,
            transactions: e.value,
          ))
      .toList();

  developer.log(
    'Converting aggregation map to list; input: $categories',
    name: 'top_logic:_mapToList',
  );

  return categories;
}

void _sortCategoriesByTransactionsDescending(
  final List<TransactionCategory> list,
) {
  developer.log(
    'Sorting categories by number of transactions descending; input: $list',
    name: 'top_logic:_sortCategoriesByTransactionsDescending',
  );
  list.sort(
    (final first, final second) =>
        -first.transactions.compareTo(second.transactions),
  );
  developer.log(
    'Sorting categories by number of transactions descending; output: $list',
    name: 'top_logic:_sortCategoriesByTransactionsDescending',
  );
}
