import 'package:rasidak/features/payment/logic/entity/payment.dart';

abstract class PaymentRepository {
  Future<void> addPayment({
    required String uid,
    required String customerId,
    required Payment payment,
  });

  Future<List<Payment>> getPayments({
    required String uid,
    required String customerId,
  });
}