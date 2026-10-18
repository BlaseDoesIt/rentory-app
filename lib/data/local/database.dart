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
    OrderPhotos,
    SyncCursors,
  ],
)
class RentoryDatabase extends _$RentoryDatabase {
  RentoryDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'rentory'));

  /// In-memory database for tests.
  RentoryDatabase.memory(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // Versions 3 and 4 only added columns and tables: add them in place,
      // so edits not yet pushed survive the upgrade.
      if (from >= 2) {
        for (final table in allTables) {
          final have = {
            for (final r in await customSelect(
              'PRAGMA table_info("${table.actualTableName}")',
            ).get())
              r.read<String>('name'),
          };
          if (have.isEmpty) {
            await m.createTable(table);
            continue;
          }
          for (final c in table.$columns) {
            if (!have.contains(c.name)) await m.addColumn(table, c);
          }
        }
        return;
      }
      // Before version 2 (parts): this database is only the server's cache,
      // so start clean and pull everything again.
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
