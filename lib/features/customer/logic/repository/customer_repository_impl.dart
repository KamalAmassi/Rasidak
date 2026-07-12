import 'package:rasidak/features/customer/data/dataSource/customer_remote_datasource.dart';
import 'package:rasidak/features/customer/data/model/customerModel.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/customer/logic/repository/customer_repository.dart';

class CustomerRepositoryImpl
    implements CustomerRepository {

  final CustomerRemoteDataSource dataSource;

  CustomerRepositoryImpl(
      this.dataSource,
      );

  @override
  Future<void> addCustomer(
      Customer customer, {
        required String uid,
      }) async {

    final model = CustomerModel(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      notes: customer.notes,
      totalDebt: customer.totalDebt,
      debtLevel: customer.debtLevel,
      lastUpdate: customer.lastUpdate,
    );

    await dataSource.addCustomer(
      uid: uid,
      data: model.toJson(),
    );

  }

  @override
  Future<List<Customer>> getCustomers({required String uid}) async {
    return await dataSource.getCustomers(uid: uid);
  }

  @override
  Future<bool> checkCustomerExists({
    required String uid,
    required String name,
  }) async {
    return await dataSource.checkCustomerExists(uid: uid, name: name);
  }
}