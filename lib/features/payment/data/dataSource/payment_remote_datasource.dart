import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/payment/logic/model/payment_model.dart';

class PaymentRemoteDataSource {
  final FirebaseFirestore firestore;

  PaymentRemoteDataSource(this.firestore);

  Future<void> addPayment({
    required String uid,
    required String customerId,
    required Map<String, dynamic> data,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('payments')
        .add(data);

    await recalculateTotalDebt(uid: uid, customerId: customerId);
  }

  Future<void> recalculateTotalDebt({
    required String uid,
    required String customerId,
  }) async {
    final debtsSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('debts')
        .get();

    final paymentsSnapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('payments')
        .get();

    double totalDebts = 0;
    for (var doc in debtsSnapshot.docs) {
      totalDebts += (doc.data()['amount'] as num).toDouble();
    }

    double totalPayments = 0;
    for (var doc in paymentsSnapshot.docs) {
      totalPayments += (doc.data()['amount'] as num).toDouble();
    }

    final remaining = totalDebts - totalPayments;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .update({
      'totalDebt': remaining < 0 ? 0 : remaining,
      'lastUpdate': FieldValue.serverTimestamp(),
    });
  }

  Future<List<PaymentModel>> getPayments({
    required String uid,
    required String customerId,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('payments')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PaymentModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}