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
  'orders',
  'order_documents',
  'order_lines',
  'order_line_serials',
  'return_checks',
  'photos',
];

@DriftDatabase(
  tables: [
    Profiles,
    Customers,
    DocumentTypes,
    CustomerDiscounts,
    Categories,
    Locations,
    Assets,
    Serials,
    Orders,
    OrderDocuments,
    OrderLines,
    OrderLineSerials,
    ReturnChecks,
    Photos,
    SyncCursors,
  ],
)
class RentoryDatabase extends _$RentoryDatabase {
  RentoryDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'rentory'));

  /// In-memory database for tests.
  RentoryDatabase.memory(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // The server holds the data; this database is only its cache. On a
    // schema change, start clean and pull everything again. Version 2
    // dropped parts.
    onUpgrade: (m, from, to) async {
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%'",
      ).get();
      for (final t in tables) {
        await customStatement('DROP TABLE "${t.read<String>('name')}"');
      }
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
