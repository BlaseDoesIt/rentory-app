import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/data/local/database.dart';

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
}
