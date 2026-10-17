import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/domain/enums.dart';
import 'package:rentory/domain/rules/late_fee.dart';

void main() {
  final due = DateTime.utc(2026, 10, 10, 18);
  DateTime later(int days) => due.add(Duration(days: days, minutes: 1));

  test('a booking nobody collected is never late', () {
    final a = lineLateAccrual(
      LateLineInput(
        rentalState: RentalState.booked,
        dateEnd: due,
        priceDayNet: 40,
        quantity: 1,
      ),
      now: later(5),
      orderCancelled: false,
    );
    expect(a.fee, 0);
  });

  test('a cancelled order accrues nothing', () {
    final a = lineLateAccrual(
      LateLineInput(
        rentalState: RentalState.pickedUp,
        dateEnd: due,
        priceDayNet: 40,
        quantity: 1,
      ),
      now: later(3),
      orderCancelled: true,
    );
    expect(a.fee, 0);
  });

  test('untracked line: days late x quantity, counted to now while out', () {
    final a = lineLateAccrual(
      LateLineInput(
        rentalState: RentalState.pickedUp,
        dateEnd: due,
        priceDayNet: 10,
        quantity: 3,
      ),
      now: later(2), // 2 days and a minute: 3 started days
      orderCancelled: false,
    );
    expect(a.worstDays, 3);
    expect(a.unitDays, 9);
    expect(a.fee, 90);
  });

  test('returning the last unit freezes the fee instead of erasing it', () {
    final a = lineLateAccrual(
      LateLineInput(
        rentalState: RentalState.returned,
        dateEnd: due,
        priceDayNet: 10,
        quantity: 1,
        returnedAt: later(3),
      ),
      now: later(30),
      orderCancelled: false,
    );
    expect(a.worstDays, 4);
    expect(a.fee, 40);
  });

  test('serial line counts each unit against its own return', () {
    final a = lineLateAccrual(
      LateLineInput(
        rentalState: RentalState.pickedUp,
        dateEnd: due,
        priceDayNet: 100,
        quantity: 2,
        serialReturnedAt: [due.subtract(const Duration(hours: 1)), null],
      ),
      now: later(1), // second unit still out: 2 started days
      orderCancelled: false,
    );
    expect(a.unitDays, 2);
    expect(a.worstDays, 2);
    expect(a.fee, 200);
  });

  group('order late fee', () {
    final out = LateLineInput(
      rentalState: RentalState.pickedUp,
      dateEnd: due,
      priceDayNet: 50,
      quantity: 2,
    );

    test('discount ratio applies to accrued fee and daily rate', () {
      final f = orderLateFee(
        lines: [(line: out, qtyOutstanding: 1)],
        now: later(0), // one started day late
        orderCancelled: false,
        discountRatio: 0.8,
      );
      expect(f.amount, 80); // 50 x 2 units x 1 day x 0.8
      expect(f.daysBilled, 1);
      expect(f.dailyRate, 40); // tomorrow costs the 1 unit still out
      expect(f.wasLate, isTrue);
    });

    test('manual day count bills everything that left', () {
      final back = LateLineInput(
        rentalState: RentalState.returned,
        dateEnd: due,
        priceDayNet: 20,
        quantity: 1,
        returnedAt: later(5),
      );
      final f = orderLateFee(
        lines: [(line: back, qtyOutstanding: 0)],
        now: later(6),
        orderCancelled: false,
        discountRatio: 1,
        manual: true,
        daysEdited: true,
        daysOverride: 2,
      );
      expect(f.amount, 40);
      expect(f.daysBilled, 2);
      expect(f.dailyRate, 0);
    });
  });
}
