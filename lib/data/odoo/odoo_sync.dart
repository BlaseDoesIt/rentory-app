import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';
import '../local/database.dart';
import '../repository.dart';
import '../sync/remote_store.dart';
import '../sync/sync_engine.dart';
import 'odoo_client.dart';

/// Local row ids for Odoo records: a UUID made from the database, the model
/// and the Odoo id, so every device gets the same one and a reference can be
/// written without looking anything up. Different databases never share ids.
class OdooIds {
  const OdooIds(this.database);
  final String database;

  static const _uuid = Uuid();

  String of(String model, int id, [String? version]) => _uuid.v5(
    Namespace.url.value,
    'odoo:$database/$model/$id${version == null ? '' : '@$version'}',
  );

  /// The id behind a many2one value (`[id, "name"]`, a bare id, or false).
  String? ref(String model, Object? value) {
    final id = odooId(value);
    return id == null ? null : of(model, id);
  }

  static int? odooId(Object? value) => switch (value) {
    final List<Object?> pair when pair.isNotEmpty =>
      (pair.first as num).toInt(),
    final num id => id.toInt(),
    _ => null,
  };
}

/// One Odoo model and the local table it fills.
class OdooModelSpec {
  const OdooModelSpec({
    required this.model,
    required this.table,
    required this.fields,
    required this.map,
    this.domain = const [],
    this.archivable = true,
  });

  final String model;
  final String table;
  final List<String> fields;
  final List<Object?> domain;

  /// Has an `active` field: archived records are read too.
  final bool archivable;

  /// Local column values for one record, beside the sync columns.
  final Map<String, Object?> Function(Map<String, Object?> r, OdooMapper m) map;
}

/// What a record's fields become in SQLite: Odoo's `false` for "empty",
/// UTC "YYYY-MM-DD HH:MM:SS" datetimes, HTML notes.
class OdooMapper {
  OdooMapper(this.ids, {required this.uid, required this.role});

  final OdooIds ids;

  /// The signed-in Odoo user, whose profile carries [role].
  final int uid;
  final Role role;

  /// Partners records point at, so they can be fetched as customers.
  final partners = <int>{};

  String? ref(String model, Object? v) => ids.ref(model, v);

  String? user(Object? v) => ids.ref('res.users', v);

  String? partner(Object? v) {
    final id = OdooIds.odooId(v);
    if (id == null) return null;
    partners.add(id);
    return ids.of('res.partner', id);
  }

  static String? text(Object? v) => v is String && v.isNotEmpty ? v : null;

  static double number(Object? v) => v is num ? v.toDouble() : 0;

  static int integer(Object? v) => v is num ? v.toInt() : 0;

  static int flag(Object? v) => v == true ? 1 : 0;

  /// Ids of a many2many (Odoo sends `false` for some empty values).
  static List<Object?> many(Object? v) => v is List ? v : const [];

  /// Drift's text format (UTC ISO-8601), or null.
  static String? when(Object? v) {
    if (v is! String || v.isEmpty) return null;
    final s = v.length == 10
        ? '${v}T00:00:00Z'
        : '${v.replaceFirst(' ', 'T')}Z';
    return DateTime.parse(s).toUtc().toIso8601String();
  }

  /// A selection value the app knows, else [fallback].
  static String? key(Object? v, List<Keyed> known, {String? fallback}) {
    if (v is String && known.any((k) => k.key == v)) return v;
    return fallback;
  }

  /// Odoo keeps notes as HTML; the app shows plain text.
  static String? plain(Object? v) {
    final html = text(v);
    if (html == null) return null;
    final s = html
        .replaceAll(
          RegExp(r'<br\s*/?>|</p>|</div>|</li>', caseSensitive: false),
          '\n',
        )
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    return s.isEmpty ? null : s;
  }
}

/// Rentory's models, parents before children.
List<OdooModelSpec> rentorySpecs() => [
  OdooModelSpec(
    model: 'res.users',
    table: 'profiles',
    archivable: false,
    domain: const [
      ['share', '=', false],
    ],
    fields: const ['name'],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      // Only the signed-in user's role matters on this device.
      'role': r['id'] == m.uid ? m.role.key : Role.office.key,
    },
  ),
  OdooModelSpec(
    model: 'rentory.customer.document',
    table: 'document_types',
    fields: const ['name', 'sequence', 'note', 'active'],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      'sequence': OdooMapper.integer(r['sequence']),
      'note': OdooMapper.text(r['note']),
      'active': OdooMapper.flag(r['active']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.customer.discount',
    table: 'customer_discounts',
    fields: const [
      'name',
      'sequence',
      'partner_id',
      'customer_name',
      'discount_type',
      'discount_value',
      'date_from',
      'date_to',
      'note',
      'active',
    ],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      'sequence': OdooMapper.integer(r['sequence']),
      'customer_id': m.partner(r['partner_id']),
      'customer_name': OdooMapper.text(r['customer_name']),
      'discount_type': OdooMapper.key(
        r['discount_type'],
        DiscountType.values,
        fallback: 'percent',
      ),
      'discount_value': OdooMapper.number(r['discount_value']),
      'date_from': OdooMapper.when(r['date_from']),
      'date_to': OdooMapper.when(r['date_to']),
      'note': OdooMapper.text(r['note']),
      'active': OdooMapper.flag(r['active']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.asset.category',
    table: 'categories',
    fields: const ['name', 'parent_id', 'color', 'active'],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      'parent_id': m.ref('rentory.asset.category', r['parent_id']),
      'color': OdooMapper.integer(r['color']),
      'active': OdooMapper.flag(r['active']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.location',
    table: 'locations',
    fields: const ['name', 'parent_id', 'note', 'active'],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      'parent_id': m.ref('rentory.location', r['parent_id']),
      'note': OdooMapper.text(r['note']),
      'active': OdooMapper.flag(r['active']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.asset',
    table: 'assets',
    fields: const [
      'name',
      'code',
      'barcode',
      'category_id',
      'tracking',
      'rental_ok',
      'qty_manual',
      'rental_price_day',
      'declared_value',
      'location_id',
      'notes',
      'active',
      'state_manual',
      'source_id',
      'evaluation_url',
      'acquisition_date',
      'unit_cost',
      'ownership',
      'supplier_name',
      'supplier_phone',
      'supplier_reference',
      'rented_in_date_start',
      'rented_in_date_end',
      'rented_in_cost_day',
      'rented_in_deposit',
      'rented_in_returned_at',
      'rented_in_returned_by',
      'rented_in_condition_in',
      'rented_in_condition_out',
      'rented_in_note',
    ],
    map: (r, m) => {
      'name': OdooMapper.text(r['name']) ?? '',
      'code': OdooMapper.text(r['code']),
      'barcode': OdooMapper.text(r['barcode']),
      'category_id': m.ref('rentory.asset.category', r['category_id']),
      'tracking': OdooMapper.key(
        r['tracking'],
        Tracking.values,
        fallback: 'none',
      ),
      'rental_ok': OdooMapper.flag(r['rental_ok']),
      'qty_manual': OdooMapper.number(r['qty_manual']),
      'rental_price_day': OdooMapper.number(r['rental_price_day']),
      'declared_value': OdooMapper.number(r['declared_value']),
      'location_id': m.ref('rentory.location', r['location_id']),
      'notes': OdooMapper.plain(r['notes']),
      'active': OdooMapper.flag(r['active']),
      'state_manual': OdooMapper.key(
        r['state_manual'],
        AssetManualState.values,
      ),
      'source_id': m.partner(r['source_id']),
      'evaluation_url': OdooMapper.text(r['evaluation_url']),
      'acquisition_date': OdooMapper.when(r['acquisition_date']),
      'unit_cost': OdooMapper.number(r['unit_cost']),
      'ownership': OdooMapper.key(
        r['ownership'],
        Ownership.values,
        fallback: 'owned',
      ),
      'supplier_name': OdooMapper.text(r['supplier_name']),
      'supplier_phone': OdooMapper.text(r['supplier_phone']),
      'supplier_reference': OdooMapper.text(r['supplier_reference']),
      'rented_in_date_start': OdooMapper.when(r['rented_in_date_start']),
      'rented_in_date_end': OdooMapper.when(r['rented_in_date_end']),
      'rented_in_cost_day': OdooMapper.number(r['rented_in_cost_day']),
      'rented_in_deposit': OdooMapper.number(r['rented_in_deposit']),
      'rented_in_returned_at': OdooMapper.when(r['rented_in_returned_at']),
      'rented_in_returned_by': m.user(r['rented_in_returned_by']),
      'rented_in_condition_in': OdooMapper.key(
        r['rented_in_condition_in'],
        LoanCondition.values,
        fallback: 'good',
      ),
      'rented_in_condition_out': OdooMapper.key(
        r['rented_in_condition_out'],
        LoanCondition.values,
      ),
      'rented_in_note': OdooMapper.text(r['rented_in_note']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.asset.serial',
    table: 'serials',
    fields: const [
      'asset_id',
      'name',
      'barcode',
      'state',
      'location_id',
      'current_order_id',
      'current_line_id',
      'declared_value',
      'note',
      'active',
      'source_id',
      'evaluation_url',
      'acquisition_date',
      'unit_cost',
    ],
    map: (r, m) => {
      'asset_id': m.ref('rentory.asset', r['asset_id']),
      'name': OdooMapper.text(r['name']) ?? '',
      'barcode': OdooMapper.text(r['barcode']),
      'state': OdooMapper.key(
        r['state'],
        SerialState.values,
        fallback: 'available',
      ),
      'location_id': m.ref('rentory.location', r['location_id']),
      'current_order_id': m.ref('rentory.order', r['current_order_id']),
      'current_line_id': m.ref('rentory.order.line', r['current_line_id']),
      'declared_value': OdooMapper.number(r['declared_value']),
      'note': OdooMapper.text(r['note']),
      'active': OdooMapper.flag(r['active']),
      'source_id': m.partner(r['source_id']),
      'evaluation_url': OdooMapper.text(r['evaluation_url']),
      'acquisition_date': OdooMapper.when(r['acquisition_date']),
      'unit_cost': OdooMapper.number(r['unit_cost']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.order',
    table: 'orders',
    archivable: false,
    fields: const [
      'name',
      'partner_id',
      'customer_name',
      'customer_phone',
      'date_start',
      'date_end',
      'state',
      'discount_type',
      'discount_value',
      'customer_discount_id',
      'amount_deposit',
      'amount_paid',
      'late_fee_manual',
      'late_days_edited',
      'late_days_override',
      'sig_rental_contract',
      'sig_pickup_return_receipt',
      'sig_loan_contract',
      'items_captured',
      'items_examined',
      'items_examined_at',
      'items_examined_by',
      'documents_returned_at',
      'documents_returned_by',
      'signature_name',
      'signature_date',
      'user_id',
      'note',
      'allow_line_dates_outside',
      'signature_target',
      'capture_method',
      'photos_url',
      'document_ids',
    ],
    map: (r, m) => {
      'number': OdooMapper.text(r['name']),
      'customer_id': m.partner(r['partner_id']),
      'customer_name': OdooMapper.text(r['customer_name']),
      'customer_phone': OdooMapper.text(r['customer_phone']),
      'date_start': OdooMapper.when(r['date_start']),
      'date_end': OdooMapper.when(r['date_end']),
      'state': OdooMapper.key(r['state'], OrderState.values, fallback: 'draft'),
      'discount_type': OdooMapper.key(
        r['discount_type'],
        DiscountType.values,
        fallback: 'percent',
      ),
      'discount_value': OdooMapper.number(r['discount_value']),
      'customer_discount_id': m.ref(
        'rentory.customer.discount',
        r['customer_discount_id'],
      ),
      'amount_deposit': OdooMapper.number(r['amount_deposit']),
      'amount_paid': OdooMapper.number(r['amount_paid']),
      'late_fee_manual': OdooMapper.flag(r['late_fee_manual']),
      'late_days_edited': OdooMapper.flag(r['late_days_edited']),
      'late_days_override': OdooMapper.integer(r['late_days_override']),
      'sig_rental_contract': OdooMapper.flag(r['sig_rental_contract']),
      'sig_pickup_return_receipt': OdooMapper.flag(
        r['sig_pickup_return_receipt'],
      ),
      'sig_loan_contract': OdooMapper.flag(r['sig_loan_contract']),
      'items_captured': OdooMapper.flag(r['items_captured']),
      'items_examined': OdooMapper.flag(r['items_examined']),
      'items_examined_at': OdooMapper.when(r['items_examined_at']),
      'items_examined_by': m.user(r['items_examined_by']),
      'documents_returned_at': OdooMapper.when(r['documents_returned_at']),
      'documents_returned_by': m.user(r['documents_returned_by']),
      'signature_name': OdooMapper.text(r['signature_name']),
      'signature_date': OdooMapper.when(r['signature_date']),
      'user_id': m.user(r['user_id']),
      'note': OdooMapper.plain(r['note']),
      'allow_line_dates_outside': OdooMapper.flag(
        r['allow_line_dates_outside'],
      ),
      'signature_target': OdooMapper.key(
        r['signature_target'],
        SignatureTarget.values,
      ),
      'capture_method': OdooMapper.key(
        r['capture_method'],
        CaptureMethod.values,
      ),
      'photos_url': OdooMapper.text(r['photos_url']),
      // Odoo orders are cancelled, never archived.
      'active': 1,
    },
  ),
  OdooModelSpec(
    model: 'rentory.order.line',
    table: 'order_lines',
    archivable: false,
    fields: const [
      'order_id',
      'sequence',
      'line_type',
      'asset_id',
      'name',
      'quantity',
      'price_day',
      'discount',
      'date_start',
      'date_end',
      'dates_overridden',
      'rental_state',
      'picked_up_at',
      'picked_up_by',
      'returned_at',
      'returned_by',
      'condition_out',
      'condition_in',
      'condition_note',
      'serial_ids',
    ],
    map: (r, m) {
      // Odoo copies the order's dates onto every line; the app keeps null
      // for "the order's dates" unless the line was given its own.
      final own = r['dates_overridden'] == true;
      return {
        'order_id': m.ref('rentory.order', r['order_id']),
        'sequence': OdooMapper.integer(r['sequence']),
        // Parts were left out of the app; a part line reads as an item.
        'line_type': OdooMapper.key(
          r['line_type'],
          LineType.values,
          fallback: 'asset',
        ),
        'asset_id': m.ref('rentory.asset', r['asset_id']),
        'name': OdooMapper.text(r['name']) ?? '',
        'quantity': OdooMapper.number(r['quantity']),
        'price_day': OdooMapper.number(r['price_day']),
        'discount': OdooMapper.number(r['discount']),
        'date_start': own ? OdooMapper.when(r['date_start']) : null,
        'date_end': own ? OdooMapper.when(r['date_end']) : null,
        'rental_state': OdooMapper.key(
          r['rental_state'],
          RentalState.values,
          fallback: 'none',
        ),
        'picked_up_at': OdooMapper.when(r['picked_up_at']),
        'picked_up_by': m.user(r['picked_up_by']),
        'returned_at': OdooMapper.when(r['returned_at']),
        'returned_by': m.user(r['returned_by']),
        'condition_out': OdooMapper.key(
          r['condition_out'],
          Condition.values,
          fallback: 'good',
        ),
        'condition_in': OdooMapper.key(r['condition_in'], Condition.values),
        'condition_note': OdooMapper.text(r['condition_note']),
      };
    },
  ),
  OdooModelSpec(
    model: 'rentory.return.check',
    table: 'return_checks',
    archivable: false,
    fields: const [
      'line_id',
      'order_id',
      'serial_id',
      'serial_name',
      'condition',
      'note',
      'returned_at',
      'returned_by',
      'create_date',
    ],
    map: (r, m) => {
      'line_id': m.ref('rentory.order.line', r['line_id']),
      'order_id': m.ref('rentory.order', r['order_id']),
      'serial_id': m.ref('rentory.asset.serial', r['serial_id']),
      'serial_name': OdooMapper.text(r['serial_name']),
      'condition': OdooMapper.key(
        r['condition'],
        Condition.values,
        fallback: 'good',
      ),
      'note': OdooMapper.text(r['note']),
      'returned_at':
          OdooMapper.when(r['returned_at']) ??
          OdooMapper.when(r['create_date']),
      'returned_by': m.user(r['returned_by']),
    },
  ),
  OdooModelSpec(
    model: 'rentory.asset.photo',
    table: 'photos',
    archivable: false,
    fields: const ['asset_id', 'serial_id', 'sequence', 'name', 'create_date'],
    map: (r, m) => {
      'asset_id': m.ref('rentory.asset', r['asset_id']),
      'serial_id': m.ref('rentory.asset.serial', r['serial_id']),
      'sequence': OdooMapper.integer(r['sequence']),
      // The picture stays in Odoo; it is fetched when first shown.
      'storage_path': OdooRemoteStore.photoPath(OdooIds.odooId(r['id'])!),
      'taken_at': OdooMapper.when(r['create_date']),
      'note': OdooMapper.text(r['name']),
    },
  ),
];

/// Keeps a local copy of an Odoo database's Rentory data, the same tables
/// the Supabase mode uses, so every screen works unchanged.
///
/// Read only for now: nothing is pushed. Each pass reads what changed since
/// the newest `write_date` it saw per model; now and then it also asks for
/// every id, because Odoo deletes are real deletes.
class OdooSyncEngine extends SyncEngine {
  OdooSyncEngine(
    RentoryDatabase db,
    this.client, {
    super.interval = const Duration(seconds: 30),
    this.reconcileEvery = 10,
  }) : ids = OdooIds(client.credentials.database),
       super(db, OdooRemoteStore(client));

  final OdooClient client;
  final OdooIds ids;

  /// The key's owner, asked of Odoo on the first pass.
  OdooUser? get user => _user;
  OdooUser? _user;

  /// The signed-in user's profile id, once the first pass has run.
  String? get currentUserId =>
      _user == null ? null : ids.of('res.users', _user!.id);

  /// Passes between full id checks (the first pass always does one).
  final int reconcileEvery;
  int _passes = 0;
  Role? _role;

  static const _page = 500;

  @override
  Future<void> push() async {}

  @override
  Future<void> uploadPhotos() async {}

  @override
  Future<void> pull() async {
    final user = _user ??= await client.whoAmI();
    _role ??= await client.hasGroup(user.id, 'rentory.group_rentory_manager')
        ? Role.admin
        : Role.office;
    final mapper = OdooMapper(ids, uid: user.id, role: _role!);
    final reconcile = _passes++ % reconcileEvery == 0;
    final changed = <String>{};

    // Rows arrive in model order, but a page can still point at a record a
    // later page brings; the checks come back on at the end.
    await db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      for (final spec in rentorySpecs()) {
        if (await _pullModel(spec, mapper)) changed.add(spec.table);
        if (reconcile && await _reconcile(spec)) changed.add(spec.table);
      }
      if (await _pullPartners(mapper.partners, refresh: reconcile)) {
        changed.add('customers');
      }
      if ((reconcile || changed.contains('assets')) && await _assetImages()) {
        changed.add('photos');
      }
      // The profile row may predate this key's owner getting (or losing)
      // the manager group.
      await db.customStatement(
        'UPDATE profiles SET role = ? WHERE id = ? AND role <> ?',
        [_role!.key, ids.of('res.users', user.id), _role!.key],
      );
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON');
    }
    if (changed.contains('order_lines')) changed.add('order_line_serials');
    if (changed.contains('orders')) changed.add('order_documents');
    if (changed.isNotEmpty) {
      db.notifyUpdates({
        for (final t in db.allTables)
          if (changed.contains(t.actualTableName)) TableUpdate.onTable(t),
      });
    }
  }

  String _cursorName(String model) => 'odoo:$model';

  Future<String?> _cursor(String model) async {
    final row = await (db.select(
      db.syncCursors,
    )..where((c) => c.tableName_.equals(_cursorName(model)))).getSingleOrNull();
    final seconds = row?.serverSeq ?? 0;
    if (seconds == 0) return null;
    return _odooTime(
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
    );
  }

  static String _odooTime(DateTime t) =>
      t.toIso8601String().substring(0, 19).replaceFirst('T', ' ');

  /// Reads one model's changes. Returns whether anything changed locally.
  Future<bool> _pullModel(OdooModelSpec spec, OdooMapper mapper) async {
    final since = await _cursor(spec.model);
    final domain = [
      ...spec.domain,
      if (since != null) ['write_date', '>=', since],
    ];
    var offset = 0;
    var changed = false;
    DateTime? newest;
    while (true) {
      final rows = await client.searchRead(
        spec.model,
        domain: domain,
        fields: [...spec.fields, 'write_date'],
        order: 'write_date asc, id asc',
        limit: _page,
        offset: offset,
        activeTest: !spec.archivable,
      );
      if (rows.isEmpty) break;
      if (await _store(spec, rows, mapper)) changed = true;
      final last = DateTime.parse(OdooMapper.when(rows.last['write_date'])!);
      if (newest == null || last.isAfter(newest)) newest = last;
      if (rows.length < _page) break;
      offset += rows.length;
    }
    // Written quietly: a change notice would start another pass.
    final seconds = newest == null
        ? null
        : newest.millisecondsSinceEpoch ~/ 1000;
    if (seconds != null && _odooTime(newest!) != since) {
      await db.customStatement(
        'INSERT INTO sync_cursors (table_name, server_seq) VALUES (?, ?) '
        'ON CONFLICT(table_name) DO UPDATE SET server_seq = excluded.server_seq',
        [_cursorName(spec.model), seconds],
      );
    }
    return changed;
  }

  /// Reads [odooIds] of [model] again, whatever their `write_date`: after a
  /// change made from here, which can land within the second of the last
  /// one and look already held.
  Future<void> refetch(String model, List<int> odooIds) async {
    final spec = rentorySpecs().firstWhere((s) => s.model == model);
    final user = _user ??= await client.whoAmI();
    final mapper = OdooMapper(ids, uid: user.id, role: _role ?? Role.office);
    final rows = await client.searchRead(
      model,
      domain: [
        ['id', 'in', odooIds],
      ],
      fields: [...spec.fields, 'write_date'],
      activeTest: !spec.archivable,
    );
    if (rows.isEmpty) return;
    await db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await _store(spec, rows, mapper, force: true);
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON');
    }
    db.notifyUpdates({
      for (final t in db.allTables)
        if (t.actualTableName == spec.table) TableUpdate.onTable(t),
    });
  }

  /// Writes a page of records. Ones already held at the same `write_date`
  /// are skipped, so a quiet database writes nothing.
  Future<bool> _store(
    OdooModelSpec spec,
    List<Map<String, Object?>> rows,
    OdooMapper mapper, {
    bool force = false,
  }) async {
    final held = <String, String>{
      for (final r
          in await db
              .customSelect(
                'SELECT id, updated_at FROM "${spec.table}" '
                'WHERE id IN (${List.filled(rows.length, '?').join(', ')})',
                variables: [
                  for (final r in rows)
                    Variable.withString(
                      ids.of(spec.model, OdooIds.odooId(r['id'])!),
                    ),
                ],
              )
              .get())
        r.read<String>('id'): r.read<String>('updated_at'),
    };
    var changed = false;
    await db.transaction(() async {
      for (final r in rows) {
        final odooId = OdooIds.odooId(r['id'])!;
        final id = ids.of(spec.model, odooId);
        final at = OdooMapper.when(r['write_date'])!;
        // Partners are gathered even from records already held.
        final values = spec.map(r, mapper);
        if (!force && held[id] == at) continue;
        changed = true;
        await _upsert(spec.table, {
          'id': id,
          'odoo_id': odooId,
          'updated_at': at,
          'deleted': 0,
          'dirty': 0,
          ...values,
        });
        if (spec.table == 'order_lines') {
          await _links('order_line_serials', 'line_id', id, 'serial_id', [
            for (final s in OdooMapper.many(r['serial_ids']))
              ids.of('rentory.asset.serial', (s as num).toInt()),
          ], at);
        } else if (spec.table == 'orders') {
          await _links('order_documents', 'order_id', id, 'document_type_id', [
            for (final d in OdooMapper.many(r['document_ids']))
              ids.of('rentory.customer.document', (d as num).toInt()),
          ], at);
        }
      }
    });
    return changed;
  }

  Future<void> _upsert(String table, Map<String, Object?> row) {
    final columns = row.keys.toList();
    final updates = [
      for (final c in columns)
        if (c != 'id') '"$c" = excluded."$c"',
    ].join(', ');
    return db.customInsert(
      'INSERT INTO "$table" (${columns.map((c) => '"$c"').join(', ')}) '
      'VALUES (${List.filled(columns.length, '?').join(', ')}) '
      'ON CONFLICT(id) DO UPDATE SET $updates',
      variables: [for (final c in columns) Variable(row[c])],
    );
  }

  /// A many2many in Odoo is a link table here: replace the owner's rows.
  Future<void> _links(
    String table,
    String ownerColumn,
    String ownerId,
    String otherColumn,
    List<String> others,
    String at,
  ) async {
    await db.customStatement('DELETE FROM "$table" WHERE "$ownerColumn" = ?', [
      ownerId,
    ]);
    for (final other in others) {
      await _upsert(table, {
        'id': const Uuid().v5(Namespace.url.value, '$table/$ownerId/$other'),
        'updated_at': at,
        'deleted': 0,
        'dirty': 0,
        ownerColumn: ownerId,
        otherColumn: other,
      });
    }
  }

  /// Marks what Odoo no longer has as deleted.
  Future<bool> _reconcile(OdooModelSpec spec) async {
    final alive = (await client.search(
      spec.model,
      domain: spec.domain,
      activeTest: !spec.archivable,
    )).toSet();
    final held = await db
        .customSelect(
          'SELECT id, odoo_id FROM "${spec.table}" '
          'WHERE deleted = 0 AND odoo_id IS NOT NULL',
        )
        .get();
    final gone = [
      for (final r in held)
        if (!alive.contains(r.read<int>('odoo_id'))) r.read<String>('id'),
    ];
    if (gone.isEmpty) return false;
    await db.transaction(() async {
      for (final id in gone) {
        await db.customStatement(
          'UPDATE "${spec.table}" SET deleted = 1 WHERE id = ?',
          [id],
        );
      }
    });
    return true;
  }

  /// An asset's own picture (`image_1920`, the one Odoo shows on the asset)
  /// becomes the first photo of its gallery. The row id carries the asset's
  /// `write_date`, so a new picture is a new row and never a stale cache.
  Future<bool> _assetImages() async {
    final pictured = (await client.search(
      'rentory.asset',
      domain: const [
        ['image_1920', '!=', false],
      ],
      activeTest: false,
    )).toSet();
    final assets = await db
        .customSelect(
          'SELECT id, odoo_id, updated_at FROM assets '
          'WHERE odoo_id IS NOT NULL AND deleted = 0',
        )
        .get();
    final want = <String, ({String assetId, int odooId, String at})>{
      for (final a in assets)
        if (pictured.contains(a.read<int>('odoo_id')))
          ids.of(
            'rentory.asset.image',
            a.read<int>('odoo_id'),
            a.read<String>('updated_at'),
          ): (
            assetId: a.read<String>('id'),
            odooId: a.read<int>('odoo_id'),
            at: a.read<String>('updated_at'),
          ),
    };
    final have = {
      for (final r
          in await db
              .customSelect(
                'SELECT id FROM photos WHERE storage_path LIKE ?',
                variables: [
                  Variable.withString('${OdooRemoteStore.assetPrefix}%'),
                ],
              )
              .get())
        r.read<String>('id'),
    };
    final stale = have.difference(want.keys.toSet());
    final fresh = want.keys.toSet().difference(have);
    if (stale.isEmpty && fresh.isEmpty) return false;
    await db.transaction(() async {
      for (final id in stale) {
        await db.customStatement('DELETE FROM photos WHERE id = ?', [id]);
      }
      for (final id in fresh) {
        final a = want[id]!;
        await _upsert('photos', {
          'id': id,
          'updated_at': a.at,
          'deleted': 0,
          'dirty': 0,
          'asset_id': a.assetId,
          // Before the unit galleries, which start at Odoo's sequence 10.
          'sequence': -1000,
          'storage_path': OdooRemoteStore.assetImagePath(a.odooId),
          'taken_at': a.at,
        });
      }
    });
    return true;
  }

  /// Customers are Odoo contacts. Only the ones Rentory records point at are
  /// copied; on a full pass the ones already held are refreshed too.
  Future<bool> _pullPartners(Set<int> wanted, {required bool refresh}) async {
    final held = {
      for (final r
          in await db
              .customSelect(
                'SELECT odoo_id, updated_at FROM customers WHERE odoo_id IS NOT NULL',
              )
              .get())
        r.read<int>('odoo_id'): r.read<String>('updated_at'),
    };
    final fetch = refresh
        ? {...wanted, ...held.keys}
        : wanted.difference(held.keys.toSet());
    if (fetch.isEmpty) return false;
    var changed = false;
    final list = fetch.toList();
    for (var i = 0; i < list.length; i += _page) {
      final rows = await client.read(
        'res.partner',
        list.sublist(i, i + _page > list.length ? list.length : i + _page),
        fields: const ['name', 'phone', 'write_date'],
      );
      await db.transaction(() async {
        for (final r in rows) {
          final odooId = OdooIds.odooId(r['id'])!;
          final at = OdooMapper.when(r['write_date'])!;
          if (held[odooId] == at) continue;
          changed = true;
          await _upsert('customers', {
            'id': ids.of('res.partner', odooId),
            'odoo_id': odooId,
            'updated_at': at,
            'deleted': 0,
            'dirty': 0,
            'name': OdooMapper.text(r['name']) ?? '',
            'phone': OdooMapper.text(r['phone']),
          });
        }
      });
    }
    return changed;
  }
}

/// The few [RemoteStore] calls an Odoo pass makes: only photos, which are
/// fetched from Odoo when first shown.
class OdooRemoteStore implements RemoteStore {
  OdooRemoteStore(this.client);
  final OdooClient client;

  static const _photoPrefix = 'odoo/rentory.asset.photo/';
  static const assetPrefix = 'odoo/rentory.asset/';

  static String photoPath(int photoId) => '$_photoPrefix$photoId.jpg';
  static String assetImagePath(int assetId) => '$assetPrefix$assetId.jpg';

  static Never _readOnly() => throw RuleException.one(
    'Connected to Odoo: changes are not sent to Odoo yet.',
  );

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async =>
      _readOnly();

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    int afterSeq, {
    int limit = 500,
  }) async => const [];

  @override
  Future<String> bookOrder(String orderId, {List<String>? lineIds}) async =>
      _readOnly();

  @override
  Future<void> uploadPhoto(String path, Uint8List bytes) async => _readOnly();

  @override
  Future<Uint8List> downloadPhoto(String path) async {
    final (model, prefix) = path.startsWith(_photoPrefix)
        ? ('rentory.asset.photo', _photoPrefix)
        : path.startsWith(assetPrefix)
        ? ('rentory.asset', assetPrefix)
        : throw ArgumentError.value(path, 'path', 'Not an Odoo photo');
    final id = int.parse(path.substring(prefix.length).split('.').first);
    final rows = await client.read(model, [id], fields: const ['image_1920']);
    final data = rows.isEmpty ? null : rows.first['image_1920'];
    if (data is! String || data.isEmpty) {
      throw StateError('Photo $id has no picture in Odoo');
    }
    return base64Decode(data);
  }
}
