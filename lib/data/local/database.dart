import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/enums.dart';
import 'tables.dart';

part 'database.g.dart';

/// Every table that syncs, in dependency order (parents before children),
/// which is also the order rows are pushed and pulled in.
const syncedTables = [
  'profiles',
  'customers',
  'document_types',
  'customer_discounts',
  'categories',
  'locations',
  'assets',
  'serials',
  'parts',
  'orders',
  'order_documents',
  'order_lines',
  'order_line_serials',
  'order_line_parts',
  'return_checks',
  'photos',
];

@DriftDatabase(tables: [
  Profiles,
  Customers,
  DocumentTypes,
  CustomerDiscounts,
  Categories,
  Locations,
  Assets,
  Serials,
  Parts,
  Orders,
  OrderDocuments,
  OrderLines,
  OrderLineSerials,
  OrderLineParts,
  ReturnChecks,
  Photos,
  SyncCursors,
])
class RentoryDatabase extends _$RentoryDatabase {
  RentoryDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'rentory'));

  /// In-memory database for tests.
  RentoryDatabase.memory(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
