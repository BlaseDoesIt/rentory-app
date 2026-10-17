import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/domain/enums.dart';
import 'package:rentory/domain/rules/money.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 1, 9);

  group('billableDays', () {
    test('missing end is zero days', () {
      expect(billableDays(t0, null), 0);
    });
    test('any started day is a whole day', () {
      expect(billableDays(t0, t0.add(const Duration(hours: 1))), 1);
      expect(billableDays(t0, t0.add(const Duration(hours: 24))), 1);
      expect(billableDays(t0, t0.add(const Duration(hours: 25))), 2);
    });
    test('inverted window still bills one day', () {
      expect(billableDays(t0, t0.subtract(const Duration(days: 2))), 1);
    });
  });

  group('daysOver', () {
    test('back on time is zero, an hour late is a day', () {
      expect(daysOver(t0, t0), 0);
      expect(daysOver(t0, t0.subtract(const Duration(hours: 3))), 0);
      expect(daysOver(t0, t0.add(const Duration(hours: 1))), 1);
    });
  });

  test('line subtotal applies line discount, quantity and days', () {
    expect(
      lineSubtotal(priceDay: 50, discountPercent: 10, quantity: 2, days: 3),
      270,
    );
  });

  group('order discount', () {
    test('percent is capped at 100', () {
      expect(orderDiscount(200, DiscountType.percent, 150), 200);
    });
    test('fixed never goes past the lines total', () {
      expect(orderDiscount(80, DiscountType.fixed, 100), 80);
    });
    test('zero or negative is no discount', () {
      expect(orderDiscount(80, DiscountType.fixed, -5), 0);
    });
    test('ratio on an empty order is 1', () {
      expect(discountRatio(0, DiscountType.percent, 20), 1);
    });
  });

  group('orderAmounts', () {
    test('late fee is charged on top, deposit is not', () {
      final a = orderAmounts(
        lineSubtotals: [100, 50],
        discountType: DiscountType.percent,
        discountValue: 10,
        lateFee: 20,
        paid: 100,
      );
      expect(a.lines, 150);
      expect(a.discount, 15);
      expect(a.total, 135);
      expect(a.charged, 155);
      expect(a.due, 55);
      expect(a.paymentState, PaymentState.due);
    });
    test('overpaid is paid and due floors at zero', () {
      final a = orderAmounts(
        lineSubtotals: [100],
        discountType: DiscountType.fixed,
        discountValue: 0,
        lateFee: 0,
        paid: 120,
      );
      expect(a.due, 0);
      expect(a.paymentState, PaymentState.paid);
      expect(a.paymentProgress, 100);
    });
  });

  test('payment state compares at cent precision', () {
    expect(paymentState(charged: 10.0, paid: 9.999), PaymentState.paid);
    expect(paymentState(charged: 10.0, paid: 0.001), PaymentState.notPaid);
  });
}
