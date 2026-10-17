import 'package:intl/intl.dart';

import '../domain/enums.dart';

final _money = NumberFormat('#,##0.00');
final _date = DateFormat('d MMM, HH:mm');

String money(double v) => _money.format(v);

String when(DateTime? d) => d == null ? '' : _date.format(d.toLocal());

String qty(double q) =>
    q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(2);

String orderStateLabel(OrderState s) => switch (s) {
  OrderState.draft => 'Draft',
  OrderState.booked => 'Booked',
  OrderState.pickedUp => 'Picked up',
  OrderState.partialReturn => 'Partial return',
  OrderState.returned => 'Returned',
  OrderState.cancelled => 'Cancelled',
};

String rentalStateLabel(RentalState s) => switch (s) {
  RentalState.none => 'Not booked',
  RentalState.booked => 'Booked',
  RentalState.pickedUp => 'Out',
  RentalState.returned => 'Back',
};
