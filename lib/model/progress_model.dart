class DayAmount {
  const DayAmount({
    required this.date,
    required this.amount,
  });

  final DateTime date;
  final double amount;

  @override
  String toString() => 'date: $date, amount: $amount';
}

class TimeSpan {
  const TimeSpan({
    required this.startDate,
    required this.endDate,
    required this.amount,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double amount;

  @override
  String toString() =>
      'startDate: $startDate, endDate: $endDate, amount: $amount';
}
