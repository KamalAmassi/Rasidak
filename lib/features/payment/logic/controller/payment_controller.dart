import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/notifications/notification_service.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/debt/logic/Controller/debt_controller.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';
import 'package:rasidak/features/payment/logic/repository/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository repository;

  PaymentController(this.repository);

  RxBool isLoading = false.obs;
  RxList<Payment> payments = <Payment>[].obs;

  String? get _uid => Get.find<AuthController>().uid;

  Future<void> fetchPayments({required String customerId}) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final list = await repository.getPayments(
        uid: uid,
        customerId: customerId,
      );
      payments.assignAll(list);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPayment({
    required String customerId,
    required String customerName,
    required double amount,
  }) async {
    final uid = _uid;
    if (uid == null) return false;

    try {
      isLoading.value = true;

      final payment = Payment(
        id: '',
        amount: amount,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await repository.addPayment(
        uid: uid,
        customerId: customerId,
        payment: payment,
      );

      await NotificationService().showInstantNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'تم تسديد الدين بنجاح',
        body: 'تم تسديد مبلغ $amount NIS من رصيد $customerName',
      );

      await fetchPayments(customerId: customerId); // ← حدّث قائمة الدفعات فوراً
      await Get.find<DebtController>().fetchDebts(customerId: customerId);
      await Get.find<CustomerController>().fetchCustomers();

      Get.snackbar(
        'تم بنجاح ✓',
        'تم تسديد المبلغ بنجاح',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );

      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}