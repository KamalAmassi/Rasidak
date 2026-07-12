class Payment {
  final String id;
  final double amount;
  final DateTime date;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    required this.createdAt,
  });
}