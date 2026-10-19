import '../../domain/enums.dart';
import '../local/database.dart';
import '../local/local_repository.dart';
import '../repository.dart';

/// Odoo mode, first step: everything reads from the local copy of Odoo's
/// data, and every change is refused until writes go to Odoo itself.
/// Order photos are the exception: they never leave the phone in any mode.
class OdooReadOnlyRepository extends LocalRepository {
  OdooReadOnlyRepository(
    super.db, {
    required super.gateway,
    super.currentUserId,
    super.clock,
  });

  static const message =
      'Connected to Odoo: changes are not sent to Odoo yet. '
      'Make this change in Odoo for now.';

  static Never _no() => throw RuleException.one(message);

  @override
  Future<String> createOrder({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required DateTime start,
    required DateTime end,
  }) async => _no();

  @override
  Future<void> updateOrder(String orderId, OrdersCompanion changes) async =>
      _no();

  @override
  Future<String> addLine(
    String orderId, {
    required LineType type,
    String? assetId,
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,
    List<String> serialIds = const [],
  }) async => _no();

  @override
  Future<void> removeLine(String lineId) async => _no();

  @override
  Future<void> moveLines(String orderId, List<String> lineIds) async => _no();

  @override
  Future<ScanAdd> addScanned(String orderId, String code) async => _no();

  @override
  Future<void> setLineSerials(String lineId, List<String> serialIds) async =>
      _no();

  @override
  Future<int> autofillSerials(String lineId) async => _no();

  @override
  Future<void> book(String orderId, {List<String>? lineIds}) async => _no();

  @override
  Future<void> unbookLine(String lineId) async => _no();

  @override
  Future<void> pickupAll(
    String orderId, {
    bool force = false,
    List<String>? lineIds,
  }) async => _no();

  @override
  Future<void> returnLine(
    String lineId, {
    Map<String, UnitReturn>? units,
    Condition fallback = Condition.good,
  }) async => _no();

  @override
  Future<void> returnAll(String orderId) async => _no();

  @override
  Future<void> cancel(String orderId) async => _no();

  @override
  Future<void> resetToDraft(String orderId) async => _no();

  @override
  Future<Removal> removeOrder(String orderId) async => _no();

  @override
  Future<void> restoreOrder(String orderId) async => _no();

  @override
  Future<String> createCustomer({required String name, String? phone}) async =>
      _no();

  @override
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  }) async => _no();

  @override
  Future<void> setLineDates(
    String lineId,
    DateTime? start,
    DateTime? end,
  ) async => _no();

  @override
  Future<void> setItemsExamined(String orderId, bool examined) async => _no();

  @override
  Future<String> createCategory(String name) async => _no();

  @override
  Future<String> createLocation(String name) async => _no();

  @override
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
    AssetsCompanion more = const AssetsCompanion(),
  }) async => _no();

  @override
  Future<void> updateAsset(String assetId, AssetsCompanion changes) async =>
      _no();

  @override
  Future<void> changeTracking(
    String assetId,
    Tracking tracking, {
    List<String> units = const [],
    double? quantity,
  }) async => _no();

  @override
  Future<Removal> removeAsset(String assetId) async => _no();

  @override
  Future<void> restoreAsset(String assetId) async => _no();

  @override
  Future<void> setAssetStatus(String assetId, AssetManualState? state) async =>
      _no();

  @override
  Future<void> giveBack(
    String assetId, {
    required LoanCondition condition,
    String? note,
  }) async => _no();

  @override
  Future<void> updateUnit(String serialId, SerialsCompanion changes) async =>
      _no();

  @override
  Future<void> setUnitState(String serialId, SerialState state) async => _no();

  @override
  Future<void> addUnits(String assetId, List<String> names) async => _no();

  @override
  Future<void> setOrderDocuments(
    String orderId,
    Set<String> documentTypeIds,
  ) async => _no();

  @override
  Future<void> markDocumentsReturned(String orderId) async => _no();

  @override
  Future<String> addPhoto({
    required String localPath,
    String? assetId,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  }) async => _no();

  @override
  Future<void> setCoverPhoto(String photoId) async => _no();

  @override
  Future<void> removePhoto(String photoId) async => _no();
}

/// Bookings go through Odoo's own `action_book` once writes exist.
class OdooBookingGateway implements BookingGateway {
  const OdooBookingGateway();

  @override
  Future<String> confirmBooking(
    String orderId,
    DateTime bookedAt, {
    List<String>? lineIds,
  }) async => throw RuleException.one(OdooReadOnlyRepository.message);
}
