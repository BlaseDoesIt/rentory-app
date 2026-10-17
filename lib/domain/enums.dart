/// Rentory's selection fields. Every `key` is the exact value Odoo stores, so
/// the same strings go into SQLite, Supabase and the Odoo JSON-2 API.
library;

enum OrderState {
  draft('draft'),
  booked('booked'),
  pickedUp('picked_up'),
  partialReturn('partial_return'),
  returned('returned'),
  cancelled('cancelled');

  const OrderState(this.key);
  final String key;
  static OrderState fromKey(String key) => _byKey(values, key, (e) => e.key);

  /// Orders whose lines hold units against other orders.
  static const committed = {booked, pickedUp, partialReturn};

  /// What availability is measured against. A draft is not on it: an
  /// unconfirmed quotation holds nothing (Rentory 1.6.0). 'returned' covers
  /// an order whose lines have not all come back; a returned line is excluded
  /// separately by its own state.
  static const conflicting = {booked, pickedUp, partialReturn, returned};
}

enum LineType {
  asset('asset'),
  part('part'),
  service('service'),
  section('section');

  const LineType(this.key);
  final String key;
  static LineType fromKey(String key) => _byKey(values, key, (e) => e.key);
}

enum RentalState {
  none('none'),
  booked('booked'),
  pickedUp('picked_up'),
  returned('returned');

  const RentalState(this.key);
  final String key;
  static RentalState fromKey(String key) => _byKey(values, key, (e) => e.key);

  /// The kit has actually left the building. Only these accrue a late fee:
  /// a booking nobody collected is a no-show, not a late return.
  bool get goneOut => this == pickedUp || this == returned;
}

enum Tracking {
  none('none'),
  serial('serial');

  const Tracking(this.key);
  final String key;
  static Tracking fromKey(String key) => _byKey(values, key, (e) => e.key);
}

enum SerialState {
  available('available'),
  reserved('reserved'),
  out('out'),
  mandatoryOut('mandatory_out'),
  maintenance('maintenance'),
  lost('lost'),
  retired('retired');

  const SerialState(this.key);
  final String key;
  static SerialState fromKey(String key) => _byKey(values, key, (e) => e.key);

  /// Units that can never be promised, whatever the calendar says.
  bool get unfit => this == maintenance || this == lost || this == retired;
}

enum PartKind {
  mandatory('mandatory'),
  supply('supply'),
  none('none');

  const PartKind(this.key);
  final String key;
  static PartKind fromKey(String key) => _byKey(values, key, (e) => e.key);
}

enum PartState {
  available('available'),
  reserved('reserved'),
  out('out');

  const PartState(this.key);
  final String key;
  static PartState fromKey(String key) => _byKey(values, key, (e) => e.key);
}

/// Condition of a unit or part when it comes back. Ranked worst first.
enum Condition {
  missing('missing'),
  damaged('damaged'),
  minor('minor'),
  good('good');

  const Condition(this.key);
  final String key;
  static Condition fromKey(String key) => _byKey(values, key, (e) => e.key);

  /// Should not go straight back on the shelf.
  bool get isProblem => this == missing || this == damaged;

  /// The worst of [conditions], or null when there are none.
  static Condition? worst(Iterable<Condition> conditions) {
    Condition? result;
    for (final c in conditions) {
      if (result == null || c.index < result.index) result = c;
    }
    return result;
  }
}

enum DiscountType {
  percent('percent'),
  fixed('fixed');

  const DiscountType(this.key);
  final String key;
  static DiscountType fromKey(String key) => _byKey(values, key, (e) => e.key);
}

enum PaymentState {
  notPaid('not_paid'),
  due('due'),
  paid('paid');

  const PaymentState(this.key);
  final String key;
  static PaymentState fromKey(String key) => _byKey(values, key, (e) => e.key);
}

enum Role {
  admin('admin'),
  office('office'),
  warehouse('warehouse');

  const Role(this.key);
  final String key;
  static Role fromKey(String key) => _byKey(values, key, (e) => e.key);
}

T _byKey<T>(List<T> values, String key, String Function(T) keyOf) {
  for (final v in values) {
    if (keyOf(v) == key) return v;
  }
  throw ArgumentError.value(key, 'key', 'Unknown ${T.toString()}');
}
