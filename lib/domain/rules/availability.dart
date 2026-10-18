/// Availability by calendar, ported from `rentory.order.line`
/// (`_rentory_claim_domain`, `_rentory_claim_end`, `_rentory_window_domain`,
/// `_rentory_committed_qty`, `_compute_available_serial_ids`).
///
/// A unit is offered for any window its own bookings do not cover. Windows
/// are half-open, so back-to-back rentals never clash. A unit that is out
/// past its return date holds on until *now*, never to infinity.
library;

import '../enums.dart';

/// One order line holding (or about to hold) kit.
class Claim {
  const Claim({
    required this.lineId,
    required this.orderId,
    required this.assetId,
    required this.orderState,
    required this.rentalState,
    required this.start,
    required this.end,
    required this.qtyOutstanding,
    this.serialIds = const {},
  });

  final String lineId;
  final String orderId;
  final String assetId;
  final OrderState orderState;
  final RentalState rentalState;
  final DateTime start;
  final DateTime end;

  /// What the line still holds: units already checked back in are free.
  final double qtyOutstanding;

  /// Units the line still holds (outstanding only).
  final Set<String> serialIds;

  /// When the claim really lets go: its end, or now if it is out and late.
  DateTime claimEnd(DateTime now) =>
      rentalState == RentalState.pickedUp && now.isAfter(end) ? now : end;

  /// Out with the customer past its end date.
  bool overdueAt(DateTime now) =>
      rentalState == RentalState.pickedUp && now.isAfter(end);
}

/// The window being asked about, and the order asking (whose own lines
/// compete with each other even while it is still a draft).
class Ask {
  const Ask({
    required this.start,
    required this.end,
    this.orderId,
    this.ignoreLineIds = const {},
  });

  final DateTime start;
  final DateTime end;
  final String? orderId;
  final Set<String> ignoreLineIds;
}

/// Does [c] count against [ask] at all, before looking at dates?
bool _counts(Claim c, Ask ask) {
  if (ask.ignoreLineIds.contains(c.lineId)) return false;
  if (c.rentalState == RentalState.returned) return false;
  if (c.orderState == OrderState.cancelled) return false;
  return OrderState.conflicting.contains(c.orderState) ||
      (ask.orderId != null && c.orderId == ask.orderId);
}

/// Half-open overlap, with overdue claims stretched to [now].
bool overlaps(Claim c, Ask ask, DateTime now) =>
    c.start.isBefore(ask.end) && c.claimEnd(now).isAfter(ask.start);

/// The claims standing in the way of [ask] for one asset.
Iterable<Claim> blockingClaims(
  Iterable<Claim> claims,
  String assetId,
  Ask ask,
  DateTime now,
) => claims.where(
  (c) => c.assetId == assetId && _counts(c, ask) && overlaps(c, ask, now),
);

/// How many of an untracked asset are free over [ask].
double freeQuantity({
  required double rentableQty,
  required String assetId,
  required Iterable<Claim> claims,
  required Ask ask,
  required DateTime now,
}) {
  final held = blockingClaims(
    claims,
    assetId,
    ask,
    now,
  ).fold<double>(0, (a, c) => a + c.qtyOutstanding);
  final free = rentableQty - held;
  return free < 0 ? 0 : free;
}

class SerialFacts {
  const SerialFacts({
    required this.id,
    required this.name,
    required this.state,
  });

  final String id;
  final String name;
  final SerialState state;

  bool get fitToPromise => !state.unfit;
}

class SerialOption {
  const SerialOption(this.serial, {required this.overdue});
  final SerialFacts serial;

  /// Free for these dates on paper, but currently out past its return date.
  /// Shown with an 'Overdue' tag, never autofilled.
  final bool overdue;
}

/// Units of one asset that can be promised over [ask], sorted by name.
List<SerialOption> freeSerials({
  required List<SerialFacts> serials,
  required String assetId,
  required Iterable<Claim> claims,
  required Ask ask,
  required DateTime now,
}) {
  final assetClaims = claims.where((c) => c.assetId == assetId).toList();
  final held = <String>{
    for (final c in blockingClaims(assetClaims, assetId, ask, now))
      ...c.serialIds,
  };
  final atRisk = <String>{
    for (final c in assetClaims)
      if (c.overdueAt(now)) ...c.serialIds,
  };
  final options = [
    for (final s in serials)
      if (s.fitToPromise && !held.contains(s.id))
        SerialOption(s, overdue: atRisk.contains(s.id)),
  ]..sort((a, b) => a.serial.name.compareTo(b.serial.name));
  return options;
}

/// Pick [count] units for a line: free, not overdue anywhere, by name.
/// Returns fewer than [count] when there are not enough.
List<SerialFacts> autofillSerials(List<SerialOption> options, int count) => [
  for (final o in options)
    if (!o.overdue) o.serial,
].take(count).toList();
