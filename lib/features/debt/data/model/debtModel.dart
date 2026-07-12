import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';

class DebtModel extends Debt {
  DebtModel({
    required super.id,
    required super.amount,
    required super.description,
    required super.notes,
    required super.date,
    required super.createdAt,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json, String id) {
    return DebtModel(
      id: id,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] ?? '',
      notes: json['notes'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'notes': notes,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}