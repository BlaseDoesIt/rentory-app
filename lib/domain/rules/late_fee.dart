/// Late fees, ported from `rentory.order.line._compute_late_accrual` and
/// `rentory.order._compute_late_fee`.
///
/// Accrued, not forward-looking: each unit is counted against the moment it
/// actually came back, so checking the last item in stops the meter without
/// erasing the reading.
library;

import '../enums.dart';
import 'money.dart';

/// What a line needs for its late fee.
class LateLineInput {
  const LateLineInput({
    required this.rentalState,
    required this.dateEnd,
    required this.priceDayNet,
    required this.quantity,
    this.serialReturnedAt,
    this.returnedAt,
  });

  final RentalState rentalState;
  final DateTime? dateEnd;
  final double priceDayNet;
  final double quantity;

  /// Serial-tracked lines: one entry per unit on the line, null while that
  /// unit is still out. Null (not empty) for untracked lines.
  final List<DateTime?>? serialReturnedAt;

  /// Untracked lines: when the whole line came back.
  final DateTime? returnedAt;
}

class LateAccrual {
  const LateAccrual(this.unitDays, this.worstDays, this.fee);
  static const zero = LateAccrual(0, 0, 0);

  /// Late days summed over every unit.
  final double unitDays;

  /// The latest single unit, in days.
  final int worstDays;
  final double fee;
}

LateAccrual lineLateAccrual(
  LateLineInput line, {
  required DateTime now,
  required bool orderCancelled,
}) {
  final deadline = line.dateEnd;
  if (!line.rentalState.goneOut || deadline == null || orderCancelled) {
    return LateAccrual.zero;
  }

  var unitDays = 0.0;
  var worst = 0;
  final serials = line.serialReturnedAt;
  if (serials != null && serials.isNotEmpty) {
    for (final back in serials) {
      final days = daysOver(deadline, back ?? now);
      unitDays += days;
      if (days > worst) worst = days;
    }
  } else {
    final back =
        line.rentalState == RentalState.returned ? line.returnedAt : null;
    worst = daysOver(deadline, back ?? now);
    unitDays = worst * line.quantity;
  }
  return LateAccrual(unitDays, worst, line.priceDayNet * unitDays);
}

class OrderLateFee {
  const OrderLateFee({
    required this.amount,
    required this.daysBilled,
    required this.dailyRate,
  });

  /// Accrued late fee after the order discount.
  final double amount;
  final int daysBilled;

  /// What one more day would cost on the units still out.
  final double dailyRate;
  bool get wasLate => daysBilled > 0;
}

/// [lines] pairs each line's input with how many of its units are still out.
OrderLateFee orderLateFee({
  required List<({LateLineInput line, double qtyOutstanding})> lines,
  required DateTime now,
  required bool orderCancelled,
  required double discountRatio,
  bool manual = false,
  bool daysEdited = false,
  int daysOverride = 0,
}) {
  // Charge tomorrow on units still out, not whole lines, and only on kit
  // that has left: nothing on our own shelf can be late.
  final rawRate = lines
      .where((l) => l.line.rentalState == RentalState.pickedUp)
      .fold<double>(0, (a, l) => a + l.line.priceDayNet * l.qtyOutstanding);
  final dailyRate = roundMoney(rawRate * discountRatio);

  if (manual && daysEdited) {
    // Hand-set day count, billed on everything that actually left,
    // including what is already back.
    final days = daysOverride < 0 ? 0 : daysOverride;
    final rate = lines
        .where((l) => l.line.rentalState.goneOut)
        .fold<double>(0, (a, l) => a + l.line.priceDayNet * l.line.quantity);
    return OrderLateFee(
      amount: roundMoney(rate * days * discountRatio),
      daysBilled: days,
      dailyRate: dailyRate,
    );
  }

  var fees = 0.0;
  var worst = 0;
  for (final l in lines) {
    final a =
        lineLateAccrual(l.line, now: now, orderCancelled: orderCancelled);
    fees += a.fee;
    if (a.worstDays > worst) worst = a.worstDays;
  }
  return OrderLateFee(
    amount: roundMoney(fees * discountRatio),
    daysBilled: worst,
    dailyRate: dailyRate,
  );
}
