/// Billable days and money, ported from Rentory (`rentory_duration.py`,
/// `rentory.order._compute_amounts`, `rentory.order.line._compute_prices`).
library;

import '../enums.dart';

/// Round to the currency's precision. Every stored or shown amount goes
/// through here, never raw float arithmetic.
double roundMoney(double value, {int decimals = 2}) {
  final factor = _pow10(decimals);
  return (value * factor).roundToDouble() / factor;
}

double _pow10(int n) {
  var r = 1.0;
  for (var i = 0; i < n; i++) {
    r *= 10;
  }
  return r;
}

/// Billable days between two moments: any started day is a whole day.
/// 0 when either end is missing, otherwise at least 1 (an inverted window
/// still bills one day, so a half-filled form never shows a zero subtotal).
int billableDays(DateTime? start, DateTime? end) {
  if (start == null || end == null) return 0;
  final seconds = end.difference(start).inSeconds;
  if (seconds <= 0) return 1;
  final days = (seconds / Duration.secondsPerDay).ceil();
  return days < 1 ? 1 : days;
}

/// Late days between a deadline and a moment, floored at zero: back on time
/// is zero days, not the one day [billableDays] would say.
int daysOver(DateTime? deadline, DateTime? moment) {
  if (deadline == null || moment == null || !moment.isAfter(deadline)) {
    return 0;
  }
  return billableDays(deadline, moment);
}

/// Daily price after the line's own percentage discount.
double priceDayNet(double priceDay, double discountPercent) =>
    priceDay * (1.0 - discountPercent / 100.0);

/// What a line sells for: net daily price x quantity x billable days.
double lineSubtotal({
  required double priceDay,
  required double discountPercent,
  required double quantity,
  required int days,
}) => priceDayNet(priceDay, discountPercent) * quantity * days;

/// The order-level discount in money, clamped to [0, linesTotal].
double orderDiscount(double linesTotal, DiscountType type, double value) {
  if (value <= 0) return 0;
  final raw = type == DiscountType.fixed
      ? value
      : linesTotal * (value > 100 ? 100 : value) / 100.0;
  if (raw < 0) return 0;
  return raw > linesTotal ? linesTotal : raw;
}

/// Share of the lines total that survives the order discount. Late fees are
/// discounted by the same ratio, so a customer on 20% off pays 20% less per
/// late day too.
double discountRatio(double linesTotal, DiscountType type, double value) {
  if (linesTotal <= 0) return 1.0;
  return (linesTotal - orderDiscount(linesTotal, type, value)) / linesTotal;
}

class OrderAmounts {
  const OrderAmounts({
    required this.lines,
    required this.discount,
    required this.total,
    required this.lateFee,
    required this.charged,
    required this.paid,
    required this.due,
    required this.paymentState,
  });

  /// Sum of line subtotals, before the order discount.
  final double lines;
  final double discount;

  /// Lines minus discount: what was quoted.
  final double total;
  final double lateFee;

  /// Total plus late fee: what the customer owes in all.
  final double charged;
  final double paid;
  final double due;
  final PaymentState paymentState;

  /// 0 to 100, for the payment ring.
  double get paymentProgress =>
      charged > 0 ? (100.0 * paid / charged).clamp(0, 100).toDouble() : 0.0;
}

/// The order's money. The deposit is held, not charged, so it is not in here.
OrderAmounts orderAmounts({
  required Iterable<double> lineSubtotals,
  required DiscountType discountType,
  required double discountValue,
  required double lateFee,
  required double paid,
}) {
  final lines = lineSubtotals.fold<double>(0, (a, b) => a + b);
  final discount = roundMoney(
    orderDiscount(lines, discountType, discountValue),
  );
  final total = roundMoney(lines - discount);
  final charged = roundMoney(total + lateFee);
  final due = charged - paid > 0 ? roundMoney(charged - paid) : 0.0;
  return OrderAmounts(
    lines: lines,
    discount: discount,
    total: total,
    lateFee: lateFee,
    charged: charged,
    paid: paid,
    due: due,
    paymentState: paymentState(charged: charged, paid: paid),
  );
}

/// Compared at cent precision, never as raw floats.
PaymentState paymentState({required double charged, required double paid}) {
  final p = roundMoney(paid);
  final c = roundMoney(charged);
  if (p <= 0) return PaymentState.notPaid;
  if (c > 0 && p >= c) return PaymentState.paid;
  return PaymentState.due;
}
