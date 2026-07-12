import 'package:rasidak/features/debt/data/dataSource/debt_remote_datasource.dart';
import 'package:rasidak/features/debt/data/model/debtModel.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';
import 'package:rasidak/features/debt/logic/repository/debt_repository.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtRemoteDataSource dataSource;

  DebtRepositoryImpl(this.dataSource);

  @override
  Future<void> addDebt({
    required String uid,
    required String customerId,
    required Debt debt,
  }) async {
    final model = DebtModel(
      id: debt.id,
      amount: debt.amount,
      description: debt.description,
      notes: debt.notes,
      date: debt.date,
      createdAt: debt.createdAt,
    );

    await dataSource.addDebt(
      uid: uid,
      customerId: customerId,
      data: model.toJson(),
    );
  }

  @override
  Future<List<Debt>> getDebts({
    required String uid,
    required String customerId,
  }) async {
    return await dataSource.getDebts(uid: uid, customerId: customerId);
  }

}