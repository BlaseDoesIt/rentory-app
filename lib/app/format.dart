import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../domain/enums.dart';
import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

// Numbers stay in English digits in Arabic too, as on blasedoesit.com.
final _money = NumberFormat('#,##0.00', 'en');

String money(double v) => _money.format(v);

String qty(double q) =>
    q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(2);

/// Arabic-Indic and Persian digits to 0-9, in case a locale slips them in.
String latinDigits(String s) => s.replaceAllMapped(RegExp('[٠-٩۰-۹]'), (m) {
  final c = m[0]!.codeUnitAt(0);
  return String.fromCharCode(0x30 + (c >= 0x06F0 ? c - 0x06F0 : c - 0x0660));
});

/// Month names follow the app language; digits are always 0-9.
String when(DateTime? d) => d == null
    ? ''
    : latinDigits(DateFormat('d MMM, HH:mm').format(d.toLocal()));

String day(DateTime? d) =>
    d == null ? '' : latinDigits(DateFormat('d MMM y').format(d.toLocal()));

/// Parses what someone typed into a number field: commas and Arabic digits
/// are fine. Null when it is not a number.
double? parseNumber(String text) {
  final t = latinDigits(text).replaceAll(',', '').replaceAll('٫', '.');
  return double.tryParse(t.trim());
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension Labels on AppLocalizations {
  String orderState(OrderState s) => switch (s) {
    OrderState.draft => stateDraft,
    OrderState.booked => stateBooked,
    OrderState.pickedUp => statePickedUp,
    OrderState.partialReturn => statePartialReturn,
    OrderState.returned => stateReturned,
    OrderState.cancelled => stateCancelled,
  };

  String rentalState(RentalState s) => switch (s) {
    RentalState.none => rentalNone,
    RentalState.booked => rentalBooked,
    RentalState.pickedUp => rentalOut,
    RentalState.returned => rentalBack,
  };

  String condition(Condition c) => switch (c) {
    Condition.good => conditionGood,
    Condition.minor => conditionMinor,
    Condition.damaged => conditionDamaged,
    Condition.missing => conditionMissing,
  };

  String serialState(SerialState s) => switch (s) {
    SerialState.available => serialAvailable,
    SerialState.reserved => serialReserved,
    SerialState.out => serialOut,
    SerialState.mandatoryOut => serialOut,
    SerialState.maintenance => serialMaintenance,
    SerialState.lost => serialLost,
    SerialState.retired => serialRetired,
  };

  String lineType(LineType t) => switch (t) {
    LineType.asset => lineAsset,
    LineType.part => linePart,
    LineType.service => lineService,
    LineType.section => lineSection,
  };
}
