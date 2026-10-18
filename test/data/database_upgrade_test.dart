import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/domain/enums.dart';

void main() {
  test('an old cache is rebuilt without the parts tables', () async {
    final db = RentoryDatabase.memory(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute('CREATE TABLE parts (id TEXT PRIMARY KEY)');
          raw.execute('CREATE TABLE orders (id TEXT PRIMARY KEY)');
          raw.execute("INSERT INTO orders VALUES ('old')");
          raw.userVersion = 1;
        },
      ),
    );
    final tables = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .map((r) => r.read<String>('name'))
        .get();
    expect(tables, isNot(contains('parts')));
    expect(tables, contains('order_lines'));
    // The cache starts empty and is pulled again from the server.
    expect(await db.select(db.orders).get(), isEmpty);
    await db.close();
  });

  test('a version 2 cache gains the new columns and keeps its rows', () async {
    final db = RentoryDatabase.memory(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE assets (id TEXT PRIMARY KEY, name TEXT NOT NULL, '
            'updated_at TEXT NOT NULL, deleted INTEGER NOT NULL DEFAULT 0, '
            'dirty INTEGER NOT NULL DEFAULT 1)',
          );
          raw.execute(
            "INSERT INTO assets (id, name, updated_at) VALUES ('a1', 'Kept', '2026-10-01T00:00:00.000Z')",
          );
          raw.userVersion = 2;
        },
      ),
    );
    final a = await db.select(db.assets).getSingle();
    expect(a.name, 'Kept');
    expect(a.dirty, isTrue);
    expect(a.ownership, Ownership.owned);
    expect(a.unitCost, 0);
    await db.close();
  });
}
