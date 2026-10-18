/// Order lifecycle, ported from `rentory.order` (`action_book`,
/// `_check_pickup_allowed`, `action_cancel`, `action_draft`,
/// `_sync_state_from_lines`, `_compute_overdue`).
///
/// Guards return a list of problems in plain words; empty means allowed.
library;

import '../enums.dart';
import 'money.dart';

/// The bits of a line the lifecycle rules look at.
class LineFacts {
  const LineFacts({
    required this.type,
    required this.rentalState,
    this.name = '',
    this.quantity = 1,
    this.tracking = Tracking.none,
    this.serialCount = 0,
  });

  final LineType type;
  final RentalState rentalState;
  final String name;
  final double quantity;

  /// Of the line's asset; only meaningful for asset lines.
  final Tracking tracking;
  final int serialCount;

  bool get isSection => type == LineType.section;

  /// A serial-tracked asset line must name exactly as many units as it sells.
  bool get missingSerials =>
      type == LineType.asset &&
      tracking == Tracking.serial &&
      serialCount != quantity.round();
}

/// Draft and Cancelled are set by hand; the middle states follow the lines.
OrderState deriveOrderState(OrderState current, Iterable<LineFacts> lines) {
  if (current == OrderState.draft || current == OrderState.cancelled) {
    return current;
  }
  final states = {
    for (final l in lines)
      if (!l.isSection) l.rentalState,
  };
  if (states.isEmpty) return current;
  if (states.length == 1 && states.first == RentalState.returned) {
    return OrderState.returned;
  }
  if (states.contains(RentalState.pickedUp)) {
    return states.contains(RentalState.returned)
        ? OrderState.partialReturn
        : OrderState.pickedUp;
  }
  if (states.contains(RentalState.returned)) return OrderState.partialReturn;
  return OrderState.booked;
}

/// Problems standing between this order and Book. Availability is checked
/// separately (it needs other orders) and, in the end, by the server.
List<String> bookProblems(OrderState state, List<LineFacts> lines) {
  if (state != OrderState.draft && state != OrderState.cancelled) {
    return ['Only a draft or cancelled order can be booked.'];
  }
  if (!lines.any((l) => !l.isSection)) {
    return ['Add at least one item or service before booking.'];
  }
  return [
    for (final l in lines)
      if (l.missingSerials)
        '${l.name}: quantity ${l.quantity.round()}, '
            '${l.serialCount} unit(s) picked. Pick the units first.',
  ];
}

/// Only the signed Rental Contract blocks a handover. An admin may force it.
List<String> pickupProblems({
  required bool rentalContractSigned,
  bool forcedByAdmin = false,
}) {
  if (rentalContractSigned || forcedByAdmin) return const [];
  return ['Rental Contract not signed.'];
}

/// Line moves an order-wide pickup performs: everything not yet out.
bool canPickUpLine(LineFacts l) =>
    !l.isSection &&
    (l.rentalState == RentalState.none || l.rentalState == RentalState.booked);

List<String> cancelProblems(List<LineFacts> lines) {
  final out = lines.where((l) => l.rentalState == RentalState.pickedUp).length;
  return out == 0
      ? const []
      : ['$out item(s) are still with the customer. Return them first.'];
}

List<String> resetToDraftProblems(List<LineFacts> lines) =>
    lines.any((l) => l.rentalState == RentalState.pickedUp)
    ? const ['Items are out. Return them before resetting to draft.']
    : const [];

/// Overdue: committed, past its end date, and something not back yet.
bool isOverdue({
  required OrderState state,
  required DateTime? dateEnd,
  required Iterable<LineFacts> lines,
  required DateTime now,
}) =>
    OrderState.committed.contains(state) &&
    dateEnd != null &&
    dateEnd.isBefore(now) &&
    lines.any((l) => !l.isSection && l.rentalState != RentalState.returned);

/// Days late for the badge; any started day counts.
int daysLate({
  required bool overdue,
  required DateTime? dateEnd,
  required DateTime now,
}) => overdue ? billableDays(dateEnd, now) : 0;

/// Where a unit goes when it is checked in: missing is written off as lost,
/// damaged goes to maintenance, anything else back on the shelf.
SerialState serialStateAfterReturn(Condition condition) => switch (condition) {
  Condition.missing => SerialState.lost,
  Condition.damaged => SerialState.maintenance,
  Condition.minor || Condition.good => SerialState.available,
};

/// Order dates must run forwards.
String? datesProblem(DateTime? start, DateTime? end) =>
    start != null && end != null && !end.isAfter(start)
    ? 'The end date must be after the start date.'
    : null;
