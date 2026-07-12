import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/debt/data/model/debtModel.dart';

class DebtRemoteDataSource {
  final FirebaseFirestore firestore;

  DebtRemoteDataSource(this.firestore);


  Future<bool> checkCustomerExists({
    required String uid,
    required String name,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> addDebt({
    required String uid,
    required String customerId,
    required Map<String, dynamic> data,
  }) async {

    await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('debts')
        .add(data);

    await recalculateTotalDebt(uid: uid, customerId: customerId);
  }

  Future<void> recalculateTotalDebt({
    required String uid,
    required String customerId,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('debts')
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] as num).toDouble();
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .update({
      'totalDebt': total,
      'lastUpdate': FieldValue.serverTimestamp(),
    });
  }


  Future<bool> customerExists({
    required String uid,
    required String customerName,
  }) async {

    final result = await firestore
        .collection("users")
        .doc(uid)
        .collection("customers")
        .where(
      "name",
      isEqualTo: customerName,
    )
        .get();

    return result.docs.isNotEmpty;
  }


  Future<List<DebtModel>> getDebts({
    required String uid,
    required String customerId,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('debts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DebtModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}