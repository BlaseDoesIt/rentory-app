/// Kit we hold on loan from a supplier (Rentory's "rented in" assets): where
/// the loan stands, and what a customer booking may do with it.
library;

enum RentedInStatus { upcoming, inHouse, dueSoon, overdue, returned }

/// How close "due soon" is.
const rentedInWarnHours = 48;

/// Where a loan stands at [now]. No due date reads as in house; the screens
/// warn about the missing date separately.
RentedInStatus rentedInStatus({
  required DateTime? heldFrom,
  required DateTime? dueBack,
  required DateTime? givenBackAt,
  required DateTime now,
}) {
  if (givenBackAt != null) return RentedInStatus.returned;
  if (heldFrom != null && now.isBefore(heldFrom)) {
    return RentedInStatus.upcoming;
  }
  if (dueBack == null) return RentedInStatus.inHouse;
  final hours = dueBack.difference(now).inMinutes / 60;
  if (hours < 0) return RentedInStatus.overdue;
  if (hours <= rentedInWarnHours) return RentedInStatus.dueSoon;
  return RentedInStatus.inHouse;
}

/// "3d 4h", "2h 15m", "45m": coarser the further away it is.
String formatSpan(Duration d) {
  final minutes = d.inMinutes.abs();
  final days = minutes ~/ (24 * 60);
  final hours = (minutes % (24 * 60)) ~/ 60;
  final mins = minutes % 60;
  if (days > 0) return '${days}d ${hours}h';
  if (hours > 0) return '${hours}h ${mins}m';
  return '${mins}m';
}

/// Why a line on a rented-in asset cannot have these dates, or null.
String? rentedInLineProblem({
  required String assetName,
  required String? supplier,
  required DateTime? heldFrom,
  required DateTime? dueBack,
  required DateTime? givenBackAt,
  required DateTime? lineStart,
  required DateTime? lineEnd,
}) {
  final who = (supplier ?? '').isEmpty ? 'its owner' : supplier!;
  if (givenBackAt != null) {
    return '$assetName has already gone back to $who.';
  }
  if (heldFrom != null && lineStart != null && lineStart.isBefore(heldFrom)) {
    return '$assetName is rented in and only ours from '
        '${_d(heldFrom)}; this line starts earlier.';
  }
  if (dueBack != null && lineEnd != null && lineEnd.isAfter(dueBack)) {
    return '$assetName is owed back to $who on ${_d(dueBack)}; '
        'this line runs later.';
  }
  return null;
}

String _d(DateTime t) {
  final l = t.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
}
