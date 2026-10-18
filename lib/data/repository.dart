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
    this.lineNames = const [],
  });

  final Order order;
  final String customerLabel;
  final OrderAmounts amounts;
  final int itemCount;
  final bool overdue;
  final int daysLate;

  /// What is on it, for search.
  final List<String> lineNames;
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
    this.cover,
  });

  final Asset asset;
  final String? categoryName;

  /// The first of its photos, shown on its card.
  final Photo? cover;

  /// Units that can be rented at all (fit serials, or the manual stock).
  final double total;

  /// Physically with customers right now.
  final double out;
  double get available => total - out < 0 ? 0 : total - out;
}

/// One asset with everything its page shows.
class AssetDetail {
  const AssetDetail({
    required this.summary,
    required this.serials,
    required this.locationName,
    required this.sourceName,
    required this.liveLines,
    this.photos = const [],
  });

  /// Its gallery, cover first.
  final List<Photo> photos;

  final AssetSummary summary;

  /// Its units, by name. Empty for stock counted by quantity.
  final List<Serial> serials;
  final String? locationName;

  /// The contact it was bought from.
  final String? sourceName;

  /// Order lines still holding it (not returned, order still open).
  final int liveLines;
  Asset get asset => summary.asset;
}

/// Per-unit outcome of a return: condition and an optional note.
typedef UnitReturn = ({Condition condition, String? note});

/// What a delete did: some records keep history, so they are archived.
enum Removal { deleted, archived }

/// What scanning a code onto an order did.
enum ScanOutcome {
  /// Added (or one more on its line).
  added,

  /// Added, but its unit could not be chosen alone: pick it on [lineId].
  pickUnits,

  /// That unit is already on this order.
  alreadyOnOrder,

  /// No asset or unit has this code.
  notFound,
}

typedef ScanAdd = ({ScanOutcome outcome, String? lineId, String? name});

abstract interface class RentoryRepository {
  /// Orders, or with [archived] only the archived ones.
  Stream<List<OrderSummary>> watchOrders({
    OrderState? state,
    bool archived = false,
  });

  /// Assets, or with [archived] only the archived ones.
  Stream<List<AssetSummary>> watchAssets({
    String? search,
    bool archived = false,
  });
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
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,

    /// Units for a serial asset; the quantity follows them.
    List<String> serialIds = const [],
  });
  Future<void> removeLine(String lineId);

  /// Puts the order's lines in this order (sections included).
  Future<void> moveLines(String orderId, List<String> lineIds);

  /// Adds whatever [code] scans to: a unit, or an asset by its barcode.
  Future<ScanAdd> addScanned(String orderId, String code);

  Future<List<SerialOption>> serialOptions(String lineId);

  /// Units of [assetId] free over the order's dates, for a line not made yet.
  Future<List<SerialOption>> serialOptionsFor(String orderId, String assetId);
  Future<void> setLineSerials(String lineId, List<String> serialIds);

  /// Picks free units by name, never overdue ones. Returns how many it
  /// could not find.
  Future<int> autofillSerials(String lineId);

  /// Books [lineIds], or every line not booked yet. Works on an order of
  /// any state: lines added later are booked on their own.
  Future<void> book(String orderId, {List<String>? lineIds});

  /// Takes a booked line off the booking; its units are free again.
  Future<void> unbookLine(String lineId);

  /// Hands over [lineIds], or every booked line.
  Future<void> pickupAll(
    String orderId, {
    bool force = false,
    List<String>? lineIds,
  });

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

  /// Deletes an order nothing ever left on; one with history is archived.
  Future<Removal> removeOrder(String orderId);
  Future<void> restoreOrder(String orderId);

  /// Find a serial or asset by scanned barcode or code.
  Future<({Asset? asset, Serial? serial})> findByCode(String code);

  /// The open order a scanned unit belongs to right now: the one holding the
  /// serial, or for stock without units the latest open order using the
  /// asset. Null when nothing holds it.
  Future<String?> currentOrderFor({String? serialId, String? assetId});

  // ------------------------------------------------- order editor support

  Future<List<Customer>> customers({String? search});
  Future<String> createCustomer({required String name, String? phone});

  /// Change a line. Null leaves a field as it is. A booked line is booked
  /// again after the change; a line already out keeps its quantity.
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  });

  /// Gives a line not yet out its own dates. Null [start] and [end] put it back on
  /// the order's dates. Must sit inside the order's window unless the order
  /// allows otherwise.
  Future<void> setLineDates(String lineId, DateTime? start, DateTime? end);

  /// Somebody went over what came back and confirmed its condition.
  Future<void> setItemsExamined(String orderId, bool examined);

  // ------------------------------------------------- inventory

  Future<AssetDetail> loadAsset(String assetId);
  Future<List<Category>> categories();
  Future<String> createCategory(String name);
  Future<List<Location>> locations();
  Future<String> createLocation(String name);

  /// A new asset. [tracking] serial gives it one unit per name in [units]
  /// (each name is also its barcode); otherwise [quantity] is the stock.
  /// Codes, barcodes and unit names must not clash with anything already
  /// scannable.
  Future<String> createAsset({
    required String name,
    String? code,
    String? barcode,
    String? categoryId,
    String? locationId,
    required Tracking tracking,
    double quantity = 1,
    List<String> units = const [],
    double priceDay = 0,
    double declaredValue = 0,
    String? notes,

    /// Anything else to set: ownership and loan, acquisition, rental switch.
    AssetsCompanion more = const AssetsCompanion(),
  });

  /// Edit an asset. Codes and barcodes are checked like [createAsset].
  Future<void> updateAsset(String assetId, AssetsCompanion changes);

  /// Counts an asset by unit or by quantity from now on. Going by unit,
  /// [units] are added to any it had; going by quantity, [quantity] is the
  /// stock. Refused while it is booked or out.
  Future<void> changeTracking(
    String assetId,
    Tracking tracking, {
    List<String> units = const [],
    double? quantity,
  });

  /// Deletes an asset no order ever used; one with history is archived.
  Future<Removal> removeAsset(String assetId);
  Future<void> restoreAsset(String assetId);

  /// Maintenance, retired, or null to hand status back to the quantities.
  /// Free units follow; refused while anything is out or reserved.
  Future<void> setAssetStatus(String assetId, AssetManualState? state);

  /// A rented-in asset goes back to its owner, closing the loan. Refused
  /// while any open order still counts on it.
  Future<void> giveBack(
    String assetId, {
    required LoanCondition condition,
    String? note,
  });

  /// Edit one unit: note, cost, value, source, location, name.
  Future<void> updateUnit(String serialId, SerialsCompanion changes);

  /// Available, maintenance, retired or lost, by hand. Refused while the
  /// unit is out or reserved.
  Future<void> setUnitState(String serialId, SerialState state);

  /// More units for a serial asset.
  Future<void> addUnits(String assetId, List<String> names);

  // ------------------------------------------------- pickup and return

  /// What the signed-in user may do. No user at all (tests) counts as admin.
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
    String? assetId,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  });
  Future<List<Photo>> photos(String orderId);

  /// Photos of an asset, cover first.
  Future<List<Photo>> assetPhotos(String assetId);

  /// Makes [photoId] the first of its asset's photos.
  Future<void> setCoverPhoto(String photoId);
  Future<void> removePhoto(String photoId);

  // ------------------------------------------------- order photos (phone)

  /// Photos of an order taken on this phone. Local only, never uploaded.
  Future<List<OrderPhoto>> orderPhotos(String orderId);
  Future<void> addOrderPhoto(String orderId, String path);
  Future<void> removeOrderPhoto(String photoId);
}

/// Confirms a booking and hands out its number. Locally a counter; with
/// Supabase, the server, which also refuses a unit another device just took.
abstract interface class BookingGateway {
  /// Confirms [lineIds], or every line of the order not booked yet.
  Future<String> confirmBooking(
    String orderId,
    DateTime bookedAt, {
    List<String>? lineIds,
  });
}
