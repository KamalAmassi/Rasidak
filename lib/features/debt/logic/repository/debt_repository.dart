import 'package:rasidak/features/debt/logic/entity/debt.dart';

abstract class DebtRepository {
  Future<void> addDebt({
    required String uid,
    required String customerId,
    required Debt debt,
  });

  Future<List<Debt>> getDebts({
    required String uid,
    required String customerId,
  });

}