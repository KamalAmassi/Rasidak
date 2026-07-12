import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';

class PaymentModel extends Payment {
  PaymentModel({
    required super.id,
    required super.amount,
    required super.date,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json, String id) {
    return PaymentModel(
      id: id,
      amount: (json['amount'] as num).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}