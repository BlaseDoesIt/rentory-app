/// Local SQLite schema. One table per Rentory model, same field names in
/// snake_case so a row maps to Supabase and to Odoo without renaming.
///
/// Every table carries the sync columns: a client-made UUID, the moment it
/// last changed, a soft-delete flag (deletes have to sync too), a `dirty`
/// flag for rows not yet pushed, and an `odoo_id` for the Odoo backend.
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';

/// Row ids are made on the device, so rows can be created offline.
const rowUuid = Uuid();

/// Stores an enum by its Odoo key.
class KeyConverter<T extends Keyed> extends TypeConverter<T, String> {
  const KeyConverter(this.values);
  final List<T> values;

  @override
  T fromSql(String fromDb) => values.firstWhere((v) => v.key == fromDb);

  @override
  String toSql(T value) => value.key;
}

mixin SyncColumns on Table {
  TextColumn get id => text().clientDefault(() => rowUuid.v4())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  IntColumn get odooId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------- people

class Profiles extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get role => text()
      .map(const KeyConverter(Role.values))
      .withDefault(const Constant('office'))();
}

class Customers extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// What a customer can leave as security: ID card, passport, ...
class DocumentTypes extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get sequence => integer().withDefault(const Constant(10))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class CustomerDiscounts extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get discountType => text()
      .map(const KeyConverter(DiscountType.values))
      .withDefault(const Constant('percent'))();
  RealColumn get discountValue => real().withDefault(const Constant(0))();
  DateTimeColumn get dateFrom => dateTime().nullable()();
  DateTimeColumn get dateTo => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

// ------------------------------------------------------------- inventory

class Categories extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  IntColumn get color => integer().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Locations extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Assets extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get tracking => text()
      .map(const KeyConverter(Tracking.values))
      .withDefault(const Constant('none'))();
  BoolColumn get rentalOk => boolean().withDefault(const Constant(true))();

  /// Stock of an untracked asset. Serial assets count their units instead.
  RealColumn get qtyManual => real().withDefault(const Constant(1))();
  RealColumn get rentalPriceDay => real().withDefault(const Constant(0))();
  RealColumn get declaredValue => real().withDefault(const Constant(0))();
  TextColumn get locationId => text().nullable().references(Locations, #id)();
  TextColumn get imagePath => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Serials extends Table with SyncColumns {
  TextColumn get assetId => text().references(Assets, #id)();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get state => text()
      .map(const KeyConverter(SerialState.values))
      .withDefault(const Constant('available'))();
  TextColumn get locationId => text().nullable().references(Locations, #id)();
  TextColumn get currentOrderId => text().nullable()();
  TextColumn get currentLineId => text().nullable()();
  RealColumn get declaredValue => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Parts extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get assetId => text().references(Assets, #id)();
  TextColumn get serialId => text().nullable().references(Serials, #id)();
  IntColumn get sequence => integer().withDefault(const Constant(10))();
  TextColumn get kind => text()
      .map(const KeyConverter(PartKind.values))
      .withDefault(const Constant('mandatory'))();

  /// good / damaged / lost (the part's own vocabulary).
  TextColumn get condition => text().withDefault(const Constant('good'))();
  TextColumn get state => text()
      .map(const KeyConverter(PartState.values))
      .withDefault(const Constant('available'))();
  RealColumn get rentalPriceDay => real().withDefault(const Constant(0))();
  TextColumn get currentOrderId => text().nullable()();
  TextColumn get currentLineId => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

// ---------------------------------------------------------------- orders

class Orders extends Table with SyncColumns {
  /// RO/2026/0001, given by the server at booking. Null while a draft.
  TextColumn get number => text().nullable()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  DateTimeColumn get dateStart => dateTime().nullable()();
  DateTimeColumn get dateEnd => dateTime().nullable()();
  TextColumn get state => text()
      .map(const KeyConverter(OrderState.values))
      .withDefault(const Constant('draft'))();

  TextColumn get discountType => text()
      .map(const KeyConverter(DiscountType.values))
      .withDefault(const Constant('percent'))();
  RealColumn get discountValue => real().withDefault(const Constant(0))();
  TextColumn get customerDiscountId =>
      text().nullable().references(CustomerDiscounts, #id)();
  RealColumn get amountDeposit => real().withDefault(const Constant(0))();
  RealColumn get amountPaid => real().withDefault(const Constant(0))();
  BoolColumn get lateFeeManual => boolean().withDefault(const Constant(true))();
  BoolColumn get lateDaysEdited =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lateDaysOverride => integer().withDefault(const Constant(0))();

  // Checklist: only the contract gates the handover.
  BoolColumn get sigRentalContract =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get sigPickupReturnReceipt =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get sigLoanContract =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get itemsCaptured => boolean().withDefault(const Constant(false))();
  BoolColumn get itemsExamined => boolean().withDefault(const Constant(false))();
  DateTimeColumn get itemsExaminedAt => dateTime().nullable()();
  TextColumn get itemsExaminedBy => text().nullable()();

  DateTimeColumn get documentsReturnedAt => dateTime().nullable()();
  TextColumn get documentsReturnedBy => text().nullable()();

  TextColumn get signaturePath => text().nullable()();
  TextColumn get signatureName => text().nullable()();
  DateTimeColumn get signatureDate => dateTime().nullable()();

  TextColumn get userId => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// Documents the customer left with us for this order.
class OrderDocuments extends Table with SyncColumns {
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get documentTypeId => text().references(DocumentTypes, #id)();
}

class OrderLines extends Table with SyncColumns {
  TextColumn get orderId => text().references(Orders, #id)();
  IntColumn get sequence => integer().withDefault(const Constant(10))();
  TextColumn get lineType => text()
      .map(const KeyConverter(LineType.values))
      .withDefault(const Constant('asset'))();
  TextColumn get assetId => text().nullable().references(Assets, #id)();
  TextColumn get partId => text().nullable().references(Parts, #id)();
  TextColumn get name => text().withDefault(const Constant(''))();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  RealColumn get priceDay => real().withDefault(const Constant(0))();

  /// Line discount in percent.
  RealColumn get discount => real().withDefault(const Constant(0))();

  /// Null means "the order's dates".
  DateTimeColumn get dateStart => dateTime().nullable()();
  DateTimeColumn get dateEnd => dateTime().nullable()();
  TextColumn get rentalState => text()
      .map(const KeyConverter(RentalState.values))
      .withDefault(const Constant('none'))();
  DateTimeColumn get pickedUpAt => dateTime().nullable()();
  TextColumn get pickedUpBy => text().nullable()();
  DateTimeColumn get returnedAt => dateTime().nullable()();
  TextColumn get returnedBy => text().nullable()();
  TextColumn get conditionOut => text()
      .map(const KeyConverter(Condition.values))
      .withDefault(const Constant('good'))();
  TextColumn get conditionIn => text()
      .map(const KeyConverter(Condition.values))
      .nullable()();
  TextColumn get conditionNote => text().nullable()();
}

/// Units a line names (many to many).
class OrderLineSerials extends Table with SyncColumns {
  TextColumn get lineId => text().references(OrderLines, #id)();
  TextColumn get serialId => text().references(Serials, #id)();
}

/// Parts travelling with an asset line (many to many).
class OrderLineParts extends Table with SyncColumns {
  TextColumn get lineId => text().references(OrderLines, #id)();
  TextColumn get partId => text().references(Parts, #id)();
}

class ReturnChecks extends Table with SyncColumns {
  TextColumn get lineId => text().references(OrderLines, #id)();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get serialId => text().nullable().references(Serials, #id)();
  TextColumn get partId => text().nullable().references(Parts, #id)();
  TextColumn get condition => text()
      .map(const KeyConverter(Condition.values))
      .withDefault(const Constant('good'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get returnedAt => dateTime()();
  TextColumn get returnedBy => text().nullable()();
}

class Photos extends Table with SyncColumns {
  TextColumn get assetId => text().nullable()();
  TextColumn get serialId => text().nullable()();
  TextColumn get orderId => text().nullable()();
  TextColumn get lineId => text().nullable()();

  /// Path inside the Supabase bucket once uploaded.
  TextColumn get storagePath => text().nullable()();

  /// File on this device, until it is uploaded (or for offline viewing).
  TextColumn get localPath => text().nullable()();
  DateTimeColumn get takenAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  TextColumn get note => text().nullable()();
}

/// Sync bookkeeping, one row per table: how far this device has pulled.
class SyncCursors extends Table {
  TextColumn get tableName_ => text().named('table_name')();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {tableName_};
}
