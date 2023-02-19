import '../model/model.dart';
import 'dart:developer' as developer;

import '../model/progress_model.dart';

List<TimeSpan> buildWeeks(final List<FinanceModel> list) {
  developer.log(
    'Attempting to build the TimeSpan (weeks) instances sorted by amount descendingly',
    name: 'progress_logic:buildWeeks',
  );

  if (list.isEmpty) {
    developer.log(
      'Empty input list',
      name: 'progress_logic:buildWeeks',
    );
    return [];
  }

  _sortByDate(list);
  final daysAmountsList = _buildDaysAmounts(list);
  final weeks = _buildWeeks(daysAmountsList);
  _sortByAmount(weeks);
  return weeks;
}

void _sortByDate(final List<FinanceModel> list) {
  developer.log(
    'Sorting input list of FinanceModel instances ascending by date; input: $list',
    name: 'progress_logic:_sortByDate',
  );
  list.sort(
    (final first, final second) => first.date.compareTo(second.date),
  );
  developer.log(
    'Sorted list of FinanceModel; output: $list',
    name: 'progress_logic:_sortByDate',
  );
}

List<DayAmount> _buildDaysAmounts(final List<FinanceModel> list) => list
    .map((e) => DayAmount(
          date: DateTime.parse(e.date),
          amount: e.amount,
        ))
    .toList();

List<TimeSpan> _buildWeeks(final List<DayAmount> list) {
  developer.log(
    'Building weeks; input: $list',
    name: 'progress_logic:_buildWeeks',
  );

  if (list.isEmpty) {
    return [];
  }

  final List<TimeSpan> timeSpanList = [];

  var dateTimeBase = list[0].date;
  var previousDateTime = list[0].date;
  var amountAcc = 0.00;

  for (final element in list) {
    final currentDateTime = element.date;
    final currentAmount = element.amount;

    if (currentDateTime.difference(dateTimeBase).inDays <= 7) {
      amountAcc += currentAmount;
    } else {
      final newTimeSpan = TimeSpan(
        startDate: dateTimeBase,
        endDate: previousDateTime,
        amount: amountAcc,
      );
      timeSpanList.add(newTimeSpan);
      dateTimeBase = currentDateTime;
      amountAcc = currentAmount;
    }

    previousDateTime = currentDateTime;
  }
  final newTimeSpan = TimeSpan(
    startDate: dateTimeBase,
    endDate: previousDateTime,
    amount: amountAcc,
  );
  timeSpanList.add(newTimeSpan);

  return timeSpanList;
}

void _sortByAmount(final List<TimeSpan> list) {
  developer.log(
      'Sorting TimeSpan instances by amount, descending; input: $list',
      name: 'progress_logic:_sortByAmount');
  list.sort(
    (final first, final second) => -first.amount.compareTo(second.amount),
  );
  developer.log(
      'Sorting TimeSpan instances by amount, descending; output: $list',
      name: 'progress_logic:_sortByAmount');
}