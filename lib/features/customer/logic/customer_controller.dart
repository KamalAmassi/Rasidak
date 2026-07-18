import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/customer/logic/repository/customer_repository.dart';

class CustomerController extends GetxController {
  final CustomerRepository repository;

  CustomerController(this.repository);

  RxBool isLoading = false.obs;
  RxList<Customer> customers = <Customer>[].obs;
  RxString searchQuery = ''.obs;

  String? get _uid => Get.find<AuthController>().uid;

  @override
  void onInit() {
    super.onInit();

    ever(Get.find<AuthController>().currentUser, (user) {
      if (user != null) {
        fetchCustomers();
      } else {
        customers.clear();
      }
    });
  }

  Future<void> fetchCustomers() async {
    final uid = _uid;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final list = await repository.getCustomers(uid: uid);
      customers.assignAll(list);
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCustomer(Customer customer) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      isLoading.value = true;

      final exists = await repository.checkCustomerExists(
        uid: uid,
        name: customer.name,
      );

      if (exists) {
        Get.snackbar(
          'تنبيه',
          'هذا الزبون موجود مسبقاً',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      
      await repository.addCustomer(customer, uid: uid);

      await fetchCustomers(); 

      Get.back();
      
      Get.snackbar(
        'تم بنجاح ✓',
        'تمت إضافة الزبون بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Customer> get filteredCustomers {
    if (searchQuery.value.trim().isEmpty) {
      return customers;
    }
    return customers
        .where((c) => c.name.toLowerCase().contains(
      searchQuery.value.trim().toLowerCase(),
    ))
        .toList();
  }
}