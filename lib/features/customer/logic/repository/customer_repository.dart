import '../entity/customer.dart';

abstract class CustomerRepository {

  Future<void> addCustomer(Customer customer, {required String uid});

  Future<List<Customer>> getCustomers({required String uid});

  Future<bool> checkCustomerExists({
    required String uid,
    required String name,
  });

}