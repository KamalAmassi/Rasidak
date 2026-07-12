
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.notes,
    required super.totalDebt,
    required super.debtLevel,
    required super.lastUpdate,
  });

  factory CustomerModel.fromJson(
      Map<String, dynamic> json,
      String id,
      ) {
    return CustomerModel(
      id: id,
      name: json['name'],
      phone: json['phone'],
      notes: json['notes'],
      totalDebt: json['totalDebt'].toDouble(),
      debtLevel: json['debtLevel'],
      lastUpdate: json['lastUpdate'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "notes": notes,
      "totalDebt": totalDebt,
      "debtLevel": debtLevel,
      "lastUpdate": Timestamp.fromDate(lastUpdate),
    };
  }
}