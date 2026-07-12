class Customer {
  final String id;
  final String name;
  final String phone;
  final String notes;
  final double totalDebt;
  final String debtLevel;
  final DateTime lastUpdate;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.notes,
    required this.totalDebt,
    required this.debtLevel,
    required this.lastUpdate,
  });
}