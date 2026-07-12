import 'package:rasidak/features/payment/data/dataSource/payment_remote_datasource.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';
import 'package:rasidak/features/payment/logic/model/payment_model.dart';
import 'package:rasidak/features/payment/logic/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource dataSource;

  PaymentRepositoryImpl(this.dataSource);

  @override
  Future<void> addPayment({
    required String uid,
    required String customerId,
    required Payment payment,
  }) async {
    final model = PaymentModel(
      id: payment.id,
      amount: payment.amount,
      date: payment.date,
      createdAt: payment.createdAt,
    );

    await dataSource.addPayment(
      uid: uid,
      customerId: customerId,
      data: model.toJson(),
    );
  }

  @override
  Future<List<Payment>> getPayments({
    required String uid,
    required String customerId,
  }) async {
    return await dataSource.getPayments(uid: uid, customerId: customerId);
  }
}