/// Late fees, ported from `rentory.order.line._compute_late_accrual` and
/// `rentory.order._compute_late_fee` (Rentory 2.9.2).
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

/// How late one unit (or one untracked line's units) was.
typedef UnitLateSpan = ({int lateDays, double units, bool stillOut});

/// Ported from `rentory.order.line._rentory_unit_late_days` (Rentory 2.9.1).
///
/// A unit that is back is measured against its own check-in; one still out
/// against [now]. Empty for a line that never left or whose order was
/// cancelled.
List<UnitLateSpan> unitLateDays(
  LateLineInput line, {
  required DateTime now,
  required bool orderCancelled,
}) {
  final deadline = line.dateEnd;
  if (!line.rentalState.goneOut || deadline == null || orderCancelled) {
    return const [];
  }
  final serials = line.serialReturnedAt;
  if (serials != null && serials.isNotEmpty) {
    return [
      for (final back in serials)
        (
          lateDays: daysOver(deadline, back ?? now),
          units: 1.0,
          stillOut: back == null,
        ),
    ];
  }
  // Untracked items and services: one date for however many units.
  final back = line.rentalState == RentalState.returned
      ? line.returnedAt
      : null;
  return [
    (
      lateDays: daysOver(deadline, back ?? now),
      units: line.quantity,
      stillOut: back == null,
    ),
  ];
}

LateAccrual lineLateAccrual(
  LateLineInput line, {
  required DateTime now,
  required bool orderCancelled,
}) {
  final spans = unitLateDays(line, now: now, orderCancelled: orderCancelled);
  var unitDays = 0.0;
  var worst = 0;
  for (final s in spans) {
    unitDays += s.lateDays * s.units;
    if (s.lateDays > worst) worst = s.lateDays;
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
    // Hand-set day count, applied unit by unit (Rentory 2.9.1/2.9.2): what
    // is still out pays the typed count; a unit already back pays its own
    // late days, never more than the count. Once everything is back, the
    // units that came back last stand in for "still out", so a day can
    // still be added to or shaved off a settled order.
    final days = daysOverride < 0 ? 0 : daysOverride;
    final spans = [
      for (final l in lines)
        for (final s in unitLateDays(
          l.line,
          now: now,
          orderCancelled: orderCancelled,
        ))
          (price: l.line.priceDayNet, span: s),
    ];
    final anythingOut = spans.any((e) => e.span.stillOut);
    final worst = spans.fold<int>(
      0,
      (a, e) => e.span.lateDays > a ? e.span.lateDays : a,
    );
    int charged(UnitLateSpan s) {
      final paysCount = anythingOut ? s.stillOut : s.lateDays >= worst;
      if (paysCount) return days;
      return s.lateDays < days ? s.lateDays : days;
    }

    final raw = spans.fold<double>(
      0,
      (a, e) => a + e.price * e.span.units * charged(e.span),
    );
    return OrderLateFee(
      amount: roundMoney(raw * discountRatio),
      daysBilled: days,
      dailyRate: dailyRate,
    );
  }

  var fees = 0.0;
  var worst = 0;
  for (final l in lines) {
    final a = lineLateAccrual(l.line, now: now, orderCancelled: orderCancelled);
    fees += a.fee;
    if (a.worstDays > worst) worst = a.worstDays;
  }
  return OrderLateFee(
    amount: roundMoney(fees * discountRatio),
    daysBilled: worst,
    dailyRate: dailyRate,
  );
}
