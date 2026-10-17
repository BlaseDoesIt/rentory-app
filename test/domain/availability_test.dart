import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/domain/enums.dart';
import 'package:rentory/domain/rules/availability.dart';

DateTime d(int day, [int hour = 9]) => DateTime.utc(2026, 10, day, hour);

Claim claim({
  String line = 'L1',
  String order = 'O1',
  OrderState orderState = OrderState.booked,
  RentalState rentalState = RentalState.booked,
  required DateTime start,
  required DateTime end,
  double qty = 1,
  Set<String> serials = const {},
}) => Claim(
  lineId: line,
  orderId: order,
  assetId: 'cam',
  orderState: orderState,
  rentalState: rentalState,
  start: start,
  end: end,
  qtyOutstanding: qty,
  serialIds: serials,
);

const serials = [
  SerialFacts(id: 's1', name: 'CAM-001', state: SerialState.available),
  SerialFacts(id: 's2', name: 'CAM-002', state: SerialState.reserved),
  SerialFacts(id: 's3', name: 'CAM-003', state: SerialState.maintenance),
  SerialFacts(
    id: 's4',
    name: 'CAM-004',
    state: SerialState.available,
    blockedByPart: true,
  ),
];

void main() {
  final now = d(1);

  test('back-to-back rentals never clash', () {
    final c = claim(start: d(5), end: d(7));
    final ask = Ask(start: d(7), end: d(9));
    expect(overlaps(c, ask, now), isFalse);
  });

  test('a draft quotation holds nothing for other orders', () {
    final c = claim(orderState: OrderState.draft, start: d(5), end: d(7));
    final free = freeQuantity(
      rentableQty: 1,
      assetId: 'cam',
      claims: [c],
      ask: Ask(start: d(5), end: d(6), orderId: 'O2'),
      now: now,
    );
    expect(free, 1);
  });

  test('a draft order competes with its own lines', () {
    final c = claim(orderState: OrderState.draft, start: d(5), end: d(7));
    final free = freeQuantity(
      rentableQty: 1,
      assetId: 'cam',
      claims: [c],
      ask: Ask(start: d(5), end: d(6), orderId: 'O1', ignoreLineIds: {'L2'}),
      now: now,
    );
    expect(free, 0);
  });

  test('a returned line and a cancelled order hold nothing', () {
    final claims = [
      claim(rentalState: RentalState.returned, start: d(5), end: d(7)),
      claim(
        line: 'L2',
        orderState: OrderState.cancelled,
        start: d(5),
        end: d(7),
      ),
    ];
    expect(
      freeQuantity(
        rentableQty: 2,
        assetId: 'cam',
        claims: claims,
        ask: Ask(start: d(5), end: d(6)),
        now: now,
      ),
      2,
    );
  });

  test('a unit out past its end date holds on until now', () {
    final late = claim(
      orderState: OrderState.pickedUp,
      rentalState: RentalState.pickedUp,
      start: d(1),
      end: d(3),
      serials: {'s1'},
    );
    final today = d(4);
    // Asking for a window that has begun: the overdue unit clashes.
    expect(overlaps(late, Ask(start: d(3, 12), end: d(5)), today), isTrue);
    // A booking for next week is still possible.
    expect(overlaps(late, Ask(start: d(10), end: d(12)), today), isFalse);
  });

  test('free serials skip unfit, blocked and held units', () {
    final held = claim(start: d(5), end: d(7), serials: {'s2'});
    final options = freeSerials(
      serials: serials,
      assetId: 'cam',
      claims: [held],
      ask: Ask(start: d(6), end: d(8)),
      now: now,
    );
    expect(options.map((o) => o.serial.id), ['s1']);
  });

  test('a unit reserved for other dates is offered', () {
    final held = claim(start: d(5), end: d(7), serials: {'s2'});
    final options = freeSerials(
      serials: serials,
      assetId: 'cam',
      claims: [held],
      ask: Ask(start: d(8), end: d(9)),
      now: now,
    );
    expect(options.map((o) => o.serial.id), ['s1', 's2']);
  });

  test('overdue units are tagged and never autofilled', () {
    final late = claim(
      orderState: OrderState.pickedUp,
      rentalState: RentalState.pickedUp,
      start: d(1),
      end: d(3),
      serials: {'s1'},
    );
    final options = freeSerials(
      serials: serials,
      assetId: 'cam',
      claims: [late],
      ask: Ask(start: d(10), end: d(12)),
      now: d(4),
    );
    expect(options.firstWhere((o) => o.serial.id == 's1').overdue, isTrue);
    expect(autofillSerials(options, 2).map((s) => s.id), ['s2']);
  });
}
