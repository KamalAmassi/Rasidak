import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/notifications/notification_service.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';
import 'package:rasidak/features/debt/logic/repository/debt_repository.dart';

class DebtController extends GetxController {

  final DebtRepository repository;

  DebtController(this.repository);

  RxBool isLoading = false.obs;

  Rxn<Customer> selectedCustomer = Rxn<Customer>();

  String? get _uid => Get.find<AuthController>().uid;

  Future<void> addDebt({
    required String customerId,
    required Debt debt,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      isLoading.value = true;

      await repository.addDebt(
        uid: uid,
        customerId: customerId,
        debt: debt,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await NotificationService().showInstantNotification(
        id: notificationId,
        title: 'تم إضافة الدين بنجاح',
        body: 'تمت إضافة دين بمبلغ ${debt.amount} NIS لـ ${selectedCustomer.value?.name ?? ""}',
      );

      await NotificationService().scheduleReminder(
        id: notificationId + 1,
        title: 'تذكير بتحصيل دين',
        body: 'لديك دين مستحق بقيمة ${debt.amount} NIS لدى ${selectedCustomer.value?.name ?? ""}',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
      );

      await Get.find<CustomerController>().fetchCustomers();

      Get.back();
      Get.snackbar(
        'تم بنجاح ✓',
        'تمت إضافة الدين بنجاح',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );

    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  RxList<Debt> debts = <Debt>[].obs;

  Future<void> fetchDebts({required String customerId}) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final list = await repository.getDebts(
        uid: uid,
        customerId: customerId,
      );
      debts.assignAll(list);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}