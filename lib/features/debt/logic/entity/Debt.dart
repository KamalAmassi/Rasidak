class Debt {
  final String id;
  final double amount;
  final String description;
  final String notes;
  final DateTime date;
  final DateTime createdAt;

  Debt({
    required this.id,
    required this.amount,
    required this.description,
    required this.notes,
    required this.date,
    required this.createdAt,
  });
}