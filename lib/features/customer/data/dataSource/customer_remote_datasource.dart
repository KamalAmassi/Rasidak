import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasidak/features/customer/data/model/customerModel.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';

class CustomerRemoteDataSource {
  final FirebaseFirestore firestore;

  CustomerRemoteDataSource(this.firestore);

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

  Future<void> addCustomer({
    required String uid,
    required Map<String, dynamic> data,
  }) async {

    await firestore
        .collection("users")
        .doc(uid)
        .collection("customers")
        .add(data);
  }

  Future<List<Customer>> getCustomers({required String uid}) async {
    final snapshot = await firestore
        .collection("users")
        .doc(uid)
        .collection("customers")
        .get();

    return snapshot.docs
        .map((doc) => CustomerModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}