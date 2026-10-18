/// What every screen talks to. The screens never touch SQLite, Supabase or
/// Odoo directly, so the backend behind this can change without them.
library;

import '../domain/enums.dart';
import '../domain/rules/availability.dart';
import '../domain/rules/money.dart';
import 'local/database.dart';

/// A rule said no. [problems] are plain sentences for the user.
class RuleException implements Exception {
  RuleException(this.problems);
  RuleException.one(String problem) : problems = [problem];
  final List<String> problems;

  @override
  String toString() => problems.join('\n');
}

class OrderSummary {
  const OrderSummary({
    required this.order,
    required this.customerLabel,
    required this.amounts,
    required this.itemCount,
    required this.overdue,
    required this.daysLate,
  });

  final Order order;
  final String customerLabel;
  final OrderAmounts amounts;
  final int itemCount;
  final bool overdue;
  final int daysLate;
}

class LineView {
  const LineView({
    required this.line,
    required this.asset,
    required this.serials,
    required this.returnChecks,
    required this.subtotal,
    required this.days,
    required this.qtyOutstanding,
  });

  final OrderLine line;
  final Asset? asset;
  final List<Serial> serials;
  final List<ReturnCheck> returnChecks;
  final double subtotal;
  final int days;
  final double qtyOutstanding;
}

class OrderDetail {
  const OrderDetail({
    required this.summary,
    required this.lines,
    required this.lateDailyRate,
  });

  final OrderSummary summary;
  final List<LineView> lines;
  final double lateDailyRate;
  Order get order => summary.order;
}

class AssetSummary {
  const AssetSummary({
    required this.asset,
    required this.categoryName,
    required this.total,
    required this.out,
  });

  final Asset asset;
  final String? categoryName;

  /// Units that can be rented at all (fit serials, or the manual stock).
  final double total;

  /// Physically with customers right now.
  final double out;
  double get available => total - out < 0 ? 0 : total - out;
}

/// Per-unit outcome of a return: condition and an optional note.
typedef UnitReturn = ({Condition condition, String? note});

abstract interface class RentoryRepository {
  Stream<List<OrderSummary>> watchOrders({OrderState? state});
  Stream<List<AssetSummary>> watchAssets({String? search});
  Future<OrderDetail> loadOrder(String orderId);

  Future<String> createOrder({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required DateTime start,
    required DateTime end,
  });
  Future<void> updateOrder(String orderId, OrdersCompanion changes);

  Future<String> addLine(
    String orderId, {
    required LineType type,
    String? assetId,
    String? partId,
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,
  });
  Future<void> removeLine(String lineId);

  Future<List<SerialOption>> serialOptions(String lineId);
  Future<void> setLineSerials(String lineId, List<String> serialIds);

  /// Picks free units by name, never overdue ones. Returns how many it
  /// could not find.
  Future<int> autofillSerials(String lineId);

  Future<void> book(String orderId);
  Future<void> pickupAll(String orderId, {bool force = false});

  /// Check in a line. [units] gives serials their own condition; null brings
  /// every unit back at [fallback].
  Future<void> returnLine(
    String lineId, {
    Map<String, UnitReturn>? units,
    Condition fallback = Condition.good,
  });
  Future<void> returnAll(String orderId);
  Future<void> cancel(String orderId);
  Future<void> resetToDraft(String orderId);

  /// Find a serial or asset by scanned barcode or code.
  Future<({Asset? asset, Serial? serial})> findByCode(String code);

  /// The open order a scanned unit belongs to right now: the one holding the
  /// serial, or for stock without units the latest open order using the
  /// asset. Null when nothing holds it.
  Future<String?> currentOrderFor({String? serialId, String? assetId});

  // ------------------------------------------------- order editor support

  Future<List<Customer>> customers({String? search});
  Future<String> createCustomer({required String name, String? phone});

  /// Parts that can go on their own line (not the mandatory ones that
  /// travel with their unit).
  Future<List<Part>> rentableParts({String? search});

  /// Change a line before it is booked. Null leaves a field as it is.
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  });

  // ------------------------------------------------- pickup and return

  /// What the signed-in user may do. Standalone (no sign-in) is admin.
  Future<Role> currentRole();

  Future<List<DocumentType>> documentTypes();

  /// Document types the customer left with us for [orderId].
  Future<Set<String>> orderDocuments(String orderId);
  Future<void> setOrderDocuments(String orderId, Set<String> documentTypeIds);

  /// The customer got their documents back.
  Future<void> markDocumentsReturned(String orderId);

  /// Records a picture already saved on this device. The sync engine
  /// uploads it later.
  Future<String> addPhoto({
    required String localPath,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  });
  Future<List<Photo>> photos(String orderId);
}

/// Confirms a booking and hands out its number. Locally a counter; with
/// Supabase, the server, which also refuses a unit another device just took.
abstract interface class BookingGateway {
  Future<String> confirmBooking(String orderId, DateTime bookedAt);
}
