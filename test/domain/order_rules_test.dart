import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/domain/enums.dart';
import 'package:rentory/domain/rules/order_rules.dart';

LineFacts line(RentalState s, {LineType type = LineType.asset}) =>
    LineFacts(type: type, rentalState: s);

void main() {
  group('deriveOrderState', () {
    test('draft and cancelled are never derived', () {
      expect(
        deriveOrderState(OrderState.draft, [line(RentalState.pickedUp)]),
        OrderState.draft,
      );
      expect(
        deriveOrderState(OrderState.cancelled, [line(RentalState.returned)]),
        OrderState.cancelled,
      );
    });
    test('the middle states follow the lines', () {
      expect(
        deriveOrderState(OrderState.booked, [line(RentalState.pickedUp)]),
        OrderState.pickedUp,
      );
      expect(
        deriveOrderState(OrderState.pickedUp, [
          line(RentalState.pickedUp),
          line(RentalState.returned),
        ]),
        OrderState.partialReturn,
      );
      expect(
        deriveOrderState(OrderState.partialReturn, [
          line(RentalState.returned),
          line(RentalState.returned),
        ]),
        OrderState.returned,
      );
    });
    test('a section heading never holds an order open', () {
      expect(
        deriveOrderState(OrderState.pickedUp, [
          line(RentalState.returned),
          line(RentalState.none, type: LineType.section),
        ]),
        OrderState.returned,
      );
    });
    test('a new line on a closed order reopens it', () {
      expect(
        deriveOrderState(OrderState.returned, [
          line(RentalState.returned),
          line(RentalState.booked),
        ]),
        OrderState.partialReturn,
      );
    });
  });

  group('bookProblems', () {
    test('an order of only headings has nothing on it', () {
      expect(
        bookProblems(OrderState.draft, [
          line(RentalState.none, type: LineType.section),
        ]),
        isNotEmpty,
      );
    });
    test('serial lines must name as many units as they sell', () {
      const camera = LineFacts(
        type: LineType.asset,
        rentalState: RentalState.none,
        name: 'FX6',
        quantity: 2,
        tracking: Tracking.serial,
        serialCount: 1,
      );
      final problems = bookProblems(OrderState.draft, [camera]);
      expect(problems.single, contains('FX6'));
    });
    test('a booked order cannot be booked again', () {
      expect(
        bookProblems(OrderState.booked, [line(RentalState.booked)]),
        isNotEmpty,
      );
    });
  });

  test('only the rental contract blocks pickup, and an admin can force it', () {
    expect(pickupProblems(rentalContractSigned: false), isNotEmpty);
    expect(pickupProblems(rentalContractSigned: true), isEmpty);
    expect(
      pickupProblems(rentalContractSigned: false, forcedByAdmin: true),
      isEmpty,
    );
  });

  test('cannot cancel or reset while items are out', () {
    final lines = [line(RentalState.pickedUp)];
    expect(cancelProblems(lines), isNotEmpty);
    expect(resetToDraftProblems(lines), isNotEmpty);
    expect(cancelProblems([line(RentalState.booked)]), isEmpty);
  });

  test('overdue needs a committed order past its end with kit not back', () {
    final now = DateTime.utc(2026, 10, 20);
    final end = DateTime.utc(2026, 10, 18);
    expect(
      isOverdue(
        state: OrderState.pickedUp,
        dateEnd: end,
        lines: [line(RentalState.pickedUp)],
        now: now,
      ),
      isTrue,
    );
    expect(
      isOverdue(
        state: OrderState.draft,
        dateEnd: end,
        lines: [line(RentalState.none)],
        now: now,
      ),
      isFalse,
    );
    expect(daysLate(overdue: true, dateEnd: end, now: now), 2);
  });

  test('return conditions decide where a unit goes', () {
    expect(serialStateAfterReturn(Condition.missing), SerialState.lost);
    expect(serialStateAfterReturn(Condition.damaged), SerialState.maintenance);
    expect(serialStateAfterReturn(Condition.minor), SerialState.available);
    expect(
      Condition.worst([Condition.good, Condition.damaged]),
      Condition.damaged,
    );
  });
}
