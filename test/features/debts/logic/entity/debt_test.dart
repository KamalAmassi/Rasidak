import 'package:flutter_test/flutter_test.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';

void main() {
  group('اختبارات كلاس Debt', () {

    test('يجب أن يتم إنشاء الدين بالقيم الصحيحة', () {
      final debt = Debt(
        id: '1',
        amount: 100.0,
        description: 'حليب وخبز',
        notes: 'ملاحظة تجريبية',
        date: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      );

      expect(debt.amount, 100.0);
      expect(debt.description, 'حليب وخبز');
      expect(debt.id, '1');
    });

    test('يجب أن يكون المبلغ رقم موجب دائماً بالحالات الطبيعية', () {
      final debt = Debt(
        id: '2',
        amount: 250.5,
        description: '',
        notes: '',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(debt.amount, greaterThan(0));
    });

  });
}