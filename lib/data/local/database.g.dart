// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Role, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('office'),
      ).withConverter<Role>($ProfilesTable.$converterrole);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: $ProfilesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<Role, String> $converterrole = const KeyConverter(
    Role.values,
  );
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final Role role;
  const Profile({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    {
      map['role'] = Variable<String>($ProfilesTable.$converterrole.toSql(role));
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      role: Value(role),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<Role>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<Role>(role),
    };
  }

  Profile copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Role? role,
  }) => Profile(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    role: role ?? this.role,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deleted, dirty, odooId, name, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.role == this.role);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<Role> role;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<Role>? role,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $ProfilesTable.$converterrole.toSql(role.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    phone,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final String? phone;
  final String? notes;
  const Customer({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    this.phone,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Customer copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    notes: notes.present ? notes.value : this.notes,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deleted, dirty, odooId, name, phone, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.notes == this.notes);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> notes;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentTypesTable extends DocumentTypes
    with TableInfo<$DocumentTypesTable, DocumentType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    sequence,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $DocumentTypesTable createAlias(String alias) {
    return $DocumentTypesTable(attachedDatabase, alias);
  }
}

class DocumentType extends DataClass implements Insertable<DocumentType> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final int sequence;
  final bool active;
  const DocumentType({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    required this.sequence,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    map['sequence'] = Variable<int>(sequence);
    map['active'] = Variable<bool>(active);
    return map;
  }

  DocumentTypesCompanion toCompanion(bool nullToAbsent) {
    return DocumentTypesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      sequence: Value(sequence),
      active: Value(active),
    );
  }

  factory DocumentType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentType(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      sequence: serializer.fromJson<int>(json['sequence']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'sequence': serializer.toJson<int>(sequence),
      'active': serializer.toJson<bool>(active),
    };
  }

  DocumentType copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    int? sequence,
    bool? active,
  }) => DocumentType(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    sequence: sequence ?? this.sequence,
    active: active ?? this.active,
  );
  DocumentType copyWithCompanion(DocumentTypesCompanion data) {
    return DocumentType(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentType(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('sequence: $sequence, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    sequence,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentType &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.sequence == this.sequence &&
          other.active == this.active);
}

class DocumentTypesCompanion extends UpdateCompanion<DocumentType> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<int> sequence;
  final Value<bool> active;
  final Value<int> rowid;
  const DocumentTypesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.sequence = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentTypesCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.sequence = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DocumentType> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<int>? sequence,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (sequence != null) 'sequence': sequence,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentTypesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<int>? sequence,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return DocumentTypesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      sequence: sequence ?? this.sequence,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTypesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('sequence: $sequence, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerDiscountsTable extends CustomerDiscounts
    with TableInfo<$CustomerDiscountsTable, CustomerDiscount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerDiscountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DiscountType, String>
  discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('percent'),
  ).withConverter<DiscountType>($CustomerDiscountsTable.$converterdiscountType);
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<double> discountValue = GeneratedColumn<double>(
    'discount_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateFromMeta = const VerificationMeta(
    'dateFrom',
  );
  @override
  late final GeneratedColumn<DateTime> dateFrom = GeneratedColumn<DateTime>(
    'date_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<DateTime> dateTo = GeneratedColumn<DateTime>(
    'date_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    customerId,
    discountType,
    discountValue,
    dateFrom,
    dateTo,
    note,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_discounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerDiscount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('date_from')) {
      context.handle(
        _dateFromMeta,
        dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta),
      );
    }
    if (data.containsKey('date_to')) {
      context.handle(
        _dateToMeta,
        dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerDiscount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerDiscount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      discountType: $CustomerDiscountsTable.$converterdiscountType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discount_type'],
        )!,
      ),
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_value'],
      )!,
      dateFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_from'],
      ),
      dateTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_to'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CustomerDiscountsTable createAlias(String alias) {
    return $CustomerDiscountsTable(attachedDatabase, alias);
  }

  static TypeConverter<DiscountType, String> $converterdiscountType =
      const KeyConverter(DiscountType.values);
}

class CustomerDiscount extends DataClass
    implements Insertable<CustomerDiscount> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final String? customerId;
  final DiscountType discountType;
  final double discountValue;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? note;
  final bool active;
  const CustomerDiscount({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    this.customerId,
    required this.discountType,
    required this.discountValue,
    this.dateFrom,
    this.dateTo,
    this.note,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    {
      map['discount_type'] = Variable<String>(
        $CustomerDiscountsTable.$converterdiscountType.toSql(discountType),
      );
    }
    map['discount_value'] = Variable<double>(discountValue);
    if (!nullToAbsent || dateFrom != null) {
      map['date_from'] = Variable<DateTime>(dateFrom);
    }
    if (!nullToAbsent || dateTo != null) {
      map['date_to'] = Variable<DateTime>(dateTo);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  CustomerDiscountsCompanion toCompanion(bool nullToAbsent) {
    return CustomerDiscountsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      discountType: Value(discountType),
      discountValue: Value(discountValue),
      dateFrom: dateFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(dateFrom),
      dateTo: dateTo == null && nullToAbsent
          ? const Value.absent()
          : Value(dateTo),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      active: Value(active),
    );
  }

  factory CustomerDiscount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerDiscount(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      discountType: serializer.fromJson<DiscountType>(json['discountType']),
      discountValue: serializer.fromJson<double>(json['discountValue']),
      dateFrom: serializer.fromJson<DateTime?>(json['dateFrom']),
      dateTo: serializer.fromJson<DateTime?>(json['dateTo']),
      note: serializer.fromJson<String?>(json['note']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'customerId': serializer.toJson<String?>(customerId),
      'discountType': serializer.toJson<DiscountType>(discountType),
      'discountValue': serializer.toJson<double>(discountValue),
      'dateFrom': serializer.toJson<DateTime?>(dateFrom),
      'dateTo': serializer.toJson<DateTime?>(dateTo),
      'note': serializer.toJson<String?>(note),
      'active': serializer.toJson<bool>(active),
    };
  }

  CustomerDiscount copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Value<String?> customerId = const Value.absent(),
    DiscountType? discountType,
    double? discountValue,
    Value<DateTime?> dateFrom = const Value.absent(),
    Value<DateTime?> dateTo = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? active,
  }) => CustomerDiscount(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    customerId: customerId.present ? customerId.value : this.customerId,
    discountType: discountType ?? this.discountType,
    discountValue: discountValue ?? this.discountValue,
    dateFrom: dateFrom.present ? dateFrom.value : this.dateFrom,
    dateTo: dateTo.present ? dateTo.value : this.dateTo,
    note: note.present ? note.value : this.note,
    active: active ?? this.active,
  );
  CustomerDiscount copyWithCompanion(CustomerDiscountsCompanion data) {
    return CustomerDiscount(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      dateFrom: data.dateFrom.present ? data.dateFrom.value : this.dateFrom,
      dateTo: data.dateTo.present ? data.dateTo.value : this.dateTo,
      note: data.note.present ? data.note.value : this.note,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerDiscount(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('customerId: $customerId, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('note: $note, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    customerId,
    discountType,
    discountValue,
    dateFrom,
    dateTo,
    note,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerDiscount &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.customerId == this.customerId &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.note == this.note &&
          other.active == this.active);
}

class CustomerDiscountsCompanion extends UpdateCompanion<CustomerDiscount> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> customerId;
  final Value<DiscountType> discountType;
  final Value<double> discountValue;
  final Value<DateTime?> dateFrom;
  final Value<DateTime?> dateTo;
  final Value<String?> note;
  final Value<bool> active;
  final Value<int> rowid;
  const CustomerDiscountsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.customerId = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerDiscountsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.customerId = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CustomerDiscount> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? customerId,
    Expression<String>? discountType,
    Expression<double>? discountValue,
    Expression<DateTime>? dateFrom,
    Expression<DateTime>? dateTo,
    Expression<String>? note,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (customerId != null) 'customer_id': customerId,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (note != null) 'note': note,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerDiscountsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<String?>? customerId,
    Value<DiscountType>? discountType,
    Value<double>? discountValue,
    Value<DateTime?>? dateFrom,
    Value<DateTime?>? dateTo,
    Value<String?>? note,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CustomerDiscountsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      customerId: customerId ?? this.customerId,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      note: note ?? this.note,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(
        $CustomerDiscountsTable.$converterdiscountType.toSql(
          discountType.value,
        ),
      );
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<double>(discountValue.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<DateTime>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<DateTime>(dateTo.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerDiscountsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('customerId: $customerId, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('note: $note, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    parentId,
    color,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final String? parentId;
  final int color;
  final bool active;
  const Category({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    this.parentId,
    required this.color,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['color'] = Variable<int>(color);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      color: Value(color),
      active: Value(active),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      color: serializer.fromJson<int>(json['color']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'color': serializer.toJson<int>(color),
      'active': serializer.toJson<bool>(active),
    };
  }

  Category copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Value<String?> parentId = const Value.absent(),
    int? color,
    bool? active,
  }) => Category(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    color: color ?? this.color,
    active: active ?? this.active,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      color: data.color.present ? data.color.value : this.color,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    parentId,
    color,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.color == this.color &&
          other.active == this.active);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<int> color;
  final Value<bool> active;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? color,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (color != null) 'color': color,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<String?>? parentId,
    Value<int>? color,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      color: color ?? this.color,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    parentId,
    note,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final String? parentId;
  final String? note;
  final bool active;
  const Location({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    this.parentId,
    this.note,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      active: Value(active),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      note: serializer.fromJson<String?>(json['note']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'note': serializer.toJson<String?>(note),
      'active': serializer.toJson<bool>(active),
    };
  }

  Location copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Value<String?> parentId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? active,
  }) => Location(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    note: note.present ? note.value : this.note,
    active: active ?? this.active,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      note: data.note.present ? data.note.value : this.note,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('note: $note, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    parentId,
    note,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.note == this.note &&
          other.active == this.active);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String?> note;
  final Value<bool> active;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Location> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? note,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (note != null) 'note': note,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<String?>? parentId,
    Value<String?>? note,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      note: note ?? this.note,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('note: $note, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Tracking, String> tracking =
      GeneratedColumn<String>(
        'tracking',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('none'),
      ).withConverter<Tracking>($AssetsTable.$convertertracking);
  static const VerificationMeta _rentalOkMeta = const VerificationMeta(
    'rentalOk',
  );
  @override
  late final GeneratedColumn<bool> rentalOk = GeneratedColumn<bool>(
    'rental_ok',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rental_ok" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _qtyManualMeta = const VerificationMeta(
    'qtyManual',
  );
  @override
  late final GeneratedColumn<double> qtyManual = GeneratedColumn<double>(
    'qty_manual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _rentalPriceDayMeta = const VerificationMeta(
    'rentalPriceDay',
  );
  @override
  late final GeneratedColumn<double> rentalPriceDay = GeneratedColumn<double>(
    'rental_price_day',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _declaredValueMeta = const VerificationMeta(
    'declaredValue',
  );
  @override
  late final GeneratedColumn<double> declaredValue = GeneratedColumn<double>(
    'declared_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    code,
    barcode,
    categoryId,
    tracking,
    rentalOk,
    qtyManual,
    rentalPriceDay,
    declaredValue,
    locationId,
    imagePath,
    notes,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('rental_ok')) {
      context.handle(
        _rentalOkMeta,
        rentalOk.isAcceptableOrUnknown(data['rental_ok']!, _rentalOkMeta),
      );
    }
    if (data.containsKey('qty_manual')) {
      context.handle(
        _qtyManualMeta,
        qtyManual.isAcceptableOrUnknown(data['qty_manual']!, _qtyManualMeta),
      );
    }
    if (data.containsKey('rental_price_day')) {
      context.handle(
        _rentalPriceDayMeta,
        rentalPriceDay.isAcceptableOrUnknown(
          data['rental_price_day']!,
          _rentalPriceDayMeta,
        ),
      );
    }
    if (data.containsKey('declared_value')) {
      context.handle(
        _declaredValueMeta,
        declaredValue.isAcceptableOrUnknown(
          data['declared_value']!,
          _declaredValueMeta,
        ),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      tracking: $AssetsTable.$convertertracking.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking'],
        )!,
      ),
      rentalOk: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rental_ok'],
      )!,
      qtyManual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty_manual'],
      )!,
      rentalPriceDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rental_price_day'],
      )!,
      declaredValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}declared_value'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }

  static TypeConverter<Tracking, String> $convertertracking =
      const KeyConverter(Tracking.values);
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String name;
  final String? code;
  final String? barcode;
  final String? categoryId;
  final Tracking tracking;
  final bool rentalOk;

  /// Stock of an untracked asset. Serial assets count their units instead.
  final double qtyManual;
  final double rentalPriceDay;
  final double declaredValue;
  final String? locationId;
  final String? imagePath;
  final String? notes;
  final bool active;
  const Asset({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.name,
    this.code,
    this.barcode,
    this.categoryId,
    required this.tracking,
    required this.rentalOk,
    required this.qtyManual,
    required this.rentalPriceDay,
    required this.declaredValue,
    this.locationId,
    this.imagePath,
    this.notes,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    {
      map['tracking'] = Variable<String>(
        $AssetsTable.$convertertracking.toSql(tracking),
      );
    }
    map['rental_ok'] = Variable<bool>(rentalOk);
    map['qty_manual'] = Variable<double>(qtyManual);
    map['rental_price_day'] = Variable<double>(rentalPriceDay);
    map['declared_value'] = Variable<double>(declaredValue);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      tracking: Value(tracking),
      rentalOk: Value(rentalOk),
      qtyManual: Value(qtyManual),
      rentalPriceDay: Value(rentalPriceDay),
      declaredValue: Value(declaredValue),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      active: Value(active),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      tracking: serializer.fromJson<Tracking>(json['tracking']),
      rentalOk: serializer.fromJson<bool>(json['rentalOk']),
      qtyManual: serializer.fromJson<double>(json['qtyManual']),
      rentalPriceDay: serializer.fromJson<double>(json['rentalPriceDay']),
      declaredValue: serializer.fromJson<double>(json['declaredValue']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      notes: serializer.fromJson<String?>(json['notes']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'barcode': serializer.toJson<String?>(barcode),
      'categoryId': serializer.toJson<String?>(categoryId),
      'tracking': serializer.toJson<Tracking>(tracking),
      'rentalOk': serializer.toJson<bool>(rentalOk),
      'qtyManual': serializer.toJson<double>(qtyManual),
      'rentalPriceDay': serializer.toJson<double>(rentalPriceDay),
      'declaredValue': serializer.toJson<double>(declaredValue),
      'locationId': serializer.toJson<String?>(locationId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'notes': serializer.toJson<String?>(notes),
      'active': serializer.toJson<bool>(active),
    };
  }

  Asset copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? name,
    Value<String?> code = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Tracking? tracking,
    bool? rentalOk,
    double? qtyManual,
    double? rentalPriceDay,
    double? declaredValue,
    Value<String?> locationId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? active,
  }) => Asset(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    barcode: barcode.present ? barcode.value : this.barcode,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    tracking: tracking ?? this.tracking,
    rentalOk: rentalOk ?? this.rentalOk,
    qtyManual: qtyManual ?? this.qtyManual,
    rentalPriceDay: rentalPriceDay ?? this.rentalPriceDay,
    declaredValue: declaredValue ?? this.declaredValue,
    locationId: locationId.present ? locationId.value : this.locationId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    notes: notes.present ? notes.value : this.notes,
    active: active ?? this.active,
  );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      tracking: data.tracking.present ? data.tracking.value : this.tracking,
      rentalOk: data.rentalOk.present ? data.rentalOk.value : this.rentalOk,
      qtyManual: data.qtyManual.present ? data.qtyManual.value : this.qtyManual,
      rentalPriceDay: data.rentalPriceDay.present
          ? data.rentalPriceDay.value
          : this.rentalPriceDay,
      declaredValue: data.declaredValue.present
          ? data.declaredValue.value
          : this.declaredValue,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('tracking: $tracking, ')
          ..write('rentalOk: $rentalOk, ')
          ..write('qtyManual: $qtyManual, ')
          ..write('rentalPriceDay: $rentalPriceDay, ')
          ..write('declaredValue: $declaredValue, ')
          ..write('locationId: $locationId, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    name,
    code,
    barcode,
    categoryId,
    tracking,
    rentalOk,
    qtyManual,
    rentalPriceDay,
    declaredValue,
    locationId,
    imagePath,
    notes,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.name == this.name &&
          other.code == this.code &&
          other.barcode == this.barcode &&
          other.categoryId == this.categoryId &&
          other.tracking == this.tracking &&
          other.rentalOk == this.rentalOk &&
          other.qtyManual == this.qtyManual &&
          other.rentalPriceDay == this.rentalPriceDay &&
          other.declaredValue == this.declaredValue &&
          other.locationId == this.locationId &&
          other.imagePath == this.imagePath &&
          other.notes == this.notes &&
          other.active == this.active);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> barcode;
  final Value<String?> categoryId;
  final Value<Tracking> tracking;
  final Value<bool> rentalOk;
  final Value<double> qtyManual;
  final Value<double> rentalPriceDay;
  final Value<double> declaredValue;
  final Value<String?> locationId;
  final Value<String?> imagePath;
  final Value<String?> notes;
  final Value<bool> active;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.tracking = const Value.absent(),
    this.rentalOk = const Value.absent(),
    this.qtyManual = const Value.absent(),
    this.rentalPriceDay = const Value.absent(),
    this.declaredValue = const Value.absent(),
    this.locationId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.tracking = const Value.absent(),
    this.rentalOk = const Value.absent(),
    this.qtyManual = const Value.absent(),
    this.rentalPriceDay = const Value.absent(),
    this.declaredValue = const Value.absent(),
    this.locationId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? barcode,
    Expression<String>? categoryId,
    Expression<String>? tracking,
    Expression<bool>? rentalOk,
    Expression<double>? qtyManual,
    Expression<double>? rentalPriceDay,
    Expression<double>? declaredValue,
    Expression<String>? locationId,
    Expression<String>? imagePath,
    Expression<String>? notes,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (barcode != null) 'barcode': barcode,
      if (categoryId != null) 'category_id': categoryId,
      if (tracking != null) 'tracking': tracking,
      if (rentalOk != null) 'rental_ok': rentalOk,
      if (qtyManual != null) 'qty_manual': qtyManual,
      if (rentalPriceDay != null) 'rental_price_day': rentalPriceDay,
      if (declaredValue != null) 'declared_value': declaredValue,
      if (locationId != null) 'location_id': locationId,
      if (imagePath != null) 'image_path': imagePath,
      if (notes != null) 'notes': notes,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? name,
    Value<String?>? code,
    Value<String?>? barcode,
    Value<String?>? categoryId,
    Value<Tracking>? tracking,
    Value<bool>? rentalOk,
    Value<double>? qtyManual,
    Value<double>? rentalPriceDay,
    Value<double>? declaredValue,
    Value<String?>? locationId,
    Value<String?>? imagePath,
    Value<String?>? notes,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      name: name ?? this.name,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      tracking: tracking ?? this.tracking,
      rentalOk: rentalOk ?? this.rentalOk,
      qtyManual: qtyManual ?? this.qtyManual,
      rentalPriceDay: rentalPriceDay ?? this.rentalPriceDay,
      declaredValue: declaredValue ?? this.declaredValue,
      locationId: locationId ?? this.locationId,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (tracking.present) {
      map['tracking'] = Variable<String>(
        $AssetsTable.$convertertracking.toSql(tracking.value),
      );
    }
    if (rentalOk.present) {
      map['rental_ok'] = Variable<bool>(rentalOk.value);
    }
    if (qtyManual.present) {
      map['qty_manual'] = Variable<double>(qtyManual.value);
    }
    if (rentalPriceDay.present) {
      map['rental_price_day'] = Variable<double>(rentalPriceDay.value);
    }
    if (declaredValue.present) {
      map['declared_value'] = Variable<double>(declaredValue.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('tracking: $tracking, ')
          ..write('rentalOk: $rentalOk, ')
          ..write('qtyManual: $qtyManual, ')
          ..write('rentalPriceDay: $rentalPriceDay, ')
          ..write('declaredValue: $declaredValue, ')
          ..write('locationId: $locationId, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SerialsTable extends Serials with TableInfo<$SerialsTable, Serial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SerialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SerialState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('available'),
      ).withConverter<SerialState>($SerialsTable.$converterstate);
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _currentOrderIdMeta = const VerificationMeta(
    'currentOrderId',
  );
  @override
  late final GeneratedColumn<String> currentOrderId = GeneratedColumn<String>(
    'current_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentLineIdMeta = const VerificationMeta(
    'currentLineId',
  );
  @override
  late final GeneratedColumn<String> currentLineId = GeneratedColumn<String>(
    'current_line_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _declaredValueMeta = const VerificationMeta(
    'declaredValue',
  );
  @override
  late final GeneratedColumn<double> declaredValue = GeneratedColumn<double>(
    'declared_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    assetId,
    name,
    barcode,
    state,
    locationId,
    currentOrderId,
    currentLineId,
    declaredValue,
    note,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'serials';
  @override
  VerificationContext validateIntegrity(
    Insertable<Serial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('current_order_id')) {
      context.handle(
        _currentOrderIdMeta,
        currentOrderId.isAcceptableOrUnknown(
          data['current_order_id']!,
          _currentOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('current_line_id')) {
      context.handle(
        _currentLineIdMeta,
        currentLineId.isAcceptableOrUnknown(
          data['current_line_id']!,
          _currentLineIdMeta,
        ),
      );
    }
    if (data.containsKey('declared_value')) {
      context.handle(
        _declaredValueMeta,
        declaredValue.isAcceptableOrUnknown(
          data['declared_value']!,
          _declaredValueMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Serial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Serial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      state: $SerialsTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      currentOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_order_id'],
      ),
      currentLineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_line_id'],
      ),
      declaredValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}declared_value'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $SerialsTable createAlias(String alias) {
    return $SerialsTable(attachedDatabase, alias);
  }

  static TypeConverter<SerialState, String> $converterstate =
      const KeyConverter(SerialState.values);
}

class Serial extends DataClass implements Insertable<Serial> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String assetId;
  final String name;
  final String? barcode;
  final SerialState state;
  final String? locationId;
  final String? currentOrderId;
  final String? currentLineId;
  final double declaredValue;
  final String? note;
  final bool active;
  const Serial({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.assetId,
    required this.name,
    this.barcode,
    required this.state,
    this.locationId,
    this.currentOrderId,
    this.currentLineId,
    required this.declaredValue,
    this.note,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['asset_id'] = Variable<String>(assetId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    {
      map['state'] = Variable<String>(
        $SerialsTable.$converterstate.toSql(state),
      );
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || currentOrderId != null) {
      map['current_order_id'] = Variable<String>(currentOrderId);
    }
    if (!nullToAbsent || currentLineId != null) {
      map['current_line_id'] = Variable<String>(currentLineId);
    }
    map['declared_value'] = Variable<double>(declaredValue);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  SerialsCompanion toCompanion(bool nullToAbsent) {
    return SerialsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      assetId: Value(assetId),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      state: Value(state),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      currentOrderId: currentOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentOrderId),
      currentLineId: currentLineId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentLineId),
      declaredValue: Value(declaredValue),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      active: Value(active),
    );
  }

  factory Serial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Serial(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      state: serializer.fromJson<SerialState>(json['state']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      currentOrderId: serializer.fromJson<String?>(json['currentOrderId']),
      currentLineId: serializer.fromJson<String?>(json['currentLineId']),
      declaredValue: serializer.fromJson<double>(json['declaredValue']),
      note: serializer.fromJson<String?>(json['note']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'assetId': serializer.toJson<String>(assetId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'state': serializer.toJson<SerialState>(state),
      'locationId': serializer.toJson<String?>(locationId),
      'currentOrderId': serializer.toJson<String?>(currentOrderId),
      'currentLineId': serializer.toJson<String?>(currentLineId),
      'declaredValue': serializer.toJson<double>(declaredValue),
      'note': serializer.toJson<String?>(note),
      'active': serializer.toJson<bool>(active),
    };
  }

  Serial copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? assetId,
    String? name,
    Value<String?> barcode = const Value.absent(),
    SerialState? state,
    Value<String?> locationId = const Value.absent(),
    Value<String?> currentOrderId = const Value.absent(),
    Value<String?> currentLineId = const Value.absent(),
    double? declaredValue,
    Value<String?> note = const Value.absent(),
    bool? active,
  }) => Serial(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    assetId: assetId ?? this.assetId,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    state: state ?? this.state,
    locationId: locationId.present ? locationId.value : this.locationId,
    currentOrderId: currentOrderId.present
        ? currentOrderId.value
        : this.currentOrderId,
    currentLineId: currentLineId.present
        ? currentLineId.value
        : this.currentLineId,
    declaredValue: declaredValue ?? this.declaredValue,
    note: note.present ? note.value : this.note,
    active: active ?? this.active,
  );
  Serial copyWithCompanion(SerialsCompanion data) {
    return Serial(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      state: data.state.present ? data.state.value : this.state,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      currentOrderId: data.currentOrderId.present
          ? data.currentOrderId.value
          : this.currentOrderId,
      currentLineId: data.currentLineId.present
          ? data.currentLineId.value
          : this.currentLineId,
      declaredValue: data.declaredValue.present
          ? data.declaredValue.value
          : this.declaredValue,
      note: data.note.present ? data.note.value : this.note,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Serial(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('state: $state, ')
          ..write('locationId: $locationId, ')
          ..write('currentOrderId: $currentOrderId, ')
          ..write('currentLineId: $currentLineId, ')
          ..write('declaredValue: $declaredValue, ')
          ..write('note: $note, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    assetId,
    name,
    barcode,
    state,
    locationId,
    currentOrderId,
    currentLineId,
    declaredValue,
    note,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Serial &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.assetId == this.assetId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.state == this.state &&
          other.locationId == this.locationId &&
          other.currentOrderId == this.currentOrderId &&
          other.currentLineId == this.currentLineId &&
          other.declaredValue == this.declaredValue &&
          other.note == this.note &&
          other.active == this.active);
}

class SerialsCompanion extends UpdateCompanion<Serial> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> assetId;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<SerialState> state;
  final Value<String?> locationId;
  final Value<String?> currentOrderId;
  final Value<String?> currentLineId;
  final Value<double> declaredValue;
  final Value<String?> note;
  final Value<bool> active;
  final Value<int> rowid;
  const SerialsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.state = const Value.absent(),
    this.locationId = const Value.absent(),
    this.currentOrderId = const Value.absent(),
    this.currentLineId = const Value.absent(),
    this.declaredValue = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SerialsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String assetId,
    required String name,
    this.barcode = const Value.absent(),
    this.state = const Value.absent(),
    this.locationId = const Value.absent(),
    this.currentOrderId = const Value.absent(),
    this.currentLineId = const Value.absent(),
    this.declaredValue = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       name = Value(name);
  static Insertable<Serial> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? assetId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? state,
    Expression<String>? locationId,
    Expression<String>? currentOrderId,
    Expression<String>? currentLineId,
    Expression<double>? declaredValue,
    Expression<String>? note,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (assetId != null) 'asset_id': assetId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (state != null) 'state': state,
      if (locationId != null) 'location_id': locationId,
      if (currentOrderId != null) 'current_order_id': currentOrderId,
      if (currentLineId != null) 'current_line_id': currentLineId,
      if (declaredValue != null) 'declared_value': declaredValue,
      if (note != null) 'note': note,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SerialsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? assetId,
    Value<String>? name,
    Value<String?>? barcode,
    Value<SerialState>? state,
    Value<String?>? locationId,
    Value<String?>? currentOrderId,
    Value<String?>? currentLineId,
    Value<double>? declaredValue,
    Value<String?>? note,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return SerialsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      state: state ?? this.state,
      locationId: locationId ?? this.locationId,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      currentLineId: currentLineId ?? this.currentLineId,
      declaredValue: declaredValue ?? this.declaredValue,
      note: note ?? this.note,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $SerialsTable.$converterstate.toSql(state.value),
      );
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (currentOrderId.present) {
      map['current_order_id'] = Variable<String>(currentOrderId.value);
    }
    if (currentLineId.present) {
      map['current_line_id'] = Variable<String>(currentLineId.value);
    }
    if (declaredValue.present) {
      map['declared_value'] = Variable<double>(declaredValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerialsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('state: $state, ')
          ..write('locationId: $locationId, ')
          ..write('currentOrderId: $currentOrderId, ')
          ..write('currentLineId: $currentLineId, ')
          ..write('declaredValue: $declaredValue, ')
          ..write('note: $note, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateStartMeta = const VerificationMeta(
    'dateStart',
  );
  @override
  late final GeneratedColumn<DateTime> dateStart = GeneratedColumn<DateTime>(
    'date_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateEndMeta = const VerificationMeta(
    'dateEnd',
  );
  @override
  late final GeneratedColumn<DateTime> dateEnd = GeneratedColumn<DateTime>(
    'date_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrderState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('draft'),
      ).withConverter<OrderState>($OrdersTable.$converterstate);
  @override
  late final GeneratedColumnWithTypeConverter<DiscountType, String>
  discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('percent'),
  ).withConverter<DiscountType>($OrdersTable.$converterdiscountType);
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<double> discountValue = GeneratedColumn<double>(
    'discount_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _customerDiscountIdMeta =
      const VerificationMeta('customerDiscountId');
  @override
  late final GeneratedColumn<String> customerDiscountId =
      GeneratedColumn<String>(
        'customer_discount_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customer_discounts (id)',
        ),
      );
  static const VerificationMeta _amountDepositMeta = const VerificationMeta(
    'amountDeposit',
  );
  @override
  late final GeneratedColumn<double> amountDeposit = GeneratedColumn<double>(
    'amount_deposit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountPaidMeta = const VerificationMeta(
    'amountPaid',
  );
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
    'amount_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lateFeeManualMeta = const VerificationMeta(
    'lateFeeManual',
  );
  @override
  late final GeneratedColumn<bool> lateFeeManual = GeneratedColumn<bool>(
    'late_fee_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("late_fee_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lateDaysEditedMeta = const VerificationMeta(
    'lateDaysEdited',
  );
  @override
  late final GeneratedColumn<bool> lateDaysEdited = GeneratedColumn<bool>(
    'late_days_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("late_days_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lateDaysOverrideMeta = const VerificationMeta(
    'lateDaysOverride',
  );
  @override
  late final GeneratedColumn<int> lateDaysOverride = GeneratedColumn<int>(
    'late_days_override',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sigRentalContractMeta = const VerificationMeta(
    'sigRentalContract',
  );
  @override
  late final GeneratedColumn<bool> sigRentalContract = GeneratedColumn<bool>(
    'sig_rental_contract',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sig_rental_contract" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sigPickupReturnReceiptMeta =
      const VerificationMeta('sigPickupReturnReceipt');
  @override
  late final GeneratedColumn<bool> sigPickupReturnReceipt =
      GeneratedColumn<bool>(
        'sig_pickup_return_receipt',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sig_pickup_return_receipt" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _sigLoanContractMeta = const VerificationMeta(
    'sigLoanContract',
  );
  @override
  late final GeneratedColumn<bool> sigLoanContract = GeneratedColumn<bool>(
    'sig_loan_contract',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sig_loan_contract" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _itemsCapturedMeta = const VerificationMeta(
    'itemsCaptured',
  );
  @override
  late final GeneratedColumn<bool> itemsCaptured = GeneratedColumn<bool>(
    'items_captured',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("items_captured" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _itemsExaminedMeta = const VerificationMeta(
    'itemsExamined',
  );
  @override
  late final GeneratedColumn<bool> itemsExamined = GeneratedColumn<bool>(
    'items_examined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("items_examined" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _itemsExaminedAtMeta = const VerificationMeta(
    'itemsExaminedAt',
  );
  @override
  late final GeneratedColumn<DateTime> itemsExaminedAt =
      GeneratedColumn<DateTime>(
        'items_examined_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _itemsExaminedByMeta = const VerificationMeta(
    'itemsExaminedBy',
  );
  @override
  late final GeneratedColumn<String> itemsExaminedBy = GeneratedColumn<String>(
    'items_examined_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentsReturnedAtMeta =
      const VerificationMeta('documentsReturnedAt');
  @override
  late final GeneratedColumn<DateTime> documentsReturnedAt =
      GeneratedColumn<DateTime>(
        'documents_returned_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _documentsReturnedByMeta =
      const VerificationMeta('documentsReturnedBy');
  @override
  late final GeneratedColumn<String> documentsReturnedBy =
      GeneratedColumn<String>(
        'documents_returned_by',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _signaturePathMeta = const VerificationMeta(
    'signaturePath',
  );
  @override
  late final GeneratedColumn<String> signaturePath = GeneratedColumn<String>(
    'signature_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureNameMeta = const VerificationMeta(
    'signatureName',
  );
  @override
  late final GeneratedColumn<String> signatureName = GeneratedColumn<String>(
    'signature_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureDateMeta = const VerificationMeta(
    'signatureDate',
  );
  @override
  late final GeneratedColumn<DateTime> signatureDate =
      GeneratedColumn<DateTime>(
        'signature_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    number,
    customerId,
    customerName,
    customerPhone,
    dateStart,
    dateEnd,
    state,
    discountType,
    discountValue,
    customerDiscountId,
    amountDeposit,
    amountPaid,
    lateFeeManual,
    lateDaysEdited,
    lateDaysOverride,
    sigRentalContract,
    sigPickupReturnReceipt,
    sigLoanContract,
    itemsCaptured,
    itemsExamined,
    itemsExaminedAt,
    itemsExaminedBy,
    documentsReturnedAt,
    documentsReturnedBy,
    signaturePath,
    signatureName,
    signatureDate,
    userId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('date_start')) {
      context.handle(
        _dateStartMeta,
        dateStart.isAcceptableOrUnknown(data['date_start']!, _dateStartMeta),
      );
    }
    if (data.containsKey('date_end')) {
      context.handle(
        _dateEndMeta,
        dateEnd.isAcceptableOrUnknown(data['date_end']!, _dateEndMeta),
      );
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('customer_discount_id')) {
      context.handle(
        _customerDiscountIdMeta,
        customerDiscountId.isAcceptableOrUnknown(
          data['customer_discount_id']!,
          _customerDiscountIdMeta,
        ),
      );
    }
    if (data.containsKey('amount_deposit')) {
      context.handle(
        _amountDepositMeta,
        amountDeposit.isAcceptableOrUnknown(
          data['amount_deposit']!,
          _amountDepositMeta,
        ),
      );
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
        _amountPaidMeta,
        amountPaid.isAcceptableOrUnknown(data['amount_paid']!, _amountPaidMeta),
      );
    }
    if (data.containsKey('late_fee_manual')) {
      context.handle(
        _lateFeeManualMeta,
        lateFeeManual.isAcceptableOrUnknown(
          data['late_fee_manual']!,
          _lateFeeManualMeta,
        ),
      );
    }
    if (data.containsKey('late_days_edited')) {
      context.handle(
        _lateDaysEditedMeta,
        lateDaysEdited.isAcceptableOrUnknown(
          data['late_days_edited']!,
          _lateDaysEditedMeta,
        ),
      );
    }
    if (data.containsKey('late_days_override')) {
      context.handle(
        _lateDaysOverrideMeta,
        lateDaysOverride.isAcceptableOrUnknown(
          data['late_days_override']!,
          _lateDaysOverrideMeta,
        ),
      );
    }
    if (data.containsKey('sig_rental_contract')) {
      context.handle(
        _sigRentalContractMeta,
        sigRentalContract.isAcceptableOrUnknown(
          data['sig_rental_contract']!,
          _sigRentalContractMeta,
        ),
      );
    }
    if (data.containsKey('sig_pickup_return_receipt')) {
      context.handle(
        _sigPickupReturnReceiptMeta,
        sigPickupReturnReceipt.isAcceptableOrUnknown(
          data['sig_pickup_return_receipt']!,
          _sigPickupReturnReceiptMeta,
        ),
      );
    }
    if (data.containsKey('sig_loan_contract')) {
      context.handle(
        _sigLoanContractMeta,
        sigLoanContract.isAcceptableOrUnknown(
          data['sig_loan_contract']!,
          _sigLoanContractMeta,
        ),
      );
    }
    if (data.containsKey('items_captured')) {
      context.handle(
        _itemsCapturedMeta,
        itemsCaptured.isAcceptableOrUnknown(
          data['items_captured']!,
          _itemsCapturedMeta,
        ),
      );
    }
    if (data.containsKey('items_examined')) {
      context.handle(
        _itemsExaminedMeta,
        itemsExamined.isAcceptableOrUnknown(
          data['items_examined']!,
          _itemsExaminedMeta,
        ),
      );
    }
    if (data.containsKey('items_examined_at')) {
      context.handle(
        _itemsExaminedAtMeta,
        itemsExaminedAt.isAcceptableOrUnknown(
          data['items_examined_at']!,
          _itemsExaminedAtMeta,
        ),
      );
    }
    if (data.containsKey('items_examined_by')) {
      context.handle(
        _itemsExaminedByMeta,
        itemsExaminedBy.isAcceptableOrUnknown(
          data['items_examined_by']!,
          _itemsExaminedByMeta,
        ),
      );
    }
    if (data.containsKey('documents_returned_at')) {
      context.handle(
        _documentsReturnedAtMeta,
        documentsReturnedAt.isAcceptableOrUnknown(
          data['documents_returned_at']!,
          _documentsReturnedAtMeta,
        ),
      );
    }
    if (data.containsKey('documents_returned_by')) {
      context.handle(
        _documentsReturnedByMeta,
        documentsReturnedBy.isAcceptableOrUnknown(
          data['documents_returned_by']!,
          _documentsReturnedByMeta,
        ),
      );
    }
    if (data.containsKey('signature_path')) {
      context.handle(
        _signaturePathMeta,
        signaturePath.isAcceptableOrUnknown(
          data['signature_path']!,
          _signaturePathMeta,
        ),
      );
    }
    if (data.containsKey('signature_name')) {
      context.handle(
        _signatureNameMeta,
        signatureName.isAcceptableOrUnknown(
          data['signature_name']!,
          _signatureNameMeta,
        ),
      );
    }
    if (data.containsKey('signature_date')) {
      context.handle(
        _signatureDateMeta,
        signatureDate.isAcceptableOrUnknown(
          data['signature_date']!,
          _signatureDateMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      dateStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_start'],
      ),
      dateEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_end'],
      ),
      state: $OrdersTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
      discountType: $OrdersTable.$converterdiscountType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discount_type'],
        )!,
      ),
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_value'],
      )!,
      customerDiscountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_discount_id'],
      ),
      amountDeposit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_deposit'],
      )!,
      amountPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_paid'],
      )!,
      lateFeeManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}late_fee_manual'],
      )!,
      lateDaysEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}late_days_edited'],
      )!,
      lateDaysOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}late_days_override'],
      )!,
      sigRentalContract: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sig_rental_contract'],
      )!,
      sigPickupReturnReceipt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sig_pickup_return_receipt'],
      )!,
      sigLoanContract: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sig_loan_contract'],
      )!,
      itemsCaptured: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}items_captured'],
      )!,
      itemsExamined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}items_examined'],
      )!,
      itemsExaminedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}items_examined_at'],
      ),
      itemsExaminedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_examined_by'],
      ),
      documentsReturnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}documents_returned_at'],
      ),
      documentsReturnedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}documents_returned_by'],
      ),
      signaturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_path'],
      ),
      signatureName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_name'],
      ),
      signatureDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signature_date'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static TypeConverter<OrderState, String> $converterstate = const KeyConverter(
    OrderState.values,
  );
  static TypeConverter<DiscountType, String> $converterdiscountType =
      const KeyConverter(DiscountType.values);
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;

  /// RO/2026/0001, given by the server at booking. Null while a draft.
  final String? number;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final OrderState state;
  final DiscountType discountType;
  final double discountValue;
  final String? customerDiscountId;
  final double amountDeposit;
  final double amountPaid;
  final bool lateFeeManual;
  final bool lateDaysEdited;
  final int lateDaysOverride;
  final bool sigRentalContract;
  final bool sigPickupReturnReceipt;
  final bool sigLoanContract;
  final bool itemsCaptured;
  final bool itemsExamined;
  final DateTime? itemsExaminedAt;
  final String? itemsExaminedBy;
  final DateTime? documentsReturnedAt;
  final String? documentsReturnedBy;
  final String? signaturePath;
  final String? signatureName;
  final DateTime? signatureDate;
  final String? userId;
  final String? note;
  const Order({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    this.number,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.dateStart,
    this.dateEnd,
    required this.state,
    required this.discountType,
    required this.discountValue,
    this.customerDiscountId,
    required this.amountDeposit,
    required this.amountPaid,
    required this.lateFeeManual,
    required this.lateDaysEdited,
    required this.lateDaysOverride,
    required this.sigRentalContract,
    required this.sigPickupReturnReceipt,
    required this.sigLoanContract,
    required this.itemsCaptured,
    required this.itemsExamined,
    this.itemsExaminedAt,
    this.itemsExaminedBy,
    this.documentsReturnedAt,
    this.documentsReturnedBy,
    this.signaturePath,
    this.signatureName,
    this.signatureDate,
    this.userId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || dateStart != null) {
      map['date_start'] = Variable<DateTime>(dateStart);
    }
    if (!nullToAbsent || dateEnd != null) {
      map['date_end'] = Variable<DateTime>(dateEnd);
    }
    {
      map['state'] = Variable<String>(
        $OrdersTable.$converterstate.toSql(state),
      );
    }
    {
      map['discount_type'] = Variable<String>(
        $OrdersTable.$converterdiscountType.toSql(discountType),
      );
    }
    map['discount_value'] = Variable<double>(discountValue);
    if (!nullToAbsent || customerDiscountId != null) {
      map['customer_discount_id'] = Variable<String>(customerDiscountId);
    }
    map['amount_deposit'] = Variable<double>(amountDeposit);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['late_fee_manual'] = Variable<bool>(lateFeeManual);
    map['late_days_edited'] = Variable<bool>(lateDaysEdited);
    map['late_days_override'] = Variable<int>(lateDaysOverride);
    map['sig_rental_contract'] = Variable<bool>(sigRentalContract);
    map['sig_pickup_return_receipt'] = Variable<bool>(sigPickupReturnReceipt);
    map['sig_loan_contract'] = Variable<bool>(sigLoanContract);
    map['items_captured'] = Variable<bool>(itemsCaptured);
    map['items_examined'] = Variable<bool>(itemsExamined);
    if (!nullToAbsent || itemsExaminedAt != null) {
      map['items_examined_at'] = Variable<DateTime>(itemsExaminedAt);
    }
    if (!nullToAbsent || itemsExaminedBy != null) {
      map['items_examined_by'] = Variable<String>(itemsExaminedBy);
    }
    if (!nullToAbsent || documentsReturnedAt != null) {
      map['documents_returned_at'] = Variable<DateTime>(documentsReturnedAt);
    }
    if (!nullToAbsent || documentsReturnedBy != null) {
      map['documents_returned_by'] = Variable<String>(documentsReturnedBy);
    }
    if (!nullToAbsent || signaturePath != null) {
      map['signature_path'] = Variable<String>(signaturePath);
    }
    if (!nullToAbsent || signatureName != null) {
      map['signature_name'] = Variable<String>(signatureName);
    }
    if (!nullToAbsent || signatureDate != null) {
      map['signature_date'] = Variable<DateTime>(signatureDate);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      number: number == null && nullToAbsent
          ? const Value.absent()
          : Value(number),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      dateStart: dateStart == null && nullToAbsent
          ? const Value.absent()
          : Value(dateStart),
      dateEnd: dateEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEnd),
      state: Value(state),
      discountType: Value(discountType),
      discountValue: Value(discountValue),
      customerDiscountId: customerDiscountId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerDiscountId),
      amountDeposit: Value(amountDeposit),
      amountPaid: Value(amountPaid),
      lateFeeManual: Value(lateFeeManual),
      lateDaysEdited: Value(lateDaysEdited),
      lateDaysOverride: Value(lateDaysOverride),
      sigRentalContract: Value(sigRentalContract),
      sigPickupReturnReceipt: Value(sigPickupReturnReceipt),
      sigLoanContract: Value(sigLoanContract),
      itemsCaptured: Value(itemsCaptured),
      itemsExamined: Value(itemsExamined),
      itemsExaminedAt: itemsExaminedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(itemsExaminedAt),
      itemsExaminedBy: itemsExaminedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(itemsExaminedBy),
      documentsReturnedAt: documentsReturnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(documentsReturnedAt),
      documentsReturnedBy: documentsReturnedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(documentsReturnedBy),
      signaturePath: signaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(signaturePath),
      signatureName: signatureName == null && nullToAbsent
          ? const Value.absent()
          : Value(signatureName),
      signatureDate: signatureDate == null && nullToAbsent
          ? const Value.absent()
          : Value(signatureDate),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      number: serializer.fromJson<String?>(json['number']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      dateStart: serializer.fromJson<DateTime?>(json['dateStart']),
      dateEnd: serializer.fromJson<DateTime?>(json['dateEnd']),
      state: serializer.fromJson<OrderState>(json['state']),
      discountType: serializer.fromJson<DiscountType>(json['discountType']),
      discountValue: serializer.fromJson<double>(json['discountValue']),
      customerDiscountId: serializer.fromJson<String?>(
        json['customerDiscountId'],
      ),
      amountDeposit: serializer.fromJson<double>(json['amountDeposit']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      lateFeeManual: serializer.fromJson<bool>(json['lateFeeManual']),
      lateDaysEdited: serializer.fromJson<bool>(json['lateDaysEdited']),
      lateDaysOverride: serializer.fromJson<int>(json['lateDaysOverride']),
      sigRentalContract: serializer.fromJson<bool>(json['sigRentalContract']),
      sigPickupReturnReceipt: serializer.fromJson<bool>(
        json['sigPickupReturnReceipt'],
      ),
      sigLoanContract: serializer.fromJson<bool>(json['sigLoanContract']),
      itemsCaptured: serializer.fromJson<bool>(json['itemsCaptured']),
      itemsExamined: serializer.fromJson<bool>(json['itemsExamined']),
      itemsExaminedAt: serializer.fromJson<DateTime?>(json['itemsExaminedAt']),
      itemsExaminedBy: serializer.fromJson<String?>(json['itemsExaminedBy']),
      documentsReturnedAt: serializer.fromJson<DateTime?>(
        json['documentsReturnedAt'],
      ),
      documentsReturnedBy: serializer.fromJson<String?>(
        json['documentsReturnedBy'],
      ),
      signaturePath: serializer.fromJson<String?>(json['signaturePath']),
      signatureName: serializer.fromJson<String?>(json['signatureName']),
      signatureDate: serializer.fromJson<DateTime?>(json['signatureDate']),
      userId: serializer.fromJson<String?>(json['userId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'number': serializer.toJson<String?>(number),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'dateStart': serializer.toJson<DateTime?>(dateStart),
      'dateEnd': serializer.toJson<DateTime?>(dateEnd),
      'state': serializer.toJson<OrderState>(state),
      'discountType': serializer.toJson<DiscountType>(discountType),
      'discountValue': serializer.toJson<double>(discountValue),
      'customerDiscountId': serializer.toJson<String?>(customerDiscountId),
      'amountDeposit': serializer.toJson<double>(amountDeposit),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'lateFeeManual': serializer.toJson<bool>(lateFeeManual),
      'lateDaysEdited': serializer.toJson<bool>(lateDaysEdited),
      'lateDaysOverride': serializer.toJson<int>(lateDaysOverride),
      'sigRentalContract': serializer.toJson<bool>(sigRentalContract),
      'sigPickupReturnReceipt': serializer.toJson<bool>(sigPickupReturnReceipt),
      'sigLoanContract': serializer.toJson<bool>(sigLoanContract),
      'itemsCaptured': serializer.toJson<bool>(itemsCaptured),
      'itemsExamined': serializer.toJson<bool>(itemsExamined),
      'itemsExaminedAt': serializer.toJson<DateTime?>(itemsExaminedAt),
      'itemsExaminedBy': serializer.toJson<String?>(itemsExaminedBy),
      'documentsReturnedAt': serializer.toJson<DateTime?>(documentsReturnedAt),
      'documentsReturnedBy': serializer.toJson<String?>(documentsReturnedBy),
      'signaturePath': serializer.toJson<String?>(signaturePath),
      'signatureName': serializer.toJson<String?>(signatureName),
      'signatureDate': serializer.toJson<DateTime?>(signatureDate),
      'userId': serializer.toJson<String?>(userId),
      'note': serializer.toJson<String?>(note),
    };
  }

  Order copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    Value<String?> number = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    Value<String?> customerPhone = const Value.absent(),
    Value<DateTime?> dateStart = const Value.absent(),
    Value<DateTime?> dateEnd = const Value.absent(),
    OrderState? state,
    DiscountType? discountType,
    double? discountValue,
    Value<String?> customerDiscountId = const Value.absent(),
    double? amountDeposit,
    double? amountPaid,
    bool? lateFeeManual,
    bool? lateDaysEdited,
    int? lateDaysOverride,
    bool? sigRentalContract,
    bool? sigPickupReturnReceipt,
    bool? sigLoanContract,
    bool? itemsCaptured,
    bool? itemsExamined,
    Value<DateTime?> itemsExaminedAt = const Value.absent(),
    Value<String?> itemsExaminedBy = const Value.absent(),
    Value<DateTime?> documentsReturnedAt = const Value.absent(),
    Value<String?> documentsReturnedBy = const Value.absent(),
    Value<String?> signaturePath = const Value.absent(),
    Value<String?> signatureName = const Value.absent(),
    Value<DateTime?> signatureDate = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    number: number.present ? number.value : this.number,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName.present ? customerName.value : this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    dateStart: dateStart.present ? dateStart.value : this.dateStart,
    dateEnd: dateEnd.present ? dateEnd.value : this.dateEnd,
    state: state ?? this.state,
    discountType: discountType ?? this.discountType,
    discountValue: discountValue ?? this.discountValue,
    customerDiscountId: customerDiscountId.present
        ? customerDiscountId.value
        : this.customerDiscountId,
    amountDeposit: amountDeposit ?? this.amountDeposit,
    amountPaid: amountPaid ?? this.amountPaid,
    lateFeeManual: lateFeeManual ?? this.lateFeeManual,
    lateDaysEdited: lateDaysEdited ?? this.lateDaysEdited,
    lateDaysOverride: lateDaysOverride ?? this.lateDaysOverride,
    sigRentalContract: sigRentalContract ?? this.sigRentalContract,
    sigPickupReturnReceipt:
        sigPickupReturnReceipt ?? this.sigPickupReturnReceipt,
    sigLoanContract: sigLoanContract ?? this.sigLoanContract,
    itemsCaptured: itemsCaptured ?? this.itemsCaptured,
    itemsExamined: itemsExamined ?? this.itemsExamined,
    itemsExaminedAt: itemsExaminedAt.present
        ? itemsExaminedAt.value
        : this.itemsExaminedAt,
    itemsExaminedBy: itemsExaminedBy.present
        ? itemsExaminedBy.value
        : this.itemsExaminedBy,
    documentsReturnedAt: documentsReturnedAt.present
        ? documentsReturnedAt.value
        : this.documentsReturnedAt,
    documentsReturnedBy: documentsReturnedBy.present
        ? documentsReturnedBy.value
        : this.documentsReturnedBy,
    signaturePath: signaturePath.present
        ? signaturePath.value
        : this.signaturePath,
    signatureName: signatureName.present
        ? signatureName.value
        : this.signatureName,
    signatureDate: signatureDate.present
        ? signatureDate.value
        : this.signatureDate,
    userId: userId.present ? userId.value : this.userId,
    note: note.present ? note.value : this.note,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      number: data.number.present ? data.number.value : this.number,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      dateStart: data.dateStart.present ? data.dateStart.value : this.dateStart,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      state: data.state.present ? data.state.value : this.state,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      customerDiscountId: data.customerDiscountId.present
          ? data.customerDiscountId.value
          : this.customerDiscountId,
      amountDeposit: data.amountDeposit.present
          ? data.amountDeposit.value
          : this.amountDeposit,
      amountPaid: data.amountPaid.present
          ? data.amountPaid.value
          : this.amountPaid,
      lateFeeManual: data.lateFeeManual.present
          ? data.lateFeeManual.value
          : this.lateFeeManual,
      lateDaysEdited: data.lateDaysEdited.present
          ? data.lateDaysEdited.value
          : this.lateDaysEdited,
      lateDaysOverride: data.lateDaysOverride.present
          ? data.lateDaysOverride.value
          : this.lateDaysOverride,
      sigRentalContract: data.sigRentalContract.present
          ? data.sigRentalContract.value
          : this.sigRentalContract,
      sigPickupReturnReceipt: data.sigPickupReturnReceipt.present
          ? data.sigPickupReturnReceipt.value
          : this.sigPickupReturnReceipt,
      sigLoanContract: data.sigLoanContract.present
          ? data.sigLoanContract.value
          : this.sigLoanContract,
      itemsCaptured: data.itemsCaptured.present
          ? data.itemsCaptured.value
          : this.itemsCaptured,
      itemsExamined: data.itemsExamined.present
          ? data.itemsExamined.value
          : this.itemsExamined,
      itemsExaminedAt: data.itemsExaminedAt.present
          ? data.itemsExaminedAt.value
          : this.itemsExaminedAt,
      itemsExaminedBy: data.itemsExaminedBy.present
          ? data.itemsExaminedBy.value
          : this.itemsExaminedBy,
      documentsReturnedAt: data.documentsReturnedAt.present
          ? data.documentsReturnedAt.value
          : this.documentsReturnedAt,
      documentsReturnedBy: data.documentsReturnedBy.present
          ? data.documentsReturnedBy.value
          : this.documentsReturnedBy,
      signaturePath: data.signaturePath.present
          ? data.signaturePath.value
          : this.signaturePath,
      signatureName: data.signatureName.present
          ? data.signatureName.value
          : this.signatureName,
      signatureDate: data.signatureDate.present
          ? data.signatureDate.value
          : this.signatureDate,
      userId: data.userId.present ? data.userId.value : this.userId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('state: $state, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('customerDiscountId: $customerDiscountId, ')
          ..write('amountDeposit: $amountDeposit, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('lateFeeManual: $lateFeeManual, ')
          ..write('lateDaysEdited: $lateDaysEdited, ')
          ..write('lateDaysOverride: $lateDaysOverride, ')
          ..write('sigRentalContract: $sigRentalContract, ')
          ..write('sigPickupReturnReceipt: $sigPickupReturnReceipt, ')
          ..write('sigLoanContract: $sigLoanContract, ')
          ..write('itemsCaptured: $itemsCaptured, ')
          ..write('itemsExamined: $itemsExamined, ')
          ..write('itemsExaminedAt: $itemsExaminedAt, ')
          ..write('itemsExaminedBy: $itemsExaminedBy, ')
          ..write('documentsReturnedAt: $documentsReturnedAt, ')
          ..write('documentsReturnedBy: $documentsReturnedBy, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('signatureName: $signatureName, ')
          ..write('signatureDate: $signatureDate, ')
          ..write('userId: $userId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    number,
    customerId,
    customerName,
    customerPhone,
    dateStart,
    dateEnd,
    state,
    discountType,
    discountValue,
    customerDiscountId,
    amountDeposit,
    amountPaid,
    lateFeeManual,
    lateDaysEdited,
    lateDaysOverride,
    sigRentalContract,
    sigPickupReturnReceipt,
    sigLoanContract,
    itemsCaptured,
    itemsExamined,
    itemsExaminedAt,
    itemsExaminedBy,
    documentsReturnedAt,
    documentsReturnedBy,
    signaturePath,
    signatureName,
    signatureDate,
    userId,
    note,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.number == this.number &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.dateStart == this.dateStart &&
          other.dateEnd == this.dateEnd &&
          other.state == this.state &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.customerDiscountId == this.customerDiscountId &&
          other.amountDeposit == this.amountDeposit &&
          other.amountPaid == this.amountPaid &&
          other.lateFeeManual == this.lateFeeManual &&
          other.lateDaysEdited == this.lateDaysEdited &&
          other.lateDaysOverride == this.lateDaysOverride &&
          other.sigRentalContract == this.sigRentalContract &&
          other.sigPickupReturnReceipt == this.sigPickupReturnReceipt &&
          other.sigLoanContract == this.sigLoanContract &&
          other.itemsCaptured == this.itemsCaptured &&
          other.itemsExamined == this.itemsExamined &&
          other.itemsExaminedAt == this.itemsExaminedAt &&
          other.itemsExaminedBy == this.itemsExaminedBy &&
          other.documentsReturnedAt == this.documentsReturnedAt &&
          other.documentsReturnedBy == this.documentsReturnedBy &&
          other.signaturePath == this.signaturePath &&
          other.signatureName == this.signatureName &&
          other.signatureDate == this.signatureDate &&
          other.userId == this.userId &&
          other.note == this.note);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String?> number;
  final Value<String?> customerId;
  final Value<String?> customerName;
  final Value<String?> customerPhone;
  final Value<DateTime?> dateStart;
  final Value<DateTime?> dateEnd;
  final Value<OrderState> state;
  final Value<DiscountType> discountType;
  final Value<double> discountValue;
  final Value<String?> customerDiscountId;
  final Value<double> amountDeposit;
  final Value<double> amountPaid;
  final Value<bool> lateFeeManual;
  final Value<bool> lateDaysEdited;
  final Value<int> lateDaysOverride;
  final Value<bool> sigRentalContract;
  final Value<bool> sigPickupReturnReceipt;
  final Value<bool> sigLoanContract;
  final Value<bool> itemsCaptured;
  final Value<bool> itemsExamined;
  final Value<DateTime?> itemsExaminedAt;
  final Value<String?> itemsExaminedBy;
  final Value<DateTime?> documentsReturnedAt;
  final Value<String?> documentsReturnedBy;
  final Value<String?> signaturePath;
  final Value<String?> signatureName;
  final Value<DateTime?> signatureDate;
  final Value<String?> userId;
  final Value<String?> note;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.number = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.state = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.customerDiscountId = const Value.absent(),
    this.amountDeposit = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.lateFeeManual = const Value.absent(),
    this.lateDaysEdited = const Value.absent(),
    this.lateDaysOverride = const Value.absent(),
    this.sigRentalContract = const Value.absent(),
    this.sigPickupReturnReceipt = const Value.absent(),
    this.sigLoanContract = const Value.absent(),
    this.itemsCaptured = const Value.absent(),
    this.itemsExamined = const Value.absent(),
    this.itemsExaminedAt = const Value.absent(),
    this.itemsExaminedBy = const Value.absent(),
    this.documentsReturnedAt = const Value.absent(),
    this.documentsReturnedBy = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.signatureName = const Value.absent(),
    this.signatureDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.number = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.state = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.customerDiscountId = const Value.absent(),
    this.amountDeposit = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.lateFeeManual = const Value.absent(),
    this.lateDaysEdited = const Value.absent(),
    this.lateDaysOverride = const Value.absent(),
    this.sigRentalContract = const Value.absent(),
    this.sigPickupReturnReceipt = const Value.absent(),
    this.sigLoanContract = const Value.absent(),
    this.itemsCaptured = const Value.absent(),
    this.itemsExamined = const Value.absent(),
    this.itemsExaminedAt = const Value.absent(),
    this.itemsExaminedBy = const Value.absent(),
    this.documentsReturnedAt = const Value.absent(),
    this.documentsReturnedBy = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.signatureName = const Value.absent(),
    this.signatureDate = const Value.absent(),
    this.userId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? number,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<DateTime>? dateStart,
    Expression<DateTime>? dateEnd,
    Expression<String>? state,
    Expression<String>? discountType,
    Expression<double>? discountValue,
    Expression<String>? customerDiscountId,
    Expression<double>? amountDeposit,
    Expression<double>? amountPaid,
    Expression<bool>? lateFeeManual,
    Expression<bool>? lateDaysEdited,
    Expression<int>? lateDaysOverride,
    Expression<bool>? sigRentalContract,
    Expression<bool>? sigPickupReturnReceipt,
    Expression<bool>? sigLoanContract,
    Expression<bool>? itemsCaptured,
    Expression<bool>? itemsExamined,
    Expression<DateTime>? itemsExaminedAt,
    Expression<String>? itemsExaminedBy,
    Expression<DateTime>? documentsReturnedAt,
    Expression<String>? documentsReturnedBy,
    Expression<String>? signaturePath,
    Expression<String>? signatureName,
    Expression<DateTime>? signatureDate,
    Expression<String>? userId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (number != null) 'number': number,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (dateStart != null) 'date_start': dateStart,
      if (dateEnd != null) 'date_end': dateEnd,
      if (state != null) 'state': state,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (customerDiscountId != null)
        'customer_discount_id': customerDiscountId,
      if (amountDeposit != null) 'amount_deposit': amountDeposit,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (lateFeeManual != null) 'late_fee_manual': lateFeeManual,
      if (lateDaysEdited != null) 'late_days_edited': lateDaysEdited,
      if (lateDaysOverride != null) 'late_days_override': lateDaysOverride,
      if (sigRentalContract != null) 'sig_rental_contract': sigRentalContract,
      if (sigPickupReturnReceipt != null)
        'sig_pickup_return_receipt': sigPickupReturnReceipt,
      if (sigLoanContract != null) 'sig_loan_contract': sigLoanContract,
      if (itemsCaptured != null) 'items_captured': itemsCaptured,
      if (itemsExamined != null) 'items_examined': itemsExamined,
      if (itemsExaminedAt != null) 'items_examined_at': itemsExaminedAt,
      if (itemsExaminedBy != null) 'items_examined_by': itemsExaminedBy,
      if (documentsReturnedAt != null)
        'documents_returned_at': documentsReturnedAt,
      if (documentsReturnedBy != null)
        'documents_returned_by': documentsReturnedBy,
      if (signaturePath != null) 'signature_path': signaturePath,
      if (signatureName != null) 'signature_name': signatureName,
      if (signatureDate != null) 'signature_date': signatureDate,
      if (userId != null) 'user_id': userId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String?>? number,
    Value<String?>? customerId,
    Value<String?>? customerName,
    Value<String?>? customerPhone,
    Value<DateTime?>? dateStart,
    Value<DateTime?>? dateEnd,
    Value<OrderState>? state,
    Value<DiscountType>? discountType,
    Value<double>? discountValue,
    Value<String?>? customerDiscountId,
    Value<double>? amountDeposit,
    Value<double>? amountPaid,
    Value<bool>? lateFeeManual,
    Value<bool>? lateDaysEdited,
    Value<int>? lateDaysOverride,
    Value<bool>? sigRentalContract,
    Value<bool>? sigPickupReturnReceipt,
    Value<bool>? sigLoanContract,
    Value<bool>? itemsCaptured,
    Value<bool>? itemsExamined,
    Value<DateTime?>? itemsExaminedAt,
    Value<String?>? itemsExaminedBy,
    Value<DateTime?>? documentsReturnedAt,
    Value<String?>? documentsReturnedBy,
    Value<String?>? signaturePath,
    Value<String?>? signatureName,
    Value<DateTime?>? signatureDate,
    Value<String?>? userId,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      number: number ?? this.number,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      state: state ?? this.state,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      customerDiscountId: customerDiscountId ?? this.customerDiscountId,
      amountDeposit: amountDeposit ?? this.amountDeposit,
      amountPaid: amountPaid ?? this.amountPaid,
      lateFeeManual: lateFeeManual ?? this.lateFeeManual,
      lateDaysEdited: lateDaysEdited ?? this.lateDaysEdited,
      lateDaysOverride: lateDaysOverride ?? this.lateDaysOverride,
      sigRentalContract: sigRentalContract ?? this.sigRentalContract,
      sigPickupReturnReceipt:
          sigPickupReturnReceipt ?? this.sigPickupReturnReceipt,
      sigLoanContract: sigLoanContract ?? this.sigLoanContract,
      itemsCaptured: itemsCaptured ?? this.itemsCaptured,
      itemsExamined: itemsExamined ?? this.itemsExamined,
      itemsExaminedAt: itemsExaminedAt ?? this.itemsExaminedAt,
      itemsExaminedBy: itemsExaminedBy ?? this.itemsExaminedBy,
      documentsReturnedAt: documentsReturnedAt ?? this.documentsReturnedAt,
      documentsReturnedBy: documentsReturnedBy ?? this.documentsReturnedBy,
      signaturePath: signaturePath ?? this.signaturePath,
      signatureName: signatureName ?? this.signatureName,
      signatureDate: signatureDate ?? this.signatureDate,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (dateStart.present) {
      map['date_start'] = Variable<DateTime>(dateStart.value);
    }
    if (dateEnd.present) {
      map['date_end'] = Variable<DateTime>(dateEnd.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $OrdersTable.$converterstate.toSql(state.value),
      );
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(
        $OrdersTable.$converterdiscountType.toSql(discountType.value),
      );
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<double>(discountValue.value);
    }
    if (customerDiscountId.present) {
      map['customer_discount_id'] = Variable<String>(customerDiscountId.value);
    }
    if (amountDeposit.present) {
      map['amount_deposit'] = Variable<double>(amountDeposit.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (lateFeeManual.present) {
      map['late_fee_manual'] = Variable<bool>(lateFeeManual.value);
    }
    if (lateDaysEdited.present) {
      map['late_days_edited'] = Variable<bool>(lateDaysEdited.value);
    }
    if (lateDaysOverride.present) {
      map['late_days_override'] = Variable<int>(lateDaysOverride.value);
    }
    if (sigRentalContract.present) {
      map['sig_rental_contract'] = Variable<bool>(sigRentalContract.value);
    }
    if (sigPickupReturnReceipt.present) {
      map['sig_pickup_return_receipt'] = Variable<bool>(
        sigPickupReturnReceipt.value,
      );
    }
    if (sigLoanContract.present) {
      map['sig_loan_contract'] = Variable<bool>(sigLoanContract.value);
    }
    if (itemsCaptured.present) {
      map['items_captured'] = Variable<bool>(itemsCaptured.value);
    }
    if (itemsExamined.present) {
      map['items_examined'] = Variable<bool>(itemsExamined.value);
    }
    if (itemsExaminedAt.present) {
      map['items_examined_at'] = Variable<DateTime>(itemsExaminedAt.value);
    }
    if (itemsExaminedBy.present) {
      map['items_examined_by'] = Variable<String>(itemsExaminedBy.value);
    }
    if (documentsReturnedAt.present) {
      map['documents_returned_at'] = Variable<DateTime>(
        documentsReturnedAt.value,
      );
    }
    if (documentsReturnedBy.present) {
      map['documents_returned_by'] = Variable<String>(
        documentsReturnedBy.value,
      );
    }
    if (signaturePath.present) {
      map['signature_path'] = Variable<String>(signaturePath.value);
    }
    if (signatureName.present) {
      map['signature_name'] = Variable<String>(signatureName.value);
    }
    if (signatureDate.present) {
      map['signature_date'] = Variable<DateTime>(signatureDate.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('number: $number, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('state: $state, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('customerDiscountId: $customerDiscountId, ')
          ..write('amountDeposit: $amountDeposit, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('lateFeeManual: $lateFeeManual, ')
          ..write('lateDaysEdited: $lateDaysEdited, ')
          ..write('lateDaysOverride: $lateDaysOverride, ')
          ..write('sigRentalContract: $sigRentalContract, ')
          ..write('sigPickupReturnReceipt: $sigPickupReturnReceipt, ')
          ..write('sigLoanContract: $sigLoanContract, ')
          ..write('itemsCaptured: $itemsCaptured, ')
          ..write('itemsExamined: $itemsExamined, ')
          ..write('itemsExaminedAt: $itemsExaminedAt, ')
          ..write('itemsExaminedBy: $itemsExaminedBy, ')
          ..write('documentsReturnedAt: $documentsReturnedAt, ')
          ..write('documentsReturnedBy: $documentsReturnedBy, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('signatureName: $signatureName, ')
          ..write('signatureDate: $signatureDate, ')
          ..write('userId: $userId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderDocumentsTable extends OrderDocuments
    with TableInfo<$OrderDocumentsTable, OrderDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _documentTypeIdMeta = const VerificationMeta(
    'documentTypeId',
  );
  @override
  late final GeneratedColumn<String> documentTypeId = GeneratedColumn<String>(
    'document_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES document_types (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    orderId,
    documentTypeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('document_type_id')) {
      context.handle(
        _documentTypeIdMeta,
        documentTypeId.isAcceptableOrUnknown(
          data['document_type_id']!,
          _documentTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentTypeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      documentTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_type_id'],
      )!,
    );
  }

  @override
  $OrderDocumentsTable createAlias(String alias) {
    return $OrderDocumentsTable(attachedDatabase, alias);
  }
}

class OrderDocument extends DataClass implements Insertable<OrderDocument> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String orderId;
  final String documentTypeId;
  const OrderDocument({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.orderId,
    required this.documentTypeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['order_id'] = Variable<String>(orderId);
    map['document_type_id'] = Variable<String>(documentTypeId);
    return map;
  }

  OrderDocumentsCompanion toCompanion(bool nullToAbsent) {
    return OrderDocumentsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      orderId: Value(orderId),
      documentTypeId: Value(documentTypeId),
    );
  }

  factory OrderDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderDocument(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      documentTypeId: serializer.fromJson<String>(json['documentTypeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'orderId': serializer.toJson<String>(orderId),
      'documentTypeId': serializer.toJson<String>(documentTypeId),
    };
  }

  OrderDocument copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? orderId,
    String? documentTypeId,
  }) => OrderDocument(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    orderId: orderId ?? this.orderId,
    documentTypeId: documentTypeId ?? this.documentTypeId,
  );
  OrderDocument copyWithCompanion(OrderDocumentsCompanion data) {
    return OrderDocument(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      documentTypeId: data.documentTypeId.present
          ? data.documentTypeId.value
          : this.documentTypeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderDocument(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('orderId: $orderId, ')
          ..write('documentTypeId: $documentTypeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    orderId,
    documentTypeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderDocument &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.orderId == this.orderId &&
          other.documentTypeId == this.documentTypeId);
}

class OrderDocumentsCompanion extends UpdateCompanion<OrderDocument> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> orderId;
  final Value<String> documentTypeId;
  final Value<int> rowid;
  const OrderDocumentsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.documentTypeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderDocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String orderId,
    required String documentTypeId,
    this.rowid = const Value.absent(),
  }) : orderId = Value(orderId),
       documentTypeId = Value(documentTypeId);
  static Insertable<OrderDocument> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? orderId,
    Expression<String>? documentTypeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (orderId != null) 'order_id': orderId,
      if (documentTypeId != null) 'document_type_id': documentTypeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderDocumentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? orderId,
    Value<String>? documentTypeId,
    Value<int>? rowid,
  }) {
    return OrderDocumentsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      orderId: orderId ?? this.orderId,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (documentTypeId.present) {
      map['document_type_id'] = Variable<String>(documentTypeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('orderId: $orderId, ')
          ..write('documentTypeId: $documentTypeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderLinesTable extends OrderLines
    with TableInfo<$OrderLinesTable, OrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LineType, String> lineType =
      GeneratedColumn<String>(
        'line_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('asset'),
      ).withConverter<LineType>($OrderLinesTable.$converterlineType);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES assets (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _priceDayMeta = const VerificationMeta(
    'priceDay',
  );
  @override
  late final GeneratedColumn<double> priceDay = GeneratedColumn<double>(
    'price_day',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateStartMeta = const VerificationMeta(
    'dateStart',
  );
  @override
  late final GeneratedColumn<DateTime> dateStart = GeneratedColumn<DateTime>(
    'date_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateEndMeta = const VerificationMeta(
    'dateEnd',
  );
  @override
  late final GeneratedColumn<DateTime> dateEnd = GeneratedColumn<DateTime>(
    'date_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RentalState, String> rentalState =
      GeneratedColumn<String>(
        'rental_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('none'),
      ).withConverter<RentalState>($OrderLinesTable.$converterrentalState);
  static const VerificationMeta _pickedUpAtMeta = const VerificationMeta(
    'pickedUpAt',
  );
  @override
  late final GeneratedColumn<DateTime> pickedUpAt = GeneratedColumn<DateTime>(
    'picked_up_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pickedUpByMeta = const VerificationMeta(
    'pickedUpBy',
  );
  @override
  late final GeneratedColumn<String> pickedUpBy = GeneratedColumn<String>(
    'picked_up_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedByMeta = const VerificationMeta(
    'returnedBy',
  );
  @override
  late final GeneratedColumn<String> returnedBy = GeneratedColumn<String>(
    'returned_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Condition, String> conditionOut =
      GeneratedColumn<String>(
        'condition_out',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('good'),
      ).withConverter<Condition>($OrderLinesTable.$converterconditionOut);
  @override
  late final GeneratedColumnWithTypeConverter<Condition?, String> conditionIn =
      GeneratedColumn<String>(
        'condition_in',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Condition?>($OrderLinesTable.$converterconditionInn);
  static const VerificationMeta _conditionNoteMeta = const VerificationMeta(
    'conditionNote',
  );
  @override
  late final GeneratedColumn<String> conditionNote = GeneratedColumn<String>(
    'condition_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    orderId,
    sequence,
    lineType,
    assetId,
    name,
    quantity,
    priceDay,
    discount,
    dateStart,
    dateEnd,
    rentalState,
    pickedUpAt,
    pickedUpBy,
    returnedAt,
    returnedBy,
    conditionOut,
    conditionIn,
    conditionNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('price_day')) {
      context.handle(
        _priceDayMeta,
        priceDay.isAcceptableOrUnknown(data['price_day']!, _priceDayMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('date_start')) {
      context.handle(
        _dateStartMeta,
        dateStart.isAcceptableOrUnknown(data['date_start']!, _dateStartMeta),
      );
    }
    if (data.containsKey('date_end')) {
      context.handle(
        _dateEndMeta,
        dateEnd.isAcceptableOrUnknown(data['date_end']!, _dateEndMeta),
      );
    }
    if (data.containsKey('picked_up_at')) {
      context.handle(
        _pickedUpAtMeta,
        pickedUpAt.isAcceptableOrUnknown(
          data['picked_up_at']!,
          _pickedUpAtMeta,
        ),
      );
    }
    if (data.containsKey('picked_up_by')) {
      context.handle(
        _pickedUpByMeta,
        pickedUpBy.isAcceptableOrUnknown(
          data['picked_up_by']!,
          _pickedUpByMeta,
        ),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('returned_by')) {
      context.handle(
        _returnedByMeta,
        returnedBy.isAcceptableOrUnknown(data['returned_by']!, _returnedByMeta),
      );
    }
    if (data.containsKey('condition_note')) {
      context.handle(
        _conditionNoteMeta,
        conditionNote.isAcceptableOrUnknown(
          data['condition_note']!,
          _conditionNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      lineType: $OrderLinesTable.$converterlineType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}line_type'],
        )!,
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      priceDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_day'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      dateStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_start'],
      ),
      dateEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_end'],
      ),
      rentalState: $OrderLinesTable.$converterrentalState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rental_state'],
        )!,
      ),
      pickedUpAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}picked_up_at'],
      ),
      pickedUpBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picked_up_by'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      returnedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}returned_by'],
      ),
      conditionOut: $OrderLinesTable.$converterconditionOut.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condition_out'],
        )!,
      ),
      conditionIn: $OrderLinesTable.$converterconditionInn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condition_in'],
        ),
      ),
      conditionNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_note'],
      ),
    );
  }

  @override
  $OrderLinesTable createAlias(String alias) {
    return $OrderLinesTable(attachedDatabase, alias);
  }

  static TypeConverter<LineType, String> $converterlineType =
      const KeyConverter(LineType.values);
  static TypeConverter<RentalState, String> $converterrentalState =
      const KeyConverter(RentalState.values);
  static TypeConverter<Condition, String> $converterconditionOut =
      const KeyConverter(Condition.values);
  static TypeConverter<Condition, String> $converterconditionIn =
      const KeyConverter(Condition.values);
  static TypeConverter<Condition?, String?> $converterconditionInn =
      NullAwareTypeConverter.wrap($converterconditionIn);
}

class OrderLine extends DataClass implements Insertable<OrderLine> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String orderId;
  final int sequence;
  final LineType lineType;
  final String? assetId;
  final String name;
  final double quantity;
  final double priceDay;

  /// Line discount in percent.
  final double discount;

  /// Null means "the order's dates".
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final RentalState rentalState;
  final DateTime? pickedUpAt;
  final String? pickedUpBy;
  final DateTime? returnedAt;
  final String? returnedBy;
  final Condition conditionOut;
  final Condition? conditionIn;
  final String? conditionNote;
  const OrderLine({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.orderId,
    required this.sequence,
    required this.lineType,
    this.assetId,
    required this.name,
    required this.quantity,
    required this.priceDay,
    required this.discount,
    this.dateStart,
    this.dateEnd,
    required this.rentalState,
    this.pickedUpAt,
    this.pickedUpBy,
    this.returnedAt,
    this.returnedBy,
    required this.conditionOut,
    this.conditionIn,
    this.conditionNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['order_id'] = Variable<String>(orderId);
    map['sequence'] = Variable<int>(sequence);
    {
      map['line_type'] = Variable<String>(
        $OrderLinesTable.$converterlineType.toSql(lineType),
      );
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['price_day'] = Variable<double>(priceDay);
    map['discount'] = Variable<double>(discount);
    if (!nullToAbsent || dateStart != null) {
      map['date_start'] = Variable<DateTime>(dateStart);
    }
    if (!nullToAbsent || dateEnd != null) {
      map['date_end'] = Variable<DateTime>(dateEnd);
    }
    {
      map['rental_state'] = Variable<String>(
        $OrderLinesTable.$converterrentalState.toSql(rentalState),
      );
    }
    if (!nullToAbsent || pickedUpAt != null) {
      map['picked_up_at'] = Variable<DateTime>(pickedUpAt);
    }
    if (!nullToAbsent || pickedUpBy != null) {
      map['picked_up_by'] = Variable<String>(pickedUpBy);
    }
    if (!nullToAbsent || returnedAt != null) {
      map['returned_at'] = Variable<DateTime>(returnedAt);
    }
    if (!nullToAbsent || returnedBy != null) {
      map['returned_by'] = Variable<String>(returnedBy);
    }
    {
      map['condition_out'] = Variable<String>(
        $OrderLinesTable.$converterconditionOut.toSql(conditionOut),
      );
    }
    if (!nullToAbsent || conditionIn != null) {
      map['condition_in'] = Variable<String>(
        $OrderLinesTable.$converterconditionInn.toSql(conditionIn),
      );
    }
    if (!nullToAbsent || conditionNote != null) {
      map['condition_note'] = Variable<String>(conditionNote);
    }
    return map;
  }

  OrderLinesCompanion toCompanion(bool nullToAbsent) {
    return OrderLinesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      orderId: Value(orderId),
      sequence: Value(sequence),
      lineType: Value(lineType),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      name: Value(name),
      quantity: Value(quantity),
      priceDay: Value(priceDay),
      discount: Value(discount),
      dateStart: dateStart == null && nullToAbsent
          ? const Value.absent()
          : Value(dateStart),
      dateEnd: dateEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEnd),
      rentalState: Value(rentalState),
      pickedUpAt: pickedUpAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pickedUpAt),
      pickedUpBy: pickedUpBy == null && nullToAbsent
          ? const Value.absent()
          : Value(pickedUpBy),
      returnedAt: returnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedAt),
      returnedBy: returnedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedBy),
      conditionOut: Value(conditionOut),
      conditionIn: conditionIn == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionIn),
      conditionNote: conditionNote == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionNote),
    );
  }

  factory OrderLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLine(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      lineType: serializer.fromJson<LineType>(json['lineType']),
      assetId: serializer.fromJson<String?>(json['assetId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      priceDay: serializer.fromJson<double>(json['priceDay']),
      discount: serializer.fromJson<double>(json['discount']),
      dateStart: serializer.fromJson<DateTime?>(json['dateStart']),
      dateEnd: serializer.fromJson<DateTime?>(json['dateEnd']),
      rentalState: serializer.fromJson<RentalState>(json['rentalState']),
      pickedUpAt: serializer.fromJson<DateTime?>(json['pickedUpAt']),
      pickedUpBy: serializer.fromJson<String?>(json['pickedUpBy']),
      returnedAt: serializer.fromJson<DateTime?>(json['returnedAt']),
      returnedBy: serializer.fromJson<String?>(json['returnedBy']),
      conditionOut: serializer.fromJson<Condition>(json['conditionOut']),
      conditionIn: serializer.fromJson<Condition?>(json['conditionIn']),
      conditionNote: serializer.fromJson<String?>(json['conditionNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'orderId': serializer.toJson<String>(orderId),
      'sequence': serializer.toJson<int>(sequence),
      'lineType': serializer.toJson<LineType>(lineType),
      'assetId': serializer.toJson<String?>(assetId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'priceDay': serializer.toJson<double>(priceDay),
      'discount': serializer.toJson<double>(discount),
      'dateStart': serializer.toJson<DateTime?>(dateStart),
      'dateEnd': serializer.toJson<DateTime?>(dateEnd),
      'rentalState': serializer.toJson<RentalState>(rentalState),
      'pickedUpAt': serializer.toJson<DateTime?>(pickedUpAt),
      'pickedUpBy': serializer.toJson<String?>(pickedUpBy),
      'returnedAt': serializer.toJson<DateTime?>(returnedAt),
      'returnedBy': serializer.toJson<String?>(returnedBy),
      'conditionOut': serializer.toJson<Condition>(conditionOut),
      'conditionIn': serializer.toJson<Condition?>(conditionIn),
      'conditionNote': serializer.toJson<String?>(conditionNote),
    };
  }

  OrderLine copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? orderId,
    int? sequence,
    LineType? lineType,
    Value<String?> assetId = const Value.absent(),
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
    Value<DateTime?> dateStart = const Value.absent(),
    Value<DateTime?> dateEnd = const Value.absent(),
    RentalState? rentalState,
    Value<DateTime?> pickedUpAt = const Value.absent(),
    Value<String?> pickedUpBy = const Value.absent(),
    Value<DateTime?> returnedAt = const Value.absent(),
    Value<String?> returnedBy = const Value.absent(),
    Condition? conditionOut,
    Value<Condition?> conditionIn = const Value.absent(),
    Value<String?> conditionNote = const Value.absent(),
  }) => OrderLine(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    orderId: orderId ?? this.orderId,
    sequence: sequence ?? this.sequence,
    lineType: lineType ?? this.lineType,
    assetId: assetId.present ? assetId.value : this.assetId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    priceDay: priceDay ?? this.priceDay,
    discount: discount ?? this.discount,
    dateStart: dateStart.present ? dateStart.value : this.dateStart,
    dateEnd: dateEnd.present ? dateEnd.value : this.dateEnd,
    rentalState: rentalState ?? this.rentalState,
    pickedUpAt: pickedUpAt.present ? pickedUpAt.value : this.pickedUpAt,
    pickedUpBy: pickedUpBy.present ? pickedUpBy.value : this.pickedUpBy,
    returnedAt: returnedAt.present ? returnedAt.value : this.returnedAt,
    returnedBy: returnedBy.present ? returnedBy.value : this.returnedBy,
    conditionOut: conditionOut ?? this.conditionOut,
    conditionIn: conditionIn.present ? conditionIn.value : this.conditionIn,
    conditionNote: conditionNote.present
        ? conditionNote.value
        : this.conditionNote,
  );
  OrderLine copyWithCompanion(OrderLinesCompanion data) {
    return OrderLine(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      lineType: data.lineType.present ? data.lineType.value : this.lineType,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceDay: data.priceDay.present ? data.priceDay.value : this.priceDay,
      discount: data.discount.present ? data.discount.value : this.discount,
      dateStart: data.dateStart.present ? data.dateStart.value : this.dateStart,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      rentalState: data.rentalState.present
          ? data.rentalState.value
          : this.rentalState,
      pickedUpAt: data.pickedUpAt.present
          ? data.pickedUpAt.value
          : this.pickedUpAt,
      pickedUpBy: data.pickedUpBy.present
          ? data.pickedUpBy.value
          : this.pickedUpBy,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      returnedBy: data.returnedBy.present
          ? data.returnedBy.value
          : this.returnedBy,
      conditionOut: data.conditionOut.present
          ? data.conditionOut.value
          : this.conditionOut,
      conditionIn: data.conditionIn.present
          ? data.conditionIn.value
          : this.conditionIn,
      conditionNote: data.conditionNote.present
          ? data.conditionNote.value
          : this.conditionNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderLine(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('orderId: $orderId, ')
          ..write('sequence: $sequence, ')
          ..write('lineType: $lineType, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('priceDay: $priceDay, ')
          ..write('discount: $discount, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('rentalState: $rentalState, ')
          ..write('pickedUpAt: $pickedUpAt, ')
          ..write('pickedUpBy: $pickedUpBy, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('returnedBy: $returnedBy, ')
          ..write('conditionOut: $conditionOut, ')
          ..write('conditionIn: $conditionIn, ')
          ..write('conditionNote: $conditionNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    orderId,
    sequence,
    lineType,
    assetId,
    name,
    quantity,
    priceDay,
    discount,
    dateStart,
    dateEnd,
    rentalState,
    pickedUpAt,
    pickedUpBy,
    returnedAt,
    returnedBy,
    conditionOut,
    conditionIn,
    conditionNote,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLine &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.orderId == this.orderId &&
          other.sequence == this.sequence &&
          other.lineType == this.lineType &&
          other.assetId == this.assetId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.priceDay == this.priceDay &&
          other.discount == this.discount &&
          other.dateStart == this.dateStart &&
          other.dateEnd == this.dateEnd &&
          other.rentalState == this.rentalState &&
          other.pickedUpAt == this.pickedUpAt &&
          other.pickedUpBy == this.pickedUpBy &&
          other.returnedAt == this.returnedAt &&
          other.returnedBy == this.returnedBy &&
          other.conditionOut == this.conditionOut &&
          other.conditionIn == this.conditionIn &&
          other.conditionNote == this.conditionNote);
}

class OrderLinesCompanion extends UpdateCompanion<OrderLine> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> orderId;
  final Value<int> sequence;
  final Value<LineType> lineType;
  final Value<String?> assetId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<double> priceDay;
  final Value<double> discount;
  final Value<DateTime?> dateStart;
  final Value<DateTime?> dateEnd;
  final Value<RentalState> rentalState;
  final Value<DateTime?> pickedUpAt;
  final Value<String?> pickedUpBy;
  final Value<DateTime?> returnedAt;
  final Value<String?> returnedBy;
  final Value<Condition> conditionOut;
  final Value<Condition?> conditionIn;
  final Value<String?> conditionNote;
  final Value<int> rowid;
  const OrderLinesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.lineType = const Value.absent(),
    this.assetId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceDay = const Value.absent(),
    this.discount = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.rentalState = const Value.absent(),
    this.pickedUpAt = const Value.absent(),
    this.pickedUpBy = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.returnedBy = const Value.absent(),
    this.conditionOut = const Value.absent(),
    this.conditionIn = const Value.absent(),
    this.conditionNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderLinesCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String orderId,
    this.sequence = const Value.absent(),
    this.lineType = const Value.absent(),
    this.assetId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceDay = const Value.absent(),
    this.discount = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.rentalState = const Value.absent(),
    this.pickedUpAt = const Value.absent(),
    this.pickedUpBy = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.returnedBy = const Value.absent(),
    this.conditionOut = const Value.absent(),
    this.conditionIn = const Value.absent(),
    this.conditionNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : orderId = Value(orderId);
  static Insertable<OrderLine> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? orderId,
    Expression<int>? sequence,
    Expression<String>? lineType,
    Expression<String>? assetId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<double>? priceDay,
    Expression<double>? discount,
    Expression<DateTime>? dateStart,
    Expression<DateTime>? dateEnd,
    Expression<String>? rentalState,
    Expression<DateTime>? pickedUpAt,
    Expression<String>? pickedUpBy,
    Expression<DateTime>? returnedAt,
    Expression<String>? returnedBy,
    Expression<String>? conditionOut,
    Expression<String>? conditionIn,
    Expression<String>? conditionNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (orderId != null) 'order_id': orderId,
      if (sequence != null) 'sequence': sequence,
      if (lineType != null) 'line_type': lineType,
      if (assetId != null) 'asset_id': assetId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (priceDay != null) 'price_day': priceDay,
      if (discount != null) 'discount': discount,
      if (dateStart != null) 'date_start': dateStart,
      if (dateEnd != null) 'date_end': dateEnd,
      if (rentalState != null) 'rental_state': rentalState,
      if (pickedUpAt != null) 'picked_up_at': pickedUpAt,
      if (pickedUpBy != null) 'picked_up_by': pickedUpBy,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (returnedBy != null) 'returned_by': returnedBy,
      if (conditionOut != null) 'condition_out': conditionOut,
      if (conditionIn != null) 'condition_in': conditionIn,
      if (conditionNote != null) 'condition_note': conditionNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderLinesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? orderId,
    Value<int>? sequence,
    Value<LineType>? lineType,
    Value<String?>? assetId,
    Value<String>? name,
    Value<double>? quantity,
    Value<double>? priceDay,
    Value<double>? discount,
    Value<DateTime?>? dateStart,
    Value<DateTime?>? dateEnd,
    Value<RentalState>? rentalState,
    Value<DateTime?>? pickedUpAt,
    Value<String?>? pickedUpBy,
    Value<DateTime?>? returnedAt,
    Value<String?>? returnedBy,
    Value<Condition>? conditionOut,
    Value<Condition?>? conditionIn,
    Value<String?>? conditionNote,
    Value<int>? rowid,
  }) {
    return OrderLinesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      orderId: orderId ?? this.orderId,
      sequence: sequence ?? this.sequence,
      lineType: lineType ?? this.lineType,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      priceDay: priceDay ?? this.priceDay,
      discount: discount ?? this.discount,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      rentalState: rentalState ?? this.rentalState,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      pickedUpBy: pickedUpBy ?? this.pickedUpBy,
      returnedAt: returnedAt ?? this.returnedAt,
      returnedBy: returnedBy ?? this.returnedBy,
      conditionOut: conditionOut ?? this.conditionOut,
      conditionIn: conditionIn ?? this.conditionIn,
      conditionNote: conditionNote ?? this.conditionNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (lineType.present) {
      map['line_type'] = Variable<String>(
        $OrderLinesTable.$converterlineType.toSql(lineType.value),
      );
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceDay.present) {
      map['price_day'] = Variable<double>(priceDay.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (dateStart.present) {
      map['date_start'] = Variable<DateTime>(dateStart.value);
    }
    if (dateEnd.present) {
      map['date_end'] = Variable<DateTime>(dateEnd.value);
    }
    if (rentalState.present) {
      map['rental_state'] = Variable<String>(
        $OrderLinesTable.$converterrentalState.toSql(rentalState.value),
      );
    }
    if (pickedUpAt.present) {
      map['picked_up_at'] = Variable<DateTime>(pickedUpAt.value);
    }
    if (pickedUpBy.present) {
      map['picked_up_by'] = Variable<String>(pickedUpBy.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (returnedBy.present) {
      map['returned_by'] = Variable<String>(returnedBy.value);
    }
    if (conditionOut.present) {
      map['condition_out'] = Variable<String>(
        $OrderLinesTable.$converterconditionOut.toSql(conditionOut.value),
      );
    }
    if (conditionIn.present) {
      map['condition_in'] = Variable<String>(
        $OrderLinesTable.$converterconditionInn.toSql(conditionIn.value),
      );
    }
    if (conditionNote.present) {
      map['condition_note'] = Variable<String>(conditionNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLinesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('orderId: $orderId, ')
          ..write('sequence: $sequence, ')
          ..write('lineType: $lineType, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('priceDay: $priceDay, ')
          ..write('discount: $discount, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('rentalState: $rentalState, ')
          ..write('pickedUpAt: $pickedUpAt, ')
          ..write('pickedUpBy: $pickedUpBy, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('returnedBy: $returnedBy, ')
          ..write('conditionOut: $conditionOut, ')
          ..write('conditionIn: $conditionIn, ')
          ..write('conditionNote: $conditionNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderLineSerialsTable extends OrderLineSerials
    with TableInfo<$OrderLineSerialsTable, OrderLineSerial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLineSerialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_lines (id)',
    ),
  );
  static const VerificationMeta _serialIdMeta = const VerificationMeta(
    'serialId',
  );
  @override
  late final GeneratedColumn<String> serialId = GeneratedColumn<String>(
    'serial_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES serials (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    lineId,
    serialId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_line_serials';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderLineSerial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('serial_id')) {
      context.handle(
        _serialIdMeta,
        serialId.isAcceptableOrUnknown(data['serial_id']!, _serialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serialIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLineSerial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLineSerial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      )!,
      serialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_id'],
      )!,
    );
  }

  @override
  $OrderLineSerialsTable createAlias(String alias) {
    return $OrderLineSerialsTable(attachedDatabase, alias);
  }
}

class OrderLineSerial extends DataClass implements Insertable<OrderLineSerial> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String lineId;
  final String serialId;
  const OrderLineSerial({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.lineId,
    required this.serialId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['line_id'] = Variable<String>(lineId);
    map['serial_id'] = Variable<String>(serialId);
    return map;
  }

  OrderLineSerialsCompanion toCompanion(bool nullToAbsent) {
    return OrderLineSerialsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      lineId: Value(lineId),
      serialId: Value(serialId),
    );
  }

  factory OrderLineSerial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLineSerial(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      serialId: serializer.fromJson<String>(json['serialId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'lineId': serializer.toJson<String>(lineId),
      'serialId': serializer.toJson<String>(serialId),
    };
  }

  OrderLineSerial copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? lineId,
    String? serialId,
  }) => OrderLineSerial(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    lineId: lineId ?? this.lineId,
    serialId: serialId ?? this.serialId,
  );
  OrderLineSerial copyWithCompanion(OrderLineSerialsCompanion data) {
    return OrderLineSerial(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      serialId: data.serialId.present ? data.serialId.value : this.serialId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderLineSerial(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('lineId: $lineId, ')
          ..write('serialId: $serialId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deleted, dirty, odooId, lineId, serialId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLineSerial &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.lineId == this.lineId &&
          other.serialId == this.serialId);
}

class OrderLineSerialsCompanion extends UpdateCompanion<OrderLineSerial> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> lineId;
  final Value<String> serialId;
  final Value<int> rowid;
  const OrderLineSerialsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.serialId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderLineSerialsCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String lineId,
    required String serialId,
    this.rowid = const Value.absent(),
  }) : lineId = Value(lineId),
       serialId = Value(serialId);
  static Insertable<OrderLineSerial> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? lineId,
    Expression<String>? serialId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (lineId != null) 'line_id': lineId,
      if (serialId != null) 'serial_id': serialId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderLineSerialsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? lineId,
    Value<String>? serialId,
    Value<int>? rowid,
  }) {
    return OrderLineSerialsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      lineId: lineId ?? this.lineId,
      serialId: serialId ?? this.serialId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (serialId.present) {
      map['serial_id'] = Variable<String>(serialId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLineSerialsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('lineId: $lineId, ')
          ..write('serialId: $serialId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnChecksTable extends ReturnChecks
    with TableInfo<$ReturnChecksTable, ReturnCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_lines (id)',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _serialIdMeta = const VerificationMeta(
    'serialId',
  );
  @override
  late final GeneratedColumn<String> serialId = GeneratedColumn<String>(
    'serial_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES serials (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Condition, String> condition =
      GeneratedColumn<String>(
        'condition',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('good'),
      ).withConverter<Condition>($ReturnChecksTable.$convertercondition);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnedByMeta = const VerificationMeta(
    'returnedBy',
  );
  @override
  late final GeneratedColumn<String> returnedBy = GeneratedColumn<String>(
    'returned_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    lineId,
    orderId,
    serialId,
    condition,
    note,
    returnedAt,
    returnedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('serial_id')) {
      context.handle(
        _serialIdMeta,
        serialId.isAcceptableOrUnknown(data['serial_id']!, _serialIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_returnedAtMeta);
    }
    if (data.containsKey('returned_by')) {
      context.handle(
        _returnedByMeta,
        returnedBy.isAcceptableOrUnknown(data['returned_by']!, _returnedByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      serialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_id'],
      ),
      condition: $ReturnChecksTable.$convertercondition.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condition'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      )!,
      returnedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}returned_by'],
      ),
    );
  }

  @override
  $ReturnChecksTable createAlias(String alias) {
    return $ReturnChecksTable(attachedDatabase, alias);
  }

  static TypeConverter<Condition, String> $convertercondition =
      const KeyConverter(Condition.values);
}

class ReturnCheck extends DataClass implements Insertable<ReturnCheck> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String lineId;
  final String orderId;
  final String? serialId;
  final Condition condition;
  final String? note;
  final DateTime returnedAt;
  final String? returnedBy;
  const ReturnCheck({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    required this.lineId,
    required this.orderId,
    this.serialId,
    required this.condition,
    this.note,
    required this.returnedAt,
    this.returnedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    map['line_id'] = Variable<String>(lineId);
    map['order_id'] = Variable<String>(orderId);
    if (!nullToAbsent || serialId != null) {
      map['serial_id'] = Variable<String>(serialId);
    }
    {
      map['condition'] = Variable<String>(
        $ReturnChecksTable.$convertercondition.toSql(condition),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['returned_at'] = Variable<DateTime>(returnedAt);
    if (!nullToAbsent || returnedBy != null) {
      map['returned_by'] = Variable<String>(returnedBy);
    }
    return map;
  }

  ReturnChecksCompanion toCompanion(bool nullToAbsent) {
    return ReturnChecksCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      lineId: Value(lineId),
      orderId: Value(orderId),
      serialId: serialId == null && nullToAbsent
          ? const Value.absent()
          : Value(serialId),
      condition: Value(condition),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      returnedAt: Value(returnedAt),
      returnedBy: returnedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedBy),
    );
  }

  factory ReturnCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnCheck(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      serialId: serializer.fromJson<String?>(json['serialId']),
      condition: serializer.fromJson<Condition>(json['condition']),
      note: serializer.fromJson<String?>(json['note']),
      returnedAt: serializer.fromJson<DateTime>(json['returnedAt']),
      returnedBy: serializer.fromJson<String?>(json['returnedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'lineId': serializer.toJson<String>(lineId),
      'orderId': serializer.toJson<String>(orderId),
      'serialId': serializer.toJson<String?>(serialId),
      'condition': serializer.toJson<Condition>(condition),
      'note': serializer.toJson<String?>(note),
      'returnedAt': serializer.toJson<DateTime>(returnedAt),
      'returnedBy': serializer.toJson<String?>(returnedBy),
    };
  }

  ReturnCheck copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    String? lineId,
    String? orderId,
    Value<String?> serialId = const Value.absent(),
    Condition? condition,
    Value<String?> note = const Value.absent(),
    DateTime? returnedAt,
    Value<String?> returnedBy = const Value.absent(),
  }) => ReturnCheck(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    lineId: lineId ?? this.lineId,
    orderId: orderId ?? this.orderId,
    serialId: serialId.present ? serialId.value : this.serialId,
    condition: condition ?? this.condition,
    note: note.present ? note.value : this.note,
    returnedAt: returnedAt ?? this.returnedAt,
    returnedBy: returnedBy.present ? returnedBy.value : this.returnedBy,
  );
  ReturnCheck copyWithCompanion(ReturnChecksCompanion data) {
    return ReturnCheck(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      serialId: data.serialId.present ? data.serialId.value : this.serialId,
      condition: data.condition.present ? data.condition.value : this.condition,
      note: data.note.present ? data.note.value : this.note,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      returnedBy: data.returnedBy.present
          ? data.returnedBy.value
          : this.returnedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnCheck(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('lineId: $lineId, ')
          ..write('orderId: $orderId, ')
          ..write('serialId: $serialId, ')
          ..write('condition: $condition, ')
          ..write('note: $note, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('returnedBy: $returnedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    lineId,
    orderId,
    serialId,
    condition,
    note,
    returnedAt,
    returnedBy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnCheck &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.lineId == this.lineId &&
          other.orderId == this.orderId &&
          other.serialId == this.serialId &&
          other.condition == this.condition &&
          other.note == this.note &&
          other.returnedAt == this.returnedAt &&
          other.returnedBy == this.returnedBy);
}

class ReturnChecksCompanion extends UpdateCompanion<ReturnCheck> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String> lineId;
  final Value<String> orderId;
  final Value<String?> serialId;
  final Value<Condition> condition;
  final Value<String?> note;
  final Value<DateTime> returnedAt;
  final Value<String?> returnedBy;
  final Value<int> rowid;
  const ReturnChecksCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.serialId = const Value.absent(),
    this.condition = const Value.absent(),
    this.note = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.returnedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnChecksCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    required String lineId,
    required String orderId,
    this.serialId = const Value.absent(),
    this.condition = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime returnedAt,
    this.returnedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lineId = Value(lineId),
       orderId = Value(orderId),
       returnedAt = Value(returnedAt);
  static Insertable<ReturnCheck> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? lineId,
    Expression<String>? orderId,
    Expression<String>? serialId,
    Expression<String>? condition,
    Expression<String>? note,
    Expression<DateTime>? returnedAt,
    Expression<String>? returnedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (lineId != null) 'line_id': lineId,
      if (orderId != null) 'order_id': orderId,
      if (serialId != null) 'serial_id': serialId,
      if (condition != null) 'condition': condition,
      if (note != null) 'note': note,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (returnedBy != null) 'returned_by': returnedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnChecksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String>? lineId,
    Value<String>? orderId,
    Value<String?>? serialId,
    Value<Condition>? condition,
    Value<String?>? note,
    Value<DateTime>? returnedAt,
    Value<String?>? returnedBy,
    Value<int>? rowid,
  }) {
    return ReturnChecksCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      lineId: lineId ?? this.lineId,
      orderId: orderId ?? this.orderId,
      serialId: serialId ?? this.serialId,
      condition: condition ?? this.condition,
      note: note ?? this.note,
      returnedAt: returnedAt ?? this.returnedAt,
      returnedBy: returnedBy ?? this.returnedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (serialId.present) {
      map['serial_id'] = Variable<String>(serialId.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(
        $ReturnChecksTable.$convertercondition.toSql(condition.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (returnedBy.present) {
      map['returned_by'] = Variable<String>(returnedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnChecksCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('lineId: $lineId, ')
          ..write('orderId: $orderId, ')
          ..write('serialId: $serialId, ')
          ..write('condition: $condition, ')
          ..write('note: $note, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('returnedBy: $returnedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => rowUuid.v4(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odooIdMeta = const VerificationMeta('odooId');
  @override
  late final GeneratedColumn<int> odooId = GeneratedColumn<int>(
    'odoo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialIdMeta = const VerificationMeta(
    'serialId',
  );
  @override
  late final GeneratedColumn<String> serialId = GeneratedColumn<String>(
    'serial_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    assetId,
    serialId,
    orderId,
    lineId,
    storagePath,
    localPath,
    takenAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('odoo_id')) {
      context.handle(
        _odooIdMeta,
        odooId.isAcceptableOrUnknown(data['odoo_id']!, _odooIdMeta),
      );
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    }
    if (data.containsKey('serial_id')) {
      context.handle(
        _serialIdMeta,
        serialId.isAcceptableOrUnknown(data['serial_id']!, _serialIdMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      odooId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odoo_id'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      ),
      serialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_id'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      ),
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final String id;
  final DateTime updatedAt;
  final bool deleted;
  final bool dirty;
  final int? odooId;
  final String? assetId;
  final String? serialId;
  final String? orderId;
  final String? lineId;

  /// Path inside the Supabase bucket once uploaded.
  final String? storagePath;

  /// File on this device, until it is uploaded (or for offline viewing).
  final String? localPath;
  final DateTime takenAt;
  final String? note;
  const Photo({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.dirty,
    this.odooId,
    this.assetId,
    this.serialId,
    this.orderId,
    this.lineId,
    this.storagePath,
    this.localPath,
    required this.takenAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || odooId != null) {
      map['odoo_id'] = Variable<int>(odooId);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    if (!nullToAbsent || serialId != null) {
      map['serial_id'] = Variable<String>(serialId);
    }
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    if (!nullToAbsent || lineId != null) {
      map['line_id'] = Variable<String>(lineId);
    }
    if (!nullToAbsent || storagePath != null) {
      map['storage_path'] = Variable<String>(storagePath);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      dirty: Value(dirty),
      odooId: odooId == null && nullToAbsent
          ? const Value.absent()
          : Value(odooId),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      serialId: serialId == null && nullToAbsent
          ? const Value.absent()
          : Value(serialId),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      lineId: lineId == null && nullToAbsent
          ? const Value.absent()
          : Value(lineId),
      storagePath: storagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(storagePath),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      takenAt: Value(takenAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      odooId: serializer.fromJson<int?>(json['odooId']),
      assetId: serializer.fromJson<String?>(json['assetId']),
      serialId: serializer.fromJson<String?>(json['serialId']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      lineId: serializer.fromJson<String?>(json['lineId']),
      storagePath: serializer.fromJson<String?>(json['storagePath']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'odooId': serializer.toJson<int?>(odooId),
      'assetId': serializer.toJson<String?>(assetId),
      'serialId': serializer.toJson<String?>(serialId),
      'orderId': serializer.toJson<String?>(orderId),
      'lineId': serializer.toJson<String?>(lineId),
      'storagePath': serializer.toJson<String?>(storagePath),
      'localPath': serializer.toJson<String?>(localPath),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  Photo copyWith({
    String? id,
    DateTime? updatedAt,
    bool? deleted,
    bool? dirty,
    Value<int?> odooId = const Value.absent(),
    Value<String?> assetId = const Value.absent(),
    Value<String?> serialId = const Value.absent(),
    Value<String?> orderId = const Value.absent(),
    Value<String?> lineId = const Value.absent(),
    Value<String?> storagePath = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    DateTime? takenAt,
    Value<String?> note = const Value.absent(),
  }) => Photo(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    dirty: dirty ?? this.dirty,
    odooId: odooId.present ? odooId.value : this.odooId,
    assetId: assetId.present ? assetId.value : this.assetId,
    serialId: serialId.present ? serialId.value : this.serialId,
    orderId: orderId.present ? orderId.value : this.orderId,
    lineId: lineId.present ? lineId.value : this.lineId,
    storagePath: storagePath.present ? storagePath.value : this.storagePath,
    localPath: localPath.present ? localPath.value : this.localPath,
    takenAt: takenAt ?? this.takenAt,
    note: note.present ? note.value : this.note,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      odooId: data.odooId.present ? data.odooId.value : this.odooId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      serialId: data.serialId.present ? data.serialId.value : this.serialId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('assetId: $assetId, ')
          ..write('serialId: $serialId, ')
          ..write('orderId: $orderId, ')
          ..write('lineId: $lineId, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('takenAt: $takenAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    dirty,
    odooId,
    assetId,
    serialId,
    orderId,
    lineId,
    storagePath,
    localPath,
    takenAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.odooId == this.odooId &&
          other.assetId == this.assetId &&
          other.serialId == this.serialId &&
          other.orderId == this.orderId &&
          other.lineId == this.lineId &&
          other.storagePath == this.storagePath &&
          other.localPath == this.localPath &&
          other.takenAt == this.takenAt &&
          other.note == this.note);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<int?> odooId;
  final Value<String?> assetId;
  final Value<String?> serialId;
  final Value<String?> orderId;
  final Value<String?> lineId;
  final Value<String?> storagePath;
  final Value<String?> localPath;
  final Value<DateTime> takenAt;
  final Value<String?> note;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.serialId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.odooId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.serialId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Photo> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<int>? odooId,
    Expression<String>? assetId,
    Expression<String>? serialId,
    Expression<String>? orderId,
    Expression<String>? lineId,
    Expression<String>? storagePath,
    Expression<String>? localPath,
    Expression<DateTime>? takenAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (odooId != null) 'odoo_id': odooId,
      if (assetId != null) 'asset_id': assetId,
      if (serialId != null) 'serial_id': serialId,
      if (orderId != null) 'order_id': orderId,
      if (lineId != null) 'line_id': lineId,
      if (storagePath != null) 'storage_path': storagePath,
      if (localPath != null) 'local_path': localPath,
      if (takenAt != null) 'taken_at': takenAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? dirty,
    Value<int?>? odooId,
    Value<String?>? assetId,
    Value<String?>? serialId,
    Value<String?>? orderId,
    Value<String?>? lineId,
    Value<String?>? storagePath,
    Value<String?>? localPath,
    Value<DateTime>? takenAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      odooId: odooId ?? this.odooId,
      assetId: assetId ?? this.assetId,
      serialId: serialId ?? this.serialId,
      orderId: orderId ?? this.orderId,
      lineId: lineId ?? this.lineId,
      storagePath: storagePath ?? this.storagePath,
      localPath: localPath ?? this.localPath,
      takenAt: takenAt ?? this.takenAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (odooId.present) {
      map['odoo_id'] = Variable<int>(odooId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (serialId.present) {
      map['serial_id'] = Variable<String>(serialId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('odooId: $odooId, ')
          ..write('assetId: $assetId, ')
          ..write('serialId: $serialId, ')
          ..write('orderId: $orderId, ')
          ..write('lineId: $lineId, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('takenAt: $takenAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableName_Meta = const VerificationMeta(
    'tableName_',
  );
  @override
  late final GeneratedColumn<String> tableName_ = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [tableName_, serverSeq];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(
        _tableName_Meta,
        tableName_.isAcceptableOrUnknown(data['table_name']!, _tableName_Meta),
      );
    } else if (isInserting) {
      context.missing(_tableName_Meta);
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableName_};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      tableName_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String tableName_;
  final int serverSeq;
  const SyncCursor({required this.tableName_, required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(tableName_);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      tableName_: Value(tableName_),
      serverSeq: Value(serverSeq),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      tableName_: serializer.fromJson<String>(json['tableName_']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableName_': serializer.toJson<String>(tableName_),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  SyncCursor copyWith({String? tableName_, int? serverSeq}) => SyncCursor(
    tableName_: tableName_ ?? this.tableName_,
    serverSeq: serverSeq ?? this.serverSeq,
  );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      tableName_: data.tableName_.present
          ? data.tableName_.value
          : this.tableName_,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('tableName_: $tableName_, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tableName_, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.tableName_ == this.tableName_ &&
          other.serverSeq == this.serverSeq);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> tableName_;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.tableName_ = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String tableName_,
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tableName_ = Value(tableName_);
  static Insertable<SyncCursor> custom({
    Expression<String>? tableName_,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tableName_ != null) 'table_name': tableName_,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? tableName_,
    Value<int>? serverSeq,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      tableName_: tableName_ ?? this.tableName_,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableName_.present) {
      map['table_name'] = Variable<String>(tableName_.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('tableName_: $tableName_, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$RentoryDatabase extends GeneratedDatabase {
  _$RentoryDatabase(QueryExecutor e) : super(e);
  $RentoryDatabaseManager get managers => $RentoryDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $DocumentTypesTable documentTypes = $DocumentTypesTable(this);
  late final $CustomerDiscountsTable customerDiscounts =
      $CustomerDiscountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $SerialsTable serials = $SerialsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderDocumentsTable orderDocuments = $OrderDocumentsTable(this);
  late final $OrderLinesTable orderLines = $OrderLinesTable(this);
  late final $OrderLineSerialsTable orderLineSerials = $OrderLineSerialsTable(
    this,
  );
  late final $ReturnChecksTable returnChecks = $ReturnChecksTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    customers,
    documentTypes,
    customerDiscounts,
    categories,
    locations,
    assets,
    serials,
    orders,
    orderDocuments,
    orderLines,
    orderLineSerials,
    returnChecks,
    photos,
    syncCursors,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String name,
  Value<Role> role,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> name,
  Value<Role> role,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$RentoryDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Role, Role, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$RentoryDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Role, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$RentoryDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$RentoryDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Role> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<Role> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$RentoryDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$RentoryDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String name,
  Value<String?> phone,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> name,
  Value<String?> phone,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$RentoryDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomerDiscountsTable, List<CustomerDiscount>>
  _customerDiscountsRefsTable(_$RentoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customerDiscounts,
        aliasName: 'customers__id__customer_discounts__customer_id',
      );

  $$CustomerDiscountsTableProcessedTableManager get customerDiscountsRefs {
    final manager = $$CustomerDiscountsTableTableManager(
      $_db,
      $_db.customerDiscounts,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customerDiscountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'customers__id__orders__customer_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$RentoryDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customerDiscountsRefs(
    Expression<bool> Function($$CustomerDiscountsTableFilterComposer f) f,
  ) {
    final $$CustomerDiscountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customerDiscounts,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomerDiscountsTableFilterComposer(
            $db: $db,
            $table: $db.customerDiscounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$RentoryDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> customerDiscountsRefs<T extends Object>(
    Expression<T> Function($$CustomerDiscountsTableAnnotationComposer a) f,
  ) {
    final $$CustomerDiscountsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customerDiscounts,
          getReferencedColumn: (t) => t.customerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerDiscountsTableAnnotationComposer(
                $db: $db,
                $table: $db.customerDiscounts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool customerDiscountsRefs, bool ordersRefs})
        > {
  $$CustomersTableTableManager(_$RentoryDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                phone: phone,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                phone: phone,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerDiscountsRefs = false, ordersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customerDiscountsRefs) db.customerDiscounts,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customerDiscountsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          CustomerDiscount
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._customerDiscountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).customerDiscountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Order
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool customerDiscountsRefs, bool ordersRefs})
    >;
typedef $$DocumentTypesTableCreateCompanionBuilder =
    DocumentTypesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      required String name,
      Value<int> sequence,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$DocumentTypesTableUpdateCompanionBuilder =
    DocumentTypesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      Value<String> name,
      Value<int> sequence,
      Value<bool> active,
      Value<int> rowid,
    });

final class $$DocumentTypesTableReferences
    extends
        BaseReferences<_$RentoryDatabase, $DocumentTypesTable, DocumentType> {
  $$DocumentTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OrderDocumentsTable, List<OrderDocument>>
  _orderDocumentsRefsTable(_$RentoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderDocuments,
        aliasName: 'document_types__id__order_documents__document_type_id',
      );

  $$OrderDocumentsTableProcessedTableManager get orderDocumentsRefs {
    final manager = $$OrderDocumentsTableTableManager(
      $_db,
      $_db.orderDocuments,
    ).filter((f) => f.documentTypeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderDocumentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentTypesTableFilterComposer
    extends Composer<_$RentoryDatabase, $DocumentTypesTable> {
  $$DocumentTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderDocumentsRefs(
    Expression<bool> Function($$OrderDocumentsTableFilterComposer f) f,
  ) {
    final $$OrderDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderDocuments,
      getReferencedColumn: (t) => t.documentTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.orderDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentTypesTableOrderingComposer
    extends Composer<_$RentoryDatabase, $DocumentTypesTable> {
  $$DocumentTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentTypesTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $DocumentTypesTable> {
  $$DocumentTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> orderDocumentsRefs<T extends Object>(
    Expression<T> Function($$OrderDocumentsTableAnnotationComposer a) f,
  ) {
    final $$OrderDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderDocuments,
      getReferencedColumn: (t) => t.documentTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentTypesTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $DocumentTypesTable,
          DocumentType,
          $$DocumentTypesTableFilterComposer,
          $$DocumentTypesTableOrderingComposer,
          $$DocumentTypesTableAnnotationComposer,
          $$DocumentTypesTableCreateCompanionBuilder,
          $$DocumentTypesTableUpdateCompanionBuilder,
          (DocumentType, $$DocumentTypesTableReferences),
          DocumentType,
          PrefetchHooks Function({bool orderDocumentsRefs})
        > {
  $$DocumentTypesTableTableManager(
    _$RentoryDatabase db,
    $DocumentTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTypesCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                sequence: sequence,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<int> sequence = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTypesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                sequence: sequence,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentTypesTable, DocumentType>(table),
                  $$DocumentTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderDocumentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderDocumentsRefs) db.orderDocuments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderDocumentsRefs)
                    await $_getPrefetchedData<
                      DocumentType,
                      $DocumentTypesTable,
                      OrderDocument
                    >(
                      currentTable: table,
                      referencedTable: $$DocumentTypesTableReferences
                          ._orderDocumentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DocumentTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).orderDocumentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.documentTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DocumentTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $DocumentTypesTable,
      DocumentType,
      $$DocumentTypesTableFilterComposer,
      $$DocumentTypesTableOrderingComposer,
      $$DocumentTypesTableAnnotationComposer,
      $$DocumentTypesTableCreateCompanionBuilder,
      $$DocumentTypesTableUpdateCompanionBuilder,
      (DocumentType, $$DocumentTypesTableReferences),
      DocumentType,
      PrefetchHooks Function({bool orderDocumentsRefs})
    >;
typedef $$CustomerDiscountsTableCreateCompanionBuilder =
    CustomerDiscountsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      required String name,
      Value<String?> customerId,
      Value<DiscountType> discountType,
      Value<double> discountValue,
      Value<DateTime?> dateFrom,
      Value<DateTime?> dateTo,
      Value<String?> note,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$CustomerDiscountsTableUpdateCompanionBuilder =
    CustomerDiscountsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      Value<String> name,
      Value<String?> customerId,
      Value<DiscountType> discountType,
      Value<double> discountValue,
      Value<DateTime?> dateFrom,
      Value<DateTime?> dateTo,
      Value<String?> note,
      Value<bool> active,
      Value<int> rowid,
    });

final class $$CustomerDiscountsTableReferences
    extends
        BaseReferences<
          _$RentoryDatabase,
          $CustomerDiscountsTable,
          CustomerDiscount
        > {
  $$CustomerDiscountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CustomersTable _customerIdTable(_$RentoryDatabase db) => db.customers
      .createAlias('customer_discounts__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'customer_discounts__id__orders__customer_discount_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager($_db, $_db.orders).filter(
      (f) => f.customerDiscountId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomerDiscountsTableFilterComposer
    extends Composer<_$RentoryDatabase, $CustomerDiscountsTable> {
  $$CustomerDiscountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DiscountType, DiscountType, String>
  get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerDiscountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomerDiscountsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $CustomerDiscountsTable> {
  $$CustomerDiscountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomerDiscountsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $CustomerDiscountsTable> {
  $$CustomerDiscountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DiscountType, String> get discountType =>
      $composableBuilder(
        column: $table.discountType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateFrom =>
      $composableBuilder(column: $table.dateFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get dateTo =>
      $composableBuilder(column: $table.dateTo, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerDiscountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomerDiscountsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $CustomerDiscountsTable,
          CustomerDiscount,
          $$CustomerDiscountsTableFilterComposer,
          $$CustomerDiscountsTableOrderingComposer,
          $$CustomerDiscountsTableAnnotationComposer,
          $$CustomerDiscountsTableCreateCompanionBuilder,
          $$CustomerDiscountsTableUpdateCompanionBuilder,
          (CustomerDiscount, $$CustomerDiscountsTableReferences),
          CustomerDiscount,
          PrefetchHooks Function({bool customerId, bool ordersRefs})
        > {
  $$CustomerDiscountsTableTableManager(
    _$RentoryDatabase db,
    $CustomerDiscountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerDiscountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerDiscountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerDiscountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<DiscountType> discountType = const Value.absent(),
                Value<double> discountValue = const Value.absent(),
                Value<DateTime?> dateFrom = const Value.absent(),
                Value<DateTime?> dateTo = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerDiscountsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                customerId: customerId,
                discountType: discountType,
                discountValue: discountValue,
                dateFrom: dateFrom,
                dateTo: dateTo,
                note: note,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<String?> customerId = const Value.absent(),
                Value<DiscountType> discountType = const Value.absent(),
                Value<double> discountValue = const Value.absent(),
                Value<DateTime?> dateFrom = const Value.absent(),
                Value<DateTime?> dateTo = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerDiscountsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                customerId: customerId,
                discountType: discountType,
                discountValue: discountValue,
                dateFrom: dateFrom,
                dateTo: dateTo,
                note: note,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomerDiscountsTable, CustomerDiscount>(table),
                  $$CustomerDiscountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customerId = false, ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (customerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.customerId,
                        referencedTable: $$CustomerDiscountsTableReferences
                            ._customerIdTable(db),
                        referencedColumn: $$CustomerDiscountsTableReferences
                            ._customerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<
                      CustomerDiscount,
                      $CustomerDiscountsTable,
                      Order
                    >(
                      currentTable: table,
                      referencedTable: $$CustomerDiscountsTableReferences
                          ._ordersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomerDiscountsTableReferences(
                            db,
                            table,
                            p0,
                          ).ordersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.customerDiscountId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomerDiscountsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $CustomerDiscountsTable,
      CustomerDiscount,
      $$CustomerDiscountsTableFilterComposer,
      $$CustomerDiscountsTableOrderingComposer,
      $$CustomerDiscountsTableAnnotationComposer,
      $$CustomerDiscountsTableCreateCompanionBuilder,
      $$CustomerDiscountsTableUpdateCompanionBuilder,
      (CustomerDiscount, $$CustomerDiscountsTableReferences),
      CustomerDiscount,
      PrefetchHooks Function({bool customerId, bool ordersRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String name,
  Value<String?> parentId,
  Value<int> color,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> name,
  Value<String?> parentId,
  Value<int> color,
  Value<bool> active,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$RentoryDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.assets,
    aliasName: 'categories__id__assets__category_id',
  );

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$RentoryDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assetsRefs(
    Expression<bool> Function($$AssetsTableFilterComposer f) f,
  ) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$RentoryDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> assetsRefs<T extends Object>(
    Expression<T> Function($$AssetsTableAnnotationComposer a) f,
  ) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool assetsRefs})
        > {
  $$CategoriesTableTableManager(_$RentoryDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                parentId: parentId,
                color: color,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                parentId: parentId,
                color: color,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assetsRefs) db.assets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetsRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Asset
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._assetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(db, table, p0).assetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool assetsRefs})
    >;
typedef $$LocationsTableCreateCompanionBuilder = LocationsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String name,
  Value<String?> parentId,
  Value<String?> note,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$LocationsTableUpdateCompanionBuilder = LocationsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> name,
  Value<String?> parentId,
  Value<String?> note,
  Value<bool> active,
  Value<int> rowid,
});

final class $$LocationsTableReferences
    extends BaseReferences<_$RentoryDatabase, $LocationsTable, Location> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.assets,
    aliasName: 'locations__id__assets__location_id',
  );

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SerialsTable, List<Serial>> _serialsRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.serials,
    aliasName: 'locations__id__serials__location_id',
  );

  $$SerialsTableProcessedTableManager get serialsRefs {
    final manager = $$SerialsTableTableManager(
      $_db,
      $_db.serials,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$RentoryDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assetsRefs(
    Expression<bool> Function($$AssetsTableFilterComposer f) f,
  ) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> serialsRefs(
    Expression<bool> Function($$SerialsTableFilterComposer f) f,
  ) {
    final $$SerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableFilterComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> assetsRefs<T extends Object>(
    Expression<T> Function($$AssetsTableAnnotationComposer a) f,
  ) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> serialsRefs<T extends Object>(
    Expression<T> Function($$SerialsTableAnnotationComposer a) f,
  ) {
    final $$SerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, $$LocationsTableReferences),
          Location,
          PrefetchHooks Function({bool assetsRefs, bool serialsRefs})
        > {
  $$LocationsTableTableManager(_$RentoryDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                parentId: parentId,
                note: note,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                parentId: parentId,
                note: note,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocationsTable, Location>(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assetsRefs = false, serialsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (assetsRefs) db.assets,
                if (serialsRefs) db.serials,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetsRefs)
                    await $_getPrefetchedData<Location, $LocationsTable, Asset>(
                      currentTable: table,
                      referencedTable: $$LocationsTableReferences
                          ._assetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocationsTableReferences(db, table, p0).assetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.locationId == item.id),
                      typedResults: items,
                    ),
                  if (serialsRefs)
                    await $_getPrefetchedData<
                      Location,
                      $LocationsTable,
                      Serial
                    >(
                      currentTable: table,
                      referencedTable: $$LocationsTableReferences
                          ._serialsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocationsTableReferences(db, table, p0).serialsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.locationId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, $$LocationsTableReferences),
      Location,
      PrefetchHooks Function({bool assetsRefs, bool serialsRefs})
    >;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String name,
  Value<String?> code,
  Value<String?> barcode,
  Value<String?> categoryId,
  Value<Tracking> tracking,
  Value<bool> rentalOk,
  Value<double> qtyManual,
  Value<double> rentalPriceDay,
  Value<double> declaredValue,
  Value<String?> locationId,
  Value<String?> imagePath,
  Value<String?> notes,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> name,
  Value<String?> code,
  Value<String?> barcode,
  Value<String?> categoryId,
  Value<Tracking> tracking,
  Value<bool> rentalOk,
  Value<double> qtyManual,
  Value<double> rentalPriceDay,
  Value<double> declaredValue,
  Value<String?> locationId,
  Value<String?> imagePath,
  Value<String?> notes,
  Value<bool> active,
  Value<int> rowid,
});

final class $$AssetsTableReferences
    extends BaseReferences<_$RentoryDatabase, $AssetsTable, Asset> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$RentoryDatabase db) =>
      db.categories.createAlias('assets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _locationIdTable(_$RentoryDatabase db) =>
      db.locations.createAlias('assets__location_id__locations__id');

  $$LocationsTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<String>('location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SerialsTable, List<Serial>> _serialsRefsTable(
    _$RentoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.serials,
    aliasName: 'assets__id__serials__asset_id',
  );

  $$SerialsTableProcessedTableManager get serialsRefs {
    final manager = $$SerialsTableTableManager(
      $_db,
      $_db.serials,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderLinesTable, List<OrderLine>>
  _orderLinesRefsTable(_$RentoryDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLines,
    aliasName: 'assets__id__order_lines__asset_id',
  );

  $$OrderLinesTableProcessedTableManager get orderLinesRefs {
    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.assetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$RentoryDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Tracking, Tracking, String> get tracking =>
      $composableBuilder(
        column: $table.tracking,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get rentalOk => $composableBuilder(
    column: $table.rentalOk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qtyManual => $composableBuilder(
    column: $table.qtyManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rentalPriceDay => $composableBuilder(
    column: $table.rentalPriceDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serialsRefs(
    Expression<bool> Function($$SerialsTableFilterComposer f) f,
  ) {
    final $$SerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableFilterComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderLinesRefs(
    Expression<bool> Function($$OrderLinesTableFilterComposer f) f,
  ) {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tracking => $composableBuilder(
    column: $table.tracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rentalOk => $composableBuilder(
    column: $table.rentalOk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qtyManual => $composableBuilder(
    column: $table.qtyManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rentalPriceDay => $composableBuilder(
    column: $table.rentalPriceDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Tracking, String> get tracking =>
      $composableBuilder(column: $table.tracking, builder: (column) => column);

  GeneratedColumn<bool> get rentalOk =>
      $composableBuilder(column: $table.rentalOk, builder: (column) => column);

  GeneratedColumn<double> get qtyManual =>
      $composableBuilder(column: $table.qtyManual, builder: (column) => column);

  GeneratedColumn<double> get rentalPriceDay => $composableBuilder(
    column: $table.rentalPriceDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serialsRefs<T extends Object>(
    Expression<T> Function($$SerialsTableAnnotationComposer a) f,
  ) {
    final $$SerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderLinesRefs<T extends Object>(
    Expression<T> Function($$OrderLinesTableAnnotationComposer a) f,
  ) {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.assetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $AssetsTable,
          Asset,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (Asset, $$AssetsTableReferences),
          Asset,
          PrefetchHooks Function({
            bool categoryId,
            bool locationId,
            bool serialsRefs,
            bool orderLinesRefs,
          })
        > {
  $$AssetsTableTableManager(_$RentoryDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<Tracking> tracking = const Value.absent(),
                Value<bool> rentalOk = const Value.absent(),
                Value<double> qtyManual = const Value.absent(),
                Value<double> rentalPriceDay = const Value.absent(),
                Value<double> declaredValue = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                code: code,
                barcode: barcode,
                categoryId: categoryId,
                tracking: tracking,
                rentalOk: rentalOk,
                qtyManual: qtyManual,
                rentalPriceDay: rentalPriceDay,
                declaredValue: declaredValue,
                locationId: locationId,
                imagePath: imagePath,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<Tracking> tracking = const Value.absent(),
                Value<bool> rentalOk = const Value.absent(),
                Value<double> qtyManual = const Value.absent(),
                Value<double> rentalPriceDay = const Value.absent(),
                Value<double> declaredValue = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                name: name,
                code: code,
                barcode: barcode,
                categoryId: categoryId,
                tracking: tracking,
                rentalOk: rentalOk,
                qtyManual: qtyManual,
                rentalPriceDay: rentalPriceDay,
                declaredValue: declaredValue,
                locationId: locationId,
                imagePath: imagePath,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetsTable, Asset>(table),
                  $$AssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                locationId = false,
                serialsRefs = false,
                orderLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serialsRefs) db.serials,
                    if (orderLinesRefs) db.orderLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$AssetsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$AssetsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (locationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.locationId,
                            referencedTable: $$AssetsTableReferences
                                ._locationIdTable(db),
                            referencedColumn: $$AssetsTableReferences
                                ._locationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serialsRefs)
                        await $_getPrefetchedData<Asset, $AssetsTable, Serial>(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._serialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).serialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderLinesRefs)
                        await $_getPrefetchedData<
                          Asset,
                          $AssetsTable,
                          OrderLine
                        >(
                          currentTable: table,
                          referencedTable: $$AssetsTableReferences
                              ._orderLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $AssetsTable,
      Asset,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (Asset, $$AssetsTableReferences),
      Asset,
      PrefetchHooks Function({
        bool categoryId,
        bool locationId,
        bool serialsRefs,
        bool orderLinesRefs,
      })
    >;
typedef $$SerialsTableCreateCompanionBuilder = SerialsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String assetId,
  required String name,
  Value<String?> barcode,
  Value<SerialState> state,
  Value<String?> locationId,
  Value<String?> currentOrderId,
  Value<String?> currentLineId,
  Value<double> declaredValue,
  Value<String?> note,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$SerialsTableUpdateCompanionBuilder = SerialsCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> assetId,
  Value<String> name,
  Value<String?> barcode,
  Value<SerialState> state,
  Value<String?> locationId,
  Value<String?> currentOrderId,
  Value<String?> currentLineId,
  Value<double> declaredValue,
  Value<String?> note,
  Value<bool> active,
  Value<int> rowid,
});

final class $$SerialsTableReferences
    extends BaseReferences<_$RentoryDatabase, $SerialsTable, Serial> {
  $$SerialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$RentoryDatabase db) =>
      db.assets.createAlias('serials__asset_id__assets__id');

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<String>('asset_id')!;

    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _locationIdTable(_$RentoryDatabase db) =>
      db.locations.createAlias('serials__location_id__locations__id');

  $$LocationsTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<String>('location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderLineSerialsTable, List<OrderLineSerial>>
  _orderLineSerialsRefsTable(_$RentoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderLineSerials,
        aliasName: 'serials__id__order_line_serials__serial_id',
      );

  $$OrderLineSerialsTableProcessedTableManager get orderLineSerialsRefs {
    final manager = $$OrderLineSerialsTableTableManager(
      $_db,
      $_db.orderLineSerials,
    ).filter((f) => f.serialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderLineSerialsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReturnChecksTable, List<ReturnCheck>>
  _returnChecksRefsTable(_$RentoryDatabase db) => MultiTypedResultKey.fromTable(
    db.returnChecks,
    aliasName: 'serials__id__return_checks__serial_id',
  );

  $$ReturnChecksTableProcessedTableManager get returnChecksRefs {
    final manager = $$ReturnChecksTableTableManager(
      $_db,
      $_db.returnChecks,
    ).filter((f) => f.serialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SerialsTableFilterComposer
    extends Composer<_$RentoryDatabase, $SerialsTable> {
  $$SerialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SerialState, SerialState, String> get state =>
      $composableBuilder(
        column: $table.state,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currentOrderId => $composableBuilder(
    column: $table.currentOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentLineId => $composableBuilder(
    column: $table.currentLineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderLineSerialsRefs(
    Expression<bool> Function($$OrderLineSerialsTableFilterComposer f) f,
  ) {
    final $$OrderLineSerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineSerials,
      getReferencedColumn: (t) => t.serialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineSerialsTableFilterComposer(
            $db: $db,
            $table: $db.orderLineSerials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnChecksRefs(
    Expression<bool> Function($$ReturnChecksTableFilterComposer f) f,
  ) {
    final $$ReturnChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.serialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableFilterComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SerialsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $SerialsTable> {
  $$SerialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentOrderId => $composableBuilder(
    column: $table.currentOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentLineId => $composableBuilder(
    column: $table.currentLineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SerialsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $SerialsTable> {
  $$SerialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SerialState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get currentOrderId => $composableBuilder(
    column: $table.currentOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentLineId => $composableBuilder(
    column: $table.currentLineId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get declaredValue => $composableBuilder(
    column: $table.declaredValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderLineSerialsRefs<T extends Object>(
    Expression<T> Function($$OrderLineSerialsTableAnnotationComposer a) f,
  ) {
    final $$OrderLineSerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineSerials,
      getReferencedColumn: (t) => t.serialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineSerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLineSerials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnChecksRefs<T extends Object>(
    Expression<T> Function($$ReturnChecksTableAnnotationComposer a) f,
  ) {
    final $$ReturnChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.serialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SerialsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $SerialsTable,
          Serial,
          $$SerialsTableFilterComposer,
          $$SerialsTableOrderingComposer,
          $$SerialsTableAnnotationComposer,
          $$SerialsTableCreateCompanionBuilder,
          $$SerialsTableUpdateCompanionBuilder,
          (Serial, $$SerialsTableReferences),
          Serial,
          PrefetchHooks Function({
            bool assetId,
            bool locationId,
            bool orderLineSerialsRefs,
            bool returnChecksRefs,
          })
        > {
  $$SerialsTableTableManager(_$RentoryDatabase db, $SerialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SerialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SerialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SerialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<SerialState> state = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> currentOrderId = const Value.absent(),
                Value<String?> currentLineId = const Value.absent(),
                Value<double> declaredValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SerialsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                assetId: assetId,
                name: name,
                barcode: barcode,
                state: state,
                locationId: locationId,
                currentOrderId: currentOrderId,
                currentLineId: currentLineId,
                declaredValue: declaredValue,
                note: note,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String assetId,
                required String name,
                Value<String?> barcode = const Value.absent(),
                Value<SerialState> state = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> currentOrderId = const Value.absent(),
                Value<String?> currentLineId = const Value.absent(),
                Value<double> declaredValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SerialsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                assetId: assetId,
                name: name,
                barcode: barcode,
                state: state,
                locationId: locationId,
                currentOrderId: currentOrderId,
                currentLineId: currentLineId,
                declaredValue: declaredValue,
                note: note,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SerialsTable, Serial>(table),
                  $$SerialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                assetId = false,
                locationId = false,
                orderLineSerialsRefs = false,
                returnChecksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderLineSerialsRefs) db.orderLineSerials,
                    if (returnChecksRefs) db.returnChecks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (assetId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.assetId,
                            referencedTable: $$SerialsTableReferences
                                ._assetIdTable(db),
                            referencedColumn: $$SerialsTableReferences
                                ._assetIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (locationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.locationId,
                            referencedTable: $$SerialsTableReferences
                                ._locationIdTable(db),
                            referencedColumn: $$SerialsTableReferences
                                ._locationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderLineSerialsRefs)
                        await $_getPrefetchedData<
                          Serial,
                          $SerialsTable,
                          OrderLineSerial
                        >(
                          currentTable: table,
                          referencedTable: $$SerialsTableReferences
                              ._orderLineSerialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SerialsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLineSerialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serialId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnChecksRefs)
                        await $_getPrefetchedData<
                          Serial,
                          $SerialsTable,
                          ReturnCheck
                        >(
                          currentTable: table,
                          referencedTable: $$SerialsTableReferences
                              ._returnChecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SerialsTableReferences(
                                db,
                                table,
                                p0,
                              ).returnChecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serialId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SerialsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $SerialsTable,
      Serial,
      $$SerialsTableFilterComposer,
      $$SerialsTableOrderingComposer,
      $$SerialsTableAnnotationComposer,
      $$SerialsTableCreateCompanionBuilder,
      $$SerialsTableUpdateCompanionBuilder,
      (Serial, $$SerialsTableReferences),
      Serial,
      PrefetchHooks Function({
        bool assetId,
        bool locationId,
        bool orderLineSerialsRefs,
        bool returnChecksRefs,
      })
    >;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String?> number,
  Value<String?> customerId,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<DateTime?> dateStart,
  Value<DateTime?> dateEnd,
  Value<OrderState> state,
  Value<DiscountType> discountType,
  Value<double> discountValue,
  Value<String?> customerDiscountId,
  Value<double> amountDeposit,
  Value<double> amountPaid,
  Value<bool> lateFeeManual,
  Value<bool> lateDaysEdited,
  Value<int> lateDaysOverride,
  Value<bool> sigRentalContract,
  Value<bool> sigPickupReturnReceipt,
  Value<bool> sigLoanContract,
  Value<bool> itemsCaptured,
  Value<bool> itemsExamined,
  Value<DateTime?> itemsExaminedAt,
  Value<String?> itemsExaminedBy,
  Value<DateTime?> documentsReturnedAt,
  Value<String?> documentsReturnedBy,
  Value<String?> signaturePath,
  Value<String?> signatureName,
  Value<DateTime?> signatureDate,
  Value<String?> userId,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String?> number,
  Value<String?> customerId,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<DateTime?> dateStart,
  Value<DateTime?> dateEnd,
  Value<OrderState> state,
  Value<DiscountType> discountType,
  Value<double> discountValue,
  Value<String?> customerDiscountId,
  Value<double> amountDeposit,
  Value<double> amountPaid,
  Value<bool> lateFeeManual,
  Value<bool> lateDaysEdited,
  Value<int> lateDaysOverride,
  Value<bool> sigRentalContract,
  Value<bool> sigPickupReturnReceipt,
  Value<bool> sigLoanContract,
  Value<bool> itemsCaptured,
  Value<bool> itemsExamined,
  Value<DateTime?> itemsExaminedAt,
  Value<String?> itemsExaminedBy,
  Value<DateTime?> documentsReturnedAt,
  Value<String?> documentsReturnedBy,
  Value<String?> signaturePath,
  Value<String?> signatureName,
  Value<DateTime?> signatureDate,
  Value<String?> userId,
  Value<String?> note,
  Value<int> rowid,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$RentoryDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$RentoryDatabase db) =>
      db.customers.createAlias('orders__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomerDiscountsTable _customerDiscountIdTable(
    _$RentoryDatabase db,
  ) => db.customerDiscounts.createAlias(
    'orders__customer_discount_id__customer_discounts__id',
  );

  $$CustomerDiscountsTableProcessedTableManager? get customerDiscountId {
    final $_column = $_itemColumn<String>('customer_discount_id');
    if ($_column == null) return null;
    final manager = $$CustomerDiscountsTableTableManager(
      $_db,
      $_db.customerDiscounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerDiscountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderDocumentsTable, List<OrderDocument>>
  _orderDocumentsRefsTable(_$RentoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderDocuments,
        aliasName: 'orders__id__order_documents__order_id',
      );

  $$OrderDocumentsTableProcessedTableManager get orderDocumentsRefs {
    final manager = $$OrderDocumentsTableTableManager(
      $_db,
      $_db.orderDocuments,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderDocumentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderLinesTable, List<OrderLine>>
  _orderLinesRefsTable(_$RentoryDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLines,
    aliasName: 'orders__id__order_lines__order_id',
  );

  $$OrderLinesTableProcessedTableManager get orderLinesRefs {
    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReturnChecksTable, List<ReturnCheck>>
  _returnChecksRefsTable(_$RentoryDatabase db) => MultiTypedResultKey.fromTable(
    db.returnChecks,
    aliasName: 'orders__id__return_checks__order_id',
  );

  $$ReturnChecksTableProcessedTableManager get returnChecksRefs {
    final manager = $$ReturnChecksTableTableManager(
      $_db,
      $_db.returnChecks,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$RentoryDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderState, OrderState, String> get state =>
      $composableBuilder(
        column: $table.state,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DiscountType, DiscountType, String>
  get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountDeposit => $composableBuilder(
    column: $table.amountDeposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lateFeeManual => $composableBuilder(
    column: $table.lateFeeManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lateDaysEdited => $composableBuilder(
    column: $table.lateDaysEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lateDaysOverride => $composableBuilder(
    column: $table.lateDaysOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sigRentalContract => $composableBuilder(
    column: $table.sigRentalContract,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sigPickupReturnReceipt => $composableBuilder(
    column: $table.sigPickupReturnReceipt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sigLoanContract => $composableBuilder(
    column: $table.sigLoanContract,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get itemsCaptured => $composableBuilder(
    column: $table.itemsCaptured,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get itemsExamined => $composableBuilder(
    column: $table.itemsExamined,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get itemsExaminedAt => $composableBuilder(
    column: $table.itemsExaminedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsExaminedBy => $composableBuilder(
    column: $table.itemsExaminedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get documentsReturnedAt => $composableBuilder(
    column: $table.documentsReturnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentsReturnedBy => $composableBuilder(
    column: $table.documentsReturnedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signatureName => $composableBuilder(
    column: $table.signatureName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signatureDate => $composableBuilder(
    column: $table.signatureDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomerDiscountsTableFilterComposer get customerDiscountId {
    final $$CustomerDiscountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerDiscountId,
      referencedTable: $db.customerDiscounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomerDiscountsTableFilterComposer(
            $db: $db,
            $table: $db.customerDiscounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderDocumentsRefs(
    Expression<bool> Function($$OrderDocumentsTableFilterComposer f) f,
  ) {
    final $$OrderDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderDocuments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.orderDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderLinesRefs(
    Expression<bool> Function($$OrderLinesTableFilterComposer f) f,
  ) {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnChecksRefs(
    Expression<bool> Function($$ReturnChecksTableFilterComposer f) f,
  ) {
    final $$ReturnChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableFilterComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$RentoryDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountDeposit => $composableBuilder(
    column: $table.amountDeposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lateFeeManual => $composableBuilder(
    column: $table.lateFeeManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lateDaysEdited => $composableBuilder(
    column: $table.lateDaysEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lateDaysOverride => $composableBuilder(
    column: $table.lateDaysOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sigRentalContract => $composableBuilder(
    column: $table.sigRentalContract,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sigPickupReturnReceipt => $composableBuilder(
    column: $table.sigPickupReturnReceipt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sigLoanContract => $composableBuilder(
    column: $table.sigLoanContract,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get itemsCaptured => $composableBuilder(
    column: $table.itemsCaptured,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get itemsExamined => $composableBuilder(
    column: $table.itemsExamined,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get itemsExaminedAt => $composableBuilder(
    column: $table.itemsExaminedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsExaminedBy => $composableBuilder(
    column: $table.itemsExaminedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get documentsReturnedAt => $composableBuilder(
    column: $table.documentsReturnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentsReturnedBy => $composableBuilder(
    column: $table.documentsReturnedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signatureName => $composableBuilder(
    column: $table.signatureName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signatureDate => $composableBuilder(
    column: $table.signatureDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomerDiscountsTableOrderingComposer get customerDiscountId {
    final $$CustomerDiscountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerDiscountId,
      referencedTable: $db.customerDiscounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomerDiscountsTableOrderingComposer(
            $db: $db,
            $table: $db.customerDiscounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateStart =>
      $composableBuilder(column: $table.dateStart, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DiscountType, String> get discountType =>
      $composableBuilder(
        column: $table.discountType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountDeposit => $composableBuilder(
    column: $table.amountDeposit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get lateFeeManual => $composableBuilder(
    column: $table.lateFeeManual,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get lateDaysEdited => $composableBuilder(
    column: $table.lateDaysEdited,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lateDaysOverride => $composableBuilder(
    column: $table.lateDaysOverride,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sigRentalContract => $composableBuilder(
    column: $table.sigRentalContract,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sigPickupReturnReceipt => $composableBuilder(
    column: $table.sigPickupReturnReceipt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sigLoanContract => $composableBuilder(
    column: $table.sigLoanContract,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get itemsCaptured => $composableBuilder(
    column: $table.itemsCaptured,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get itemsExamined => $composableBuilder(
    column: $table.itemsExamined,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get itemsExaminedAt => $composableBuilder(
    column: $table.itemsExaminedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsExaminedBy => $composableBuilder(
    column: $table.itemsExaminedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get documentsReturnedAt => $composableBuilder(
    column: $table.documentsReturnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentsReturnedBy => $composableBuilder(
    column: $table.documentsReturnedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signatureName => $composableBuilder(
    column: $table.signatureName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get signatureDate => $composableBuilder(
    column: $table.signatureDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomerDiscountsTableAnnotationComposer get customerDiscountId {
    final $$CustomerDiscountsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.customerDiscountId,
          referencedTable: $db.customerDiscounts,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomerDiscountsTableAnnotationComposer(
                $db: $db,
                $table: $db.customerDiscounts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> orderDocumentsRefs<T extends Object>(
    Expression<T> Function($$OrderDocumentsTableAnnotationComposer a) f,
  ) {
    final $$OrderDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderDocuments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderLinesRefs<T extends Object>(
    Expression<T> Function($$OrderLinesTableAnnotationComposer a) f,
  ) {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnChecksRefs<T extends Object>(
    Expression<T> Function($$ReturnChecksTableAnnotationComposer a) f,
  ) {
    final $$ReturnChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool customerId,
            bool customerDiscountId,
            bool orderDocumentsRefs,
            bool orderLinesRefs,
            bool returnChecksRefs,
          })
        > {
  $$OrdersTableTableManager(_$RentoryDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                Value<OrderState> state = const Value.absent(),
                Value<DiscountType> discountType = const Value.absent(),
                Value<double> discountValue = const Value.absent(),
                Value<String?> customerDiscountId = const Value.absent(),
                Value<double> amountDeposit = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<bool> lateFeeManual = const Value.absent(),
                Value<bool> lateDaysEdited = const Value.absent(),
                Value<int> lateDaysOverride = const Value.absent(),
                Value<bool> sigRentalContract = const Value.absent(),
                Value<bool> sigPickupReturnReceipt = const Value.absent(),
                Value<bool> sigLoanContract = const Value.absent(),
                Value<bool> itemsCaptured = const Value.absent(),
                Value<bool> itemsExamined = const Value.absent(),
                Value<DateTime?> itemsExaminedAt = const Value.absent(),
                Value<String?> itemsExaminedBy = const Value.absent(),
                Value<DateTime?> documentsReturnedAt = const Value.absent(),
                Value<String?> documentsReturnedBy = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String?> signatureName = const Value.absent(),
                Value<DateTime?> signatureDate = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                number: number,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                dateStart: dateStart,
                dateEnd: dateEnd,
                state: state,
                discountType: discountType,
                discountValue: discountValue,
                customerDiscountId: customerDiscountId,
                amountDeposit: amountDeposit,
                amountPaid: amountPaid,
                lateFeeManual: lateFeeManual,
                lateDaysEdited: lateDaysEdited,
                lateDaysOverride: lateDaysOverride,
                sigRentalContract: sigRentalContract,
                sigPickupReturnReceipt: sigPickupReturnReceipt,
                sigLoanContract: sigLoanContract,
                itemsCaptured: itemsCaptured,
                itemsExamined: itemsExamined,
                itemsExaminedAt: itemsExaminedAt,
                itemsExaminedBy: itemsExaminedBy,
                documentsReturnedAt: documentsReturnedAt,
                documentsReturnedBy: documentsReturnedBy,
                signaturePath: signaturePath,
                signatureName: signatureName,
                signatureDate: signatureDate,
                userId: userId,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String?> number = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                Value<OrderState> state = const Value.absent(),
                Value<DiscountType> discountType = const Value.absent(),
                Value<double> discountValue = const Value.absent(),
                Value<String?> customerDiscountId = const Value.absent(),
                Value<double> amountDeposit = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<bool> lateFeeManual = const Value.absent(),
                Value<bool> lateDaysEdited = const Value.absent(),
                Value<int> lateDaysOverride = const Value.absent(),
                Value<bool> sigRentalContract = const Value.absent(),
                Value<bool> sigPickupReturnReceipt = const Value.absent(),
                Value<bool> sigLoanContract = const Value.absent(),
                Value<bool> itemsCaptured = const Value.absent(),
                Value<bool> itemsExamined = const Value.absent(),
                Value<DateTime?> itemsExaminedAt = const Value.absent(),
                Value<String?> itemsExaminedBy = const Value.absent(),
                Value<DateTime?> documentsReturnedAt = const Value.absent(),
                Value<String?> documentsReturnedBy = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String?> signatureName = const Value.absent(),
                Value<DateTime?> signatureDate = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                number: number,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                dateStart: dateStart,
                dateEnd: dateEnd,
                state: state,
                discountType: discountType,
                discountValue: discountValue,
                customerDiscountId: customerDiscountId,
                amountDeposit: amountDeposit,
                amountPaid: amountPaid,
                lateFeeManual: lateFeeManual,
                lateDaysEdited: lateDaysEdited,
                lateDaysOverride: lateDaysOverride,
                sigRentalContract: sigRentalContract,
                sigPickupReturnReceipt: sigPickupReturnReceipt,
                sigLoanContract: sigLoanContract,
                itemsCaptured: itemsCaptured,
                itemsExamined: itemsExamined,
                itemsExaminedAt: itemsExaminedAt,
                itemsExaminedBy: itemsExaminedBy,
                documentsReturnedAt: documentsReturnedAt,
                documentsReturnedBy: documentsReturnedBy,
                signaturePath: signaturePath,
                signatureName: signatureName,
                signatureDate: signatureDate,
                userId: userId,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdersTable, Order>(table),
                  $$OrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                customerDiscountId = false,
                orderDocumentsRefs = false,
                orderLinesRefs = false,
                returnChecksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderDocumentsRefs) db.orderDocuments,
                    if (orderLinesRefs) db.orderLines,
                    if (returnChecksRefs) db.returnChecks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerId,
                            referencedTable: $$OrdersTableReferences
                                ._customerIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._customerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (customerDiscountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerDiscountId,
                            referencedTable: $$OrdersTableReferences
                                ._customerDiscountIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._customerDiscountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderDocumentsRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderDocument
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderLinesRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderLine
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnChecksRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          ReturnCheck
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._returnChecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).returnChecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool customerId,
        bool customerDiscountId,
        bool orderDocumentsRefs,
        bool orderLinesRefs,
        bool returnChecksRefs,
      })
    >;
typedef $$OrderDocumentsTableCreateCompanionBuilder =
    OrderDocumentsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      required String orderId,
      required String documentTypeId,
      Value<int> rowid,
    });
typedef $$OrderDocumentsTableUpdateCompanionBuilder =
    OrderDocumentsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      Value<String> orderId,
      Value<String> documentTypeId,
      Value<int> rowid,
    });

final class $$OrderDocumentsTableReferences
    extends
        BaseReferences<_$RentoryDatabase, $OrderDocumentsTable, OrderDocument> {
  $$OrderDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTable _orderIdTable(_$RentoryDatabase db) =>
      db.orders.createAlias('order_documents__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DocumentTypesTable _documentTypeIdTable(_$RentoryDatabase db) => db
      .documentTypes
      .createAlias('order_documents__document_type_id__document_types__id');

  $$DocumentTypesTableProcessedTableManager get documentTypeId {
    final $_column = $_itemColumn<String>('document_type_id')!;

    final manager = $$DocumentTypesTableTableManager(
      $_db,
      $_db.documentTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderDocumentsTableFilterComposer
    extends Composer<_$RentoryDatabase, $OrderDocumentsTable> {
  $$OrderDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentTypesTableFilterComposer get documentTypeId {
    final $$DocumentTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentTypeId,
      referencedTable: $db.documentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentTypesTableFilterComposer(
            $db: $db,
            $table: $db.documentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderDocumentsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $OrderDocumentsTable> {
  $$OrderDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentTypesTableOrderingComposer get documentTypeId {
    final $$DocumentTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentTypeId,
      referencedTable: $db.documentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentTypesTableOrderingComposer(
            $db: $db,
            $table: $db.documentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderDocumentsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $OrderDocumentsTable> {
  $$OrderDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentTypesTableAnnotationComposer get documentTypeId {
    final $$DocumentTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentTypeId,
      referencedTable: $db.documentTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.documentTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderDocumentsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $OrderDocumentsTable,
          OrderDocument,
          $$OrderDocumentsTableFilterComposer,
          $$OrderDocumentsTableOrderingComposer,
          $$OrderDocumentsTableAnnotationComposer,
          $$OrderDocumentsTableCreateCompanionBuilder,
          $$OrderDocumentsTableUpdateCompanionBuilder,
          (OrderDocument, $$OrderDocumentsTableReferences),
          OrderDocument,
          PrefetchHooks Function({bool orderId, bool documentTypeId})
        > {
  $$OrderDocumentsTableTableManager(
    _$RentoryDatabase db,
    $OrderDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> documentTypeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderDocumentsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                orderId: orderId,
                documentTypeId: documentTypeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String orderId,
                required String documentTypeId,
                Value<int> rowid = const Value.absent(),
              }) => OrderDocumentsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                orderId: orderId,
                documentTypeId: documentTypeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderDocumentsTable, OrderDocument>(table),
                  $$OrderDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, documentTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$OrderDocumentsTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$OrderDocumentsTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (documentTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentTypeId,
                        referencedTable: $$OrderDocumentsTableReferences
                            ._documentTypeIdTable(db),
                        referencedColumn: $$OrderDocumentsTableReferences
                            ._documentTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $OrderDocumentsTable,
      OrderDocument,
      $$OrderDocumentsTableFilterComposer,
      $$OrderDocumentsTableOrderingComposer,
      $$OrderDocumentsTableAnnotationComposer,
      $$OrderDocumentsTableCreateCompanionBuilder,
      $$OrderDocumentsTableUpdateCompanionBuilder,
      (OrderDocument, $$OrderDocumentsTableReferences),
      OrderDocument,
      PrefetchHooks Function({bool orderId, bool documentTypeId})
    >;
typedef $$OrderLinesTableCreateCompanionBuilder = OrderLinesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  required String orderId,
  Value<int> sequence,
  Value<LineType> lineType,
  Value<String?> assetId,
  Value<String> name,
  Value<double> quantity,
  Value<double> priceDay,
  Value<double> discount,
  Value<DateTime?> dateStart,
  Value<DateTime?> dateEnd,
  Value<RentalState> rentalState,
  Value<DateTime?> pickedUpAt,
  Value<String?> pickedUpBy,
  Value<DateTime?> returnedAt,
  Value<String?> returnedBy,
  Value<Condition> conditionOut,
  Value<Condition?> conditionIn,
  Value<String?> conditionNote,
  Value<int> rowid,
});
typedef $$OrderLinesTableUpdateCompanionBuilder = OrderLinesCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String> orderId,
  Value<int> sequence,
  Value<LineType> lineType,
  Value<String?> assetId,
  Value<String> name,
  Value<double> quantity,
  Value<double> priceDay,
  Value<double> discount,
  Value<DateTime?> dateStart,
  Value<DateTime?> dateEnd,
  Value<RentalState> rentalState,
  Value<DateTime?> pickedUpAt,
  Value<String?> pickedUpBy,
  Value<DateTime?> returnedAt,
  Value<String?> returnedBy,
  Value<Condition> conditionOut,
  Value<Condition?> conditionIn,
  Value<String?> conditionNote,
  Value<int> rowid,
});

final class $$OrderLinesTableReferences
    extends BaseReferences<_$RentoryDatabase, $OrderLinesTable, OrderLine> {
  $$OrderLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$RentoryDatabase db) =>
      db.orders.createAlias('order_lines__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetsTable _assetIdTable(_$RentoryDatabase db) =>
      db.assets.createAlias('order_lines__asset_id__assets__id');

  $$AssetsTableProcessedTableManager? get assetId {
    final $_column = $_itemColumn<String>('asset_id');
    if ($_column == null) return null;
    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderLineSerialsTable, List<OrderLineSerial>>
  _orderLineSerialsRefsTable(_$RentoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderLineSerials,
        aliasName: 'order_lines__id__order_line_serials__line_id',
      );

  $$OrderLineSerialsTableProcessedTableManager get orderLineSerialsRefs {
    final manager = $$OrderLineSerialsTableTableManager(
      $_db,
      $_db.orderLineSerials,
    ).filter((f) => f.lineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderLineSerialsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReturnChecksTable, List<ReturnCheck>>
  _returnChecksRefsTable(_$RentoryDatabase db) => MultiTypedResultKey.fromTable(
    db.returnChecks,
    aliasName: 'order_lines__id__return_checks__line_id',
  );

  $$ReturnChecksTableProcessedTableManager get returnChecksRefs {
    final manager = $$ReturnChecksTableTableManager(
      $_db,
      $_db.returnChecks,
    ).filter((f) => f.lineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderLinesTableFilterComposer
    extends Composer<_$RentoryDatabase, $OrderLinesTable> {
  $$OrderLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LineType, LineType, String> get lineType =>
      $composableBuilder(
        column: $table.lineType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceDay => $composableBuilder(
    column: $table.priceDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RentalState, RentalState, String>
  get rentalState => $composableBuilder(
    column: $table.rentalState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get pickedUpAt => $composableBuilder(
    column: $table.pickedUpAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pickedUpBy => $composableBuilder(
    column: $table.pickedUpBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Condition, Condition, String>
  get conditionOut => $composableBuilder(
    column: $table.conditionOut,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Condition?, Condition, String>
  get conditionIn => $composableBuilder(
    column: $table.conditionIn,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get conditionNote => $composableBuilder(
    column: $table.conditionNote,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderLineSerialsRefs(
    Expression<bool> Function($$OrderLineSerialsTableFilterComposer f) f,
  ) {
    final $$OrderLineSerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineSerials,
      getReferencedColumn: (t) => t.lineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineSerialsTableFilterComposer(
            $db: $db,
            $table: $db.orderLineSerials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> returnChecksRefs(
    Expression<bool> Function($$ReturnChecksTableFilterComposer f) f,
  ) {
    final $$ReturnChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.lineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableFilterComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderLinesTableOrderingComposer
    extends Composer<_$RentoryDatabase, $OrderLinesTable> {
  $$OrderLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineType => $composableBuilder(
    column: $table.lineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceDay => $composableBuilder(
    column: $table.priceDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rentalState => $composableBuilder(
    column: $table.rentalState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pickedUpAt => $composableBuilder(
    column: $table.pickedUpAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pickedUpBy => $composableBuilder(
    column: $table.pickedUpBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionOut => $composableBuilder(
    column: $table.conditionOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionIn => $composableBuilder(
    column: $table.conditionIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionNote => $composableBuilder(
    column: $table.conditionNote,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableOrderingComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $OrderLinesTable> {
  $$OrderLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LineType, String> get lineType =>
      $composableBuilder(column: $table.lineType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceDay =>
      $composableBuilder(column: $table.priceDay, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<DateTime> get dateStart =>
      $composableBuilder(column: $table.dateStart, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RentalState, String> get rentalState =>
      $composableBuilder(
        column: $table.rentalState,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get pickedUpAt => $composableBuilder(
    column: $table.pickedUpAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pickedUpBy => $composableBuilder(
    column: $table.pickedUpBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Condition, String> get conditionOut =>
      $composableBuilder(
        column: $table.conditionOut,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Condition?, String> get conditionIn =>
      $composableBuilder(
        column: $table.conditionIn,
        builder: (column) => column,
      );

  GeneratedColumn<String> get conditionNote => $composableBuilder(
    column: $table.conditionNote,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetId,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderLineSerialsRefs<T extends Object>(
    Expression<T> Function($$OrderLineSerialsTableAnnotationComposer a) f,
  ) {
    final $$OrderLineSerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLineSerials,
      getReferencedColumn: (t) => t.lineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLineSerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLineSerials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> returnChecksRefs<T extends Object>(
    Expression<T> Function($$ReturnChecksTableAnnotationComposer a) f,
  ) {
    final $$ReturnChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.returnChecks,
      getReferencedColumn: (t) => t.lineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReturnChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.returnChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderLinesTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $OrderLinesTable,
          OrderLine,
          $$OrderLinesTableFilterComposer,
          $$OrderLinesTableOrderingComposer,
          $$OrderLinesTableAnnotationComposer,
          $$OrderLinesTableCreateCompanionBuilder,
          $$OrderLinesTableUpdateCompanionBuilder,
          (OrderLine, $$OrderLinesTableReferences),
          OrderLine,
          PrefetchHooks Function({
            bool orderId,
            bool assetId,
            bool orderLineSerialsRefs,
            bool returnChecksRefs,
          })
        > {
  $$OrderLinesTableTableManager(_$RentoryDatabase db, $OrderLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<LineType> lineType = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> priceDay = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                Value<RentalState> rentalState = const Value.absent(),
                Value<DateTime?> pickedUpAt = const Value.absent(),
                Value<String?> pickedUpBy = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> returnedBy = const Value.absent(),
                Value<Condition> conditionOut = const Value.absent(),
                Value<Condition?> conditionIn = const Value.absent(),
                Value<String?> conditionNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLinesCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                orderId: orderId,
                sequence: sequence,
                lineType: lineType,
                assetId: assetId,
                name: name,
                quantity: quantity,
                priceDay: priceDay,
                discount: discount,
                dateStart: dateStart,
                dateEnd: dateEnd,
                rentalState: rentalState,
                pickedUpAt: pickedUpAt,
                pickedUpBy: pickedUpBy,
                returnedAt: returnedAt,
                returnedBy: returnedBy,
                conditionOut: conditionOut,
                conditionIn: conditionIn,
                conditionNote: conditionNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String orderId,
                Value<int> sequence = const Value.absent(),
                Value<LineType> lineType = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> priceDay = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                Value<RentalState> rentalState = const Value.absent(),
                Value<DateTime?> pickedUpAt = const Value.absent(),
                Value<String?> pickedUpBy = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> returnedBy = const Value.absent(),
                Value<Condition> conditionOut = const Value.absent(),
                Value<Condition?> conditionIn = const Value.absent(),
                Value<String?> conditionNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLinesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                orderId: orderId,
                sequence: sequence,
                lineType: lineType,
                assetId: assetId,
                name: name,
                quantity: quantity,
                priceDay: priceDay,
                discount: discount,
                dateStart: dateStart,
                dateEnd: dateEnd,
                rentalState: rentalState,
                pickedUpAt: pickedUpAt,
                pickedUpBy: pickedUpBy,
                returnedAt: returnedAt,
                returnedBy: returnedBy,
                conditionOut: conditionOut,
                conditionIn: conditionIn,
                conditionNote: conditionNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderLinesTable, OrderLine>(table),
                  $$OrderLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                orderId = false,
                assetId = false,
                orderLineSerialsRefs = false,
                returnChecksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderLineSerialsRefs) db.orderLineSerials,
                    if (returnChecksRefs) db.returnChecks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.orderId,
                            referencedTable: $$OrderLinesTableReferences
                                ._orderIdTable(db),
                            referencedColumn: $$OrderLinesTableReferences
                                ._orderIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (assetId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.assetId,
                            referencedTable: $$OrderLinesTableReferences
                                ._assetIdTable(db),
                            referencedColumn: $$OrderLinesTableReferences
                                ._assetIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderLineSerialsRefs)
                        await $_getPrefetchedData<
                          OrderLine,
                          $OrderLinesTable,
                          OrderLineSerial
                        >(
                          currentTable: table,
                          referencedTable: $$OrderLinesTableReferences
                              ._orderLineSerialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderLinesTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLineSerialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (returnChecksRefs)
                        await $_getPrefetchedData<
                          OrderLine,
                          $OrderLinesTable,
                          ReturnCheck
                        >(
                          currentTable: table,
                          referencedTable: $$OrderLinesTableReferences
                              ._returnChecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderLinesTableReferences(
                                db,
                                table,
                                p0,
                              ).returnChecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrderLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $OrderLinesTable,
      OrderLine,
      $$OrderLinesTableFilterComposer,
      $$OrderLinesTableOrderingComposer,
      $$OrderLinesTableAnnotationComposer,
      $$OrderLinesTableCreateCompanionBuilder,
      $$OrderLinesTableUpdateCompanionBuilder,
      (OrderLine, $$OrderLinesTableReferences),
      OrderLine,
      PrefetchHooks Function({
        bool orderId,
        bool assetId,
        bool orderLineSerialsRefs,
        bool returnChecksRefs,
      })
    >;
typedef $$OrderLineSerialsTableCreateCompanionBuilder =
    OrderLineSerialsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      required String lineId,
      required String serialId,
      Value<int> rowid,
    });
typedef $$OrderLineSerialsTableUpdateCompanionBuilder =
    OrderLineSerialsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      Value<String> lineId,
      Value<String> serialId,
      Value<int> rowid,
    });

final class $$OrderLineSerialsTableReferences
    extends
        BaseReferences<
          _$RentoryDatabase,
          $OrderLineSerialsTable,
          OrderLineSerial
        > {
  $$OrderLineSerialsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderLinesTable _lineIdTable(_$RentoryDatabase db) =>
      db.orderLines.createAlias('order_line_serials__line_id__order_lines__id');

  $$OrderLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<String>('line_id')!;

    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SerialsTable _serialIdTable(_$RentoryDatabase db) =>
      db.serials.createAlias('order_line_serials__serial_id__serials__id');

  $$SerialsTableProcessedTableManager get serialId {
    final $_column = $_itemColumn<String>('serial_id')!;

    final manager = $$SerialsTableTableManager(
      $_db,
      $_db.serials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderLineSerialsTableFilterComposer
    extends Composer<_$RentoryDatabase, $OrderLineSerialsTable> {
  $$OrderLineSerialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderLinesTableFilterComposer get lineId {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableFilterComposer get serialId {
    final $$SerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableFilterComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLineSerialsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $OrderLineSerialsTable> {
  $$OrderLineSerialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderLinesTableOrderingComposer get lineId {
    final $$OrderLinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableOrderingComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableOrderingComposer get serialId {
    final $$SerialsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableOrderingComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLineSerialsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $OrderLineSerialsTable> {
  $$OrderLineSerialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  $$OrderLinesTableAnnotationComposer get lineId {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableAnnotationComposer get serialId {
    final $$SerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLineSerialsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $OrderLineSerialsTable,
          OrderLineSerial,
          $$OrderLineSerialsTableFilterComposer,
          $$OrderLineSerialsTableOrderingComposer,
          $$OrderLineSerialsTableAnnotationComposer,
          $$OrderLineSerialsTableCreateCompanionBuilder,
          $$OrderLineSerialsTableUpdateCompanionBuilder,
          (OrderLineSerial, $$OrderLineSerialsTableReferences),
          OrderLineSerial,
          PrefetchHooks Function({bool lineId, bool serialId})
        > {
  $$OrderLineSerialsTableTableManager(
    _$RentoryDatabase db,
    $OrderLineSerialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderLineSerialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderLineSerialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderLineSerialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> lineId = const Value.absent(),
                Value<String> serialId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLineSerialsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                lineId: lineId,
                serialId: serialId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String lineId,
                required String serialId,
                Value<int> rowid = const Value.absent(),
              }) => OrderLineSerialsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                lineId: lineId,
                serialId: serialId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderLineSerialsTable, OrderLineSerial>(table),
                  $$OrderLineSerialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lineId = false, serialId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lineId,
                        referencedTable: $$OrderLineSerialsTableReferences
                            ._lineIdTable(db),
                        referencedColumn: $$OrderLineSerialsTableReferences
                            ._lineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (serialId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.serialId,
                        referencedTable: $$OrderLineSerialsTableReferences
                            ._serialIdTable(db),
                        referencedColumn: $$OrderLineSerialsTableReferences
                            ._serialIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderLineSerialsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $OrderLineSerialsTable,
      OrderLineSerial,
      $$OrderLineSerialsTableFilterComposer,
      $$OrderLineSerialsTableOrderingComposer,
      $$OrderLineSerialsTableAnnotationComposer,
      $$OrderLineSerialsTableCreateCompanionBuilder,
      $$OrderLineSerialsTableUpdateCompanionBuilder,
      (OrderLineSerial, $$OrderLineSerialsTableReferences),
      OrderLineSerial,
      PrefetchHooks Function({bool lineId, bool serialId})
    >;
typedef $$ReturnChecksTableCreateCompanionBuilder =
    ReturnChecksCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      required String lineId,
      required String orderId,
      Value<String?> serialId,
      Value<Condition> condition,
      Value<String?> note,
      required DateTime returnedAt,
      Value<String?> returnedBy,
      Value<int> rowid,
    });
typedef $$ReturnChecksTableUpdateCompanionBuilder =
    ReturnChecksCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<bool> dirty,
      Value<int?> odooId,
      Value<String> lineId,
      Value<String> orderId,
      Value<String?> serialId,
      Value<Condition> condition,
      Value<String?> note,
      Value<DateTime> returnedAt,
      Value<String?> returnedBy,
      Value<int> rowid,
    });

final class $$ReturnChecksTableReferences
    extends BaseReferences<_$RentoryDatabase, $ReturnChecksTable, ReturnCheck> {
  $$ReturnChecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrderLinesTable _lineIdTable(_$RentoryDatabase db) =>
      db.orderLines.createAlias('return_checks__line_id__order_lines__id');

  $$OrderLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<String>('line_id')!;

    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrdersTable _orderIdTable(_$RentoryDatabase db) =>
      db.orders.createAlias('return_checks__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SerialsTable _serialIdTable(_$RentoryDatabase db) =>
      db.serials.createAlias('return_checks__serial_id__serials__id');

  $$SerialsTableProcessedTableManager? get serialId {
    final $_column = $_itemColumn<String>('serial_id');
    if ($_column == null) return null;
    final manager = $$SerialsTableTableManager(
      $_db,
      $_db.serials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReturnChecksTableFilterComposer
    extends Composer<_$RentoryDatabase, $ReturnChecksTable> {
  $$ReturnChecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Condition, Condition, String> get condition =>
      $composableBuilder(
        column: $table.condition,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderLinesTableFilterComposer get lineId {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableFilterComposer get serialId {
    final $$SerialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableFilterComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnChecksTableOrderingComposer
    extends Composer<_$RentoryDatabase, $ReturnChecksTable> {
  $$ReturnChecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderLinesTableOrderingComposer get lineId {
    final $$OrderLinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableOrderingComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableOrderingComposer get serialId {
    final $$SerialsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableOrderingComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnChecksTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $ReturnChecksTable> {
  $$ReturnChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Condition, String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get returnedBy => $composableBuilder(
    column: $table.returnedBy,
    builder: (column) => column,
  );

  $$OrderLinesTableAnnotationComposer get lineId {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lineId,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SerialsTableAnnotationComposer get serialId {
    final $$SerialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serialId,
      referencedTable: $db.serials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SerialsTableAnnotationComposer(
            $db: $db,
            $table: $db.serials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReturnChecksTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $ReturnChecksTable,
          ReturnCheck,
          $$ReturnChecksTableFilterComposer,
          $$ReturnChecksTableOrderingComposer,
          $$ReturnChecksTableAnnotationComposer,
          $$ReturnChecksTableCreateCompanionBuilder,
          $$ReturnChecksTableUpdateCompanionBuilder,
          (ReturnCheck, $$ReturnChecksTableReferences),
          ReturnCheck,
          PrefetchHooks Function({bool lineId, bool orderId, bool serialId})
        > {
  $$ReturnChecksTableTableManager(
    _$RentoryDatabase db,
    $ReturnChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String> lineId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String?> serialId = const Value.absent(),
                Value<Condition> condition = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> returnedAt = const Value.absent(),
                Value<String?> returnedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnChecksCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                lineId: lineId,
                orderId: orderId,
                serialId: serialId,
                condition: condition,
                note: note,
                returnedAt: returnedAt,
                returnedBy: returnedBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                required String lineId,
                required String orderId,
                Value<String?> serialId = const Value.absent(),
                Value<Condition> condition = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime returnedAt,
                Value<String?> returnedBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnChecksCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                lineId: lineId,
                orderId: orderId,
                serialId: serialId,
                condition: condition,
                note: note,
                returnedAt: returnedAt,
                returnedBy: returnedBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReturnChecksTable, ReturnCheck>(table),
                  $$ReturnChecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({lineId = false, orderId = false, serialId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (lineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.lineId,
                            referencedTable: $$ReturnChecksTableReferences
                                ._lineIdTable(db),
                            referencedColumn: $$ReturnChecksTableReferences
                                ._lineIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (orderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.orderId,
                            referencedTable: $$ReturnChecksTableReferences
                                ._orderIdTable(db),
                            referencedColumn: $$ReturnChecksTableReferences
                                ._orderIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (serialId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.serialId,
                            referencedTable: $$ReturnChecksTableReferences
                                ._serialIdTable(db),
                            referencedColumn: $$ReturnChecksTableReferences
                                ._serialIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ReturnChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $ReturnChecksTable,
      ReturnCheck,
      $$ReturnChecksTableFilterComposer,
      $$ReturnChecksTableOrderingComposer,
      $$ReturnChecksTableAnnotationComposer,
      $$ReturnChecksTableCreateCompanionBuilder,
      $$ReturnChecksTableUpdateCompanionBuilder,
      (ReturnCheck, $$ReturnChecksTableReferences),
      ReturnCheck,
      PrefetchHooks Function({bool lineId, bool orderId, bool serialId})
    >;
typedef $$PhotosTableCreateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String?> assetId,
  Value<String?> serialId,
  Value<String?> orderId,
  Value<String?> lineId,
  Value<String?> storagePath,
  Value<String?> localPath,
  Value<DateTime> takenAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$PhotosTableUpdateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<int?> odooId,
  Value<String?> assetId,
  Value<String?> serialId,
  Value<String?> orderId,
  Value<String?> lineId,
  Value<String?> storagePath,
  Value<String?> localPath,
  Value<DateTime> takenAt,
  Value<String?> note,
  Value<int> rowid,
});

class $$PhotosTableFilterComposer
    extends Composer<_$RentoryDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialId => $composableBuilder(
    column: $table.serialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PhotosTableOrderingComposer
    extends Composer<_$RentoryDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odooId => $composableBuilder(
    column: $table.odooId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialId => $composableBuilder(
    column: $table.serialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<int> get odooId =>
      $composableBuilder(column: $table.odooId, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get serialId =>
      $composableBuilder(column: $table.serialId, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, BaseReferences<_$RentoryDatabase, $PhotosTable, Photo>),
          Photo,
          PrefetchHooks Function()
        > {
  $$PhotosTableTableManager(_$RentoryDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String?> serialId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String?> lineId = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                assetId: assetId,
                serialId: serialId,
                orderId: orderId,
                lineId: lineId,
                storagePath: storagePath,
                localPath: localPath,
                takenAt: takenAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int?> odooId = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String?> serialId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String?> lineId = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                dirty: dirty,
                odooId: odooId,
                assetId: assetId,
                serialId: serialId,
                orderId: orderId,
                lineId: lineId,
                storagePath: storagePath,
                localPath: localPath,
                takenAt: takenAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhotosTable, Photo>(table),
                  BaseReferences<_$RentoryDatabase, $PhotosTable, Photo>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, BaseReferences<_$RentoryDatabase, $PhotosTable, Photo>),
      Photo,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String tableName_,
      Value<int> serverSeq,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> tableName_,
      Value<int> serverSeq,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$RentoryDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$RentoryDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$RentoryDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$RentoryDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$RentoryDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$RentoryDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tableName_ = const Value.absent(),
                Value<int> serverSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                tableName_: tableName_,
                serverSeq: serverSeq,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tableName_,
                Value<int> serverSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                tableName_: tableName_,
                serverSeq: serverSeq,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCursorsTable, SyncCursor>(table),
                  BaseReferences<
                    _$RentoryDatabase,
                    $SyncCursorsTable,
                    SyncCursor
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$RentoryDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$RentoryDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;

class $RentoryDatabaseManager {
  final _$RentoryDatabase _db;
  $RentoryDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$DocumentTypesTableTableManager get documentTypes =>
      $$DocumentTypesTableTableManager(_db, _db.documentTypes);
  $$CustomerDiscountsTableTableManager get customerDiscounts =>
      $$CustomerDiscountsTableTableManager(_db, _db.customerDiscounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$SerialsTableTableManager get serials =>
      $$SerialsTableTableManager(_db, _db.serials);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderDocumentsTableTableManager get orderDocuments =>
      $$OrderDocumentsTableTableManager(_db, _db.orderDocuments);
  $$OrderLinesTableTableManager get orderLines =>
      $$OrderLinesTableTableManager(_db, _db.orderLines);
  $$OrderLineSerialsTableTableManager get orderLineSerials =>
      $$OrderLineSerialsTableTableManager(_db, _db.orderLineSerials);
  $$ReturnChecksTableTableManager get returnChecks =>
      $$ReturnChecksTableTableManager(_db, _db.returnChecks);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
}
