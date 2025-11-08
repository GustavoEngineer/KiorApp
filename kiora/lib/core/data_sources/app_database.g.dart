// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importanciaMeta = const VerificationMeta(
    'importancia',
  );
  @override
  late final GeneratedColumn<int> importancia = GeneratedColumn<int>(
    'importancia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    importancia,
    needsSync,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('importancia')) {
      context.handle(
        _importanciaMeta,
        importancia.isAcceptableOrUnknown(
          data['importancia']!,
          _importanciaMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      importancia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}importancia'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final int importancia;
  final bool needsSync;
  final DateTime? lastSyncAt;
  const Categoria({
    required this.id,
    required this.nombre,
    required this.importancia,
    required this.needsSync,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['importancia'] = Variable<int>(importancia);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      importancia: Value(importancia),
      needsSync: Value(needsSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      importancia: serializer.fromJson<int>(json['importancia']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'importancia': serializer.toJson<int>(importancia),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    int? importancia,
    bool? needsSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => Categoria(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    importancia: importancia ?? this.importancia,
    needsSync: needsSync ?? this.needsSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      importancia: data.importancia.present
          ? data.importancia.value
          : this.importancia,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('importancia: $importancia, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, importancia, needsSync, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.importancia == this.importancia &&
          other.needsSync == this.needsSync &&
          other.lastSyncAt == this.lastSyncAt);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> importancia;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncAt;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.importancia = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.importancia = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? importancia,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (importancia != null) 'importancia': importancia,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? importancia,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncAt,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      importancia: importancia ?? this.importancia,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (importancia.present) {
      map['importancia'] = Variable<int>(importancia.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('importancia: $importancia, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $TareasTable extends Tareas with TableInfo<$TareasTable, Tarea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TareasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _fechaLimiteMeta = const VerificationMeta(
    'fechaLimite',
  );
  @override
  late final GeneratedColumn<DateTime> fechaLimite = GeneratedColumn<DateTime>(
    'fecha_limite',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracionEstimadaMeta = const VerificationMeta(
    'duracionEstimada',
  );
  @override
  late final GeneratedColumn<double> duracionEstimada = GeneratedColumn<double>(
    'duracion_estimada',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _completadaMeta = const VerificationMeta(
    'completada',
  );
  @override
  late final GeneratedColumn<bool> completada = GeneratedColumn<bool>(
    'completada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _prioridadScoreMeta = const VerificationMeta(
    'prioridadScore',
  );
  @override
  late final GeneratedColumn<double> prioridadScore = GeneratedColumn<double>(
    'prioridad_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titulo,
    categoriaId,
    fechaLimite,
    duracionEstimada,
    completada,
    prioridadScore,
    creadaEn,
    needsSync,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tareas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tarea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('fecha_limite')) {
      context.handle(
        _fechaLimiteMeta,
        fechaLimite.isAcceptableOrUnknown(
          data['fecha_limite']!,
          _fechaLimiteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaLimiteMeta);
    }
    if (data.containsKey('duracion_estimada')) {
      context.handle(
        _duracionEstimadaMeta,
        duracionEstimada.isAcceptableOrUnknown(
          data['duracion_estimada']!,
          _duracionEstimadaMeta,
        ),
      );
    }
    if (data.containsKey('completada')) {
      context.handle(
        _completadaMeta,
        completada.isAcceptableOrUnknown(data['completada']!, _completadaMeta),
      );
    }
    if (data.containsKey('prioridad_score')) {
      context.handle(
        _prioridadScoreMeta,
        prioridadScore.isAcceptableOrUnknown(
          data['prioridad_score']!,
          _prioridadScoreMeta,
        ),
      );
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tarea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tarea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      fechaLimite: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_limite'],
      )!,
      duracionEstimada: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duracion_estimada'],
      )!,
      completada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completada'],
      )!,
      prioridadScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prioridad_score'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $TareasTable createAlias(String alias) {
    return $TareasTable(attachedDatabase, alias);
  }
}

class Tarea extends DataClass implements Insertable<Tarea> {
  final int id;
  final String titulo;
  final int categoriaId;
  final DateTime fechaLimite;
  final double duracionEstimada;
  final bool completada;
  final double prioridadScore;
  final DateTime creadaEn;
  final bool needsSync;
  final DateTime? lastSyncAt;
  const Tarea({
    required this.id,
    required this.titulo,
    required this.categoriaId,
    required this.fechaLimite,
    required this.duracionEstimada,
    required this.completada,
    required this.prioridadScore,
    required this.creadaEn,
    required this.needsSync,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['fecha_limite'] = Variable<DateTime>(fechaLimite);
    map['duracion_estimada'] = Variable<double>(duracionEstimada);
    map['completada'] = Variable<bool>(completada);
    map['prioridad_score'] = Variable<double>(prioridadScore);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  TareasCompanion toCompanion(bool nullToAbsent) {
    return TareasCompanion(
      id: Value(id),
      titulo: Value(titulo),
      categoriaId: Value(categoriaId),
      fechaLimite: Value(fechaLimite),
      duracionEstimada: Value(duracionEstimada),
      completada: Value(completada),
      prioridadScore: Value(prioridadScore),
      creadaEn: Value(creadaEn),
      needsSync: Value(needsSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory Tarea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tarea(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      fechaLimite: serializer.fromJson<DateTime>(json['fechaLimite']),
      duracionEstimada: serializer.fromJson<double>(json['duracionEstimada']),
      completada: serializer.fromJson<bool>(json['completada']),
      prioridadScore: serializer.fromJson<double>(json['prioridadScore']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'fechaLimite': serializer.toJson<DateTime>(fechaLimite),
      'duracionEstimada': serializer.toJson<double>(duracionEstimada),
      'completada': serializer.toJson<bool>(completada),
      'prioridadScore': serializer.toJson<double>(prioridadScore),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
      'needsSync': serializer.toJson<bool>(needsSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  Tarea copyWith({
    int? id,
    String? titulo,
    int? categoriaId,
    DateTime? fechaLimite,
    double? duracionEstimada,
    bool? completada,
    double? prioridadScore,
    DateTime? creadaEn,
    bool? needsSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => Tarea(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    categoriaId: categoriaId ?? this.categoriaId,
    fechaLimite: fechaLimite ?? this.fechaLimite,
    duracionEstimada: duracionEstimada ?? this.duracionEstimada,
    completada: completada ?? this.completada,
    prioridadScore: prioridadScore ?? this.prioridadScore,
    creadaEn: creadaEn ?? this.creadaEn,
    needsSync: needsSync ?? this.needsSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  Tarea copyWithCompanion(TareasCompanion data) {
    return Tarea(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      fechaLimite: data.fechaLimite.present
          ? data.fechaLimite.value
          : this.fechaLimite,
      duracionEstimada: data.duracionEstimada.present
          ? data.duracionEstimada.value
          : this.duracionEstimada,
      completada: data.completada.present
          ? data.completada.value
          : this.completada,
      prioridadScore: data.prioridadScore.present
          ? data.prioridadScore.value
          : this.prioridadScore,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tarea(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('fechaLimite: $fechaLimite, ')
          ..write('duracionEstimada: $duracionEstimada, ')
          ..write('completada: $completada, ')
          ..write('prioridadScore: $prioridadScore, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    categoriaId,
    fechaLimite,
    duracionEstimada,
    completada,
    prioridadScore,
    creadaEn,
    needsSync,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tarea &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.categoriaId == this.categoriaId &&
          other.fechaLimite == this.fechaLimite &&
          other.duracionEstimada == this.duracionEstimada &&
          other.completada == this.completada &&
          other.prioridadScore == this.prioridadScore &&
          other.creadaEn == this.creadaEn &&
          other.needsSync == this.needsSync &&
          other.lastSyncAt == this.lastSyncAt);
}

class TareasCompanion extends UpdateCompanion<Tarea> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<int> categoriaId;
  final Value<DateTime> fechaLimite;
  final Value<double> duracionEstimada;
  final Value<bool> completada;
  final Value<double> prioridadScore;
  final Value<DateTime> creadaEn;
  final Value<bool> needsSync;
  final Value<DateTime?> lastSyncAt;
  const TareasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.fechaLimite = const Value.absent(),
    this.duracionEstimada = const Value.absent(),
    this.completada = const Value.absent(),
    this.prioridadScore = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  TareasCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required int categoriaId,
    required DateTime fechaLimite,
    this.duracionEstimada = const Value.absent(),
    this.completada = const Value.absent(),
    this.prioridadScore = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : titulo = Value(titulo),
       categoriaId = Value(categoriaId),
       fechaLimite = Value(fechaLimite);
  static Insertable<Tarea> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<int>? categoriaId,
    Expression<DateTime>? fechaLimite,
    Expression<double>? duracionEstimada,
    Expression<bool>? completada,
    Expression<double>? prioridadScore,
    Expression<DateTime>? creadaEn,
    Expression<bool>? needsSync,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (fechaLimite != null) 'fecha_limite': fechaLimite,
      if (duracionEstimada != null) 'duracion_estimada': duracionEstimada,
      if (completada != null) 'completada': completada,
      if (prioridadScore != null) 'prioridad_score': prioridadScore,
      if (creadaEn != null) 'creada_en': creadaEn,
      if (needsSync != null) 'needs_sync': needsSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  TareasCompanion copyWith({
    Value<int>? id,
    Value<String>? titulo,
    Value<int>? categoriaId,
    Value<DateTime>? fechaLimite,
    Value<double>? duracionEstimada,
    Value<bool>? completada,
    Value<double>? prioridadScore,
    Value<DateTime>? creadaEn,
    Value<bool>? needsSync,
    Value<DateTime?>? lastSyncAt,
  }) {
    return TareasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      categoriaId: categoriaId ?? this.categoriaId,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      completada: completada ?? this.completada,
      prioridadScore: prioridadScore ?? this.prioridadScore,
      creadaEn: creadaEn ?? this.creadaEn,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (fechaLimite.present) {
      map['fecha_limite'] = Variable<DateTime>(fechaLimite.value);
    }
    if (duracionEstimada.present) {
      map['duracion_estimada'] = Variable<double>(duracionEstimada.value);
    }
    if (completada.present) {
      map['completada'] = Variable<bool>(completada.value);
    }
    if (prioridadScore.present) {
      map['prioridad_score'] = Variable<double>(prioridadScore.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TareasCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('fechaLimite: $fechaLimite, ')
          ..write('duracionEstimada: $duracionEstimada, ')
          ..write('completada: $completada, ')
          ..write('prioridadScore: $prioridadScore, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('needsSync: $needsSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $TareasTable tareas = $TareasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categorias, tareas];
}

typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      required String nombre,
      Value<int> importancia,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> importancia,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TareasTable, List<Tarea>> _tareasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tareas,
    aliasName: $_aliasNameGenerator(db.categorias.id, db.tareas.categoriaId),
  );

  $$TareasTableProcessedTableManager get tareasRefs {
    final manager = $$TareasTableTableManager(
      $_db,
      $_db.tareas,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tareasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importancia => $composableBuilder(
    column: $table.importancia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tareasRefs(
    Expression<bool> Function($$TareasTableFilterComposer f) f,
  ) {
    final $$TareasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tareas,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TareasTableFilterComposer(
            $db: $db,
            $table: $db.tareas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importancia => $composableBuilder(
    column: $table.importancia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get importancia => $composableBuilder(
    column: $table.importancia,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> tareasRefs<T extends Object>(
    Expression<T> Function($$TareasTableAnnotationComposer a) f,
  ) {
    final $$TareasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tareas,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TareasTableAnnotationComposer(
            $db: $db,
            $table: $db.tareas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({bool tareasRefs})
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> importancia = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                importancia: importancia,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<int> importancia = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                importancia: importancia,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tareasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tareasRefs) db.tareas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tareasRefs)
                    await $_getPrefetchedData<
                      Categoria,
                      $CategoriasTable,
                      Tarea
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasTableReferences
                          ._tareasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriasTableReferences(db, table, p0).tareasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
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

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({bool tareasRefs})
    >;
typedef $$TareasTableCreateCompanionBuilder =
    TareasCompanion Function({
      Value<int> id,
      required String titulo,
      required int categoriaId,
      required DateTime fechaLimite,
      Value<double> duracionEstimada,
      Value<bool> completada,
      Value<double> prioridadScore,
      Value<DateTime> creadaEn,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
    });
typedef $$TareasTableUpdateCompanionBuilder =
    TareasCompanion Function({
      Value<int> id,
      Value<String> titulo,
      Value<int> categoriaId,
      Value<DateTime> fechaLimite,
      Value<double> duracionEstimada,
      Value<bool> completada,
      Value<double> prioridadScore,
      Value<DateTime> creadaEn,
      Value<bool> needsSync,
      Value<DateTime?> lastSyncAt,
    });

final class $$TareasTableReferences
    extends BaseReferences<_$AppDatabase, $TareasTable, Tarea> {
  $$TareasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
        $_aliasNameGenerator(db.tareas.categoriaId, db.categorias.id),
      );

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TareasTableFilterComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get duracionEstimada => $composableBuilder(
    column: $table.duracionEstimada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prioridadScore => $composableBuilder(
    column: $table.prioridadScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TareasTableOrderingComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get duracionEstimada => $composableBuilder(
    column: $table.duracionEstimada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prioridadScore => $composableBuilder(
    column: $table.prioridadScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TareasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaLimite => $composableBuilder(
    column: $table.fechaLimite,
    builder: (column) => column,
  );

  GeneratedColumn<double> get duracionEstimada => $composableBuilder(
    column: $table.duracionEstimada,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => column,
  );

  GeneratedColumn<double> get prioridadScore => $composableBuilder(
    column: $table.prioridadScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TareasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TareasTable,
          Tarea,
          $$TareasTableFilterComposer,
          $$TareasTableOrderingComposer,
          $$TareasTableAnnotationComposer,
          $$TareasTableCreateCompanionBuilder,
          $$TareasTableUpdateCompanionBuilder,
          (Tarea, $$TareasTableReferences),
          Tarea,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$TareasTableTableManager(_$AppDatabase db, $TareasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TareasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TareasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TareasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<DateTime> fechaLimite = const Value.absent(),
                Value<double> duracionEstimada = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<double> prioridadScore = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => TareasCompanion(
                id: id,
                titulo: titulo,
                categoriaId: categoriaId,
                fechaLimite: fechaLimite,
                duracionEstimada: duracionEstimada,
                completada: completada,
                prioridadScore: prioridadScore,
                creadaEn: creadaEn,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titulo,
                required int categoriaId,
                required DateTime fechaLimite,
                Value<double> duracionEstimada = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<double> prioridadScore = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => TareasCompanion.insert(
                id: id,
                titulo: titulo,
                categoriaId: categoriaId,
                fechaLimite: fechaLimite,
                duracionEstimada: duracionEstimada,
                completada: completada,
                prioridadScore: prioridadScore,
                creadaEn: creadaEn,
                needsSync: needsSync,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TareasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
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
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable: $$TareasTableReferences
                                    ._categoriaIdTable(db),
                                referencedColumn: $$TareasTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$TareasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TareasTable,
      Tarea,
      $$TareasTableFilterComposer,
      $$TareasTableOrderingComposer,
      $$TareasTableAnnotationComposer,
      $$TareasTableCreateCompanionBuilder,
      $$TareasTableUpdateCompanionBuilder,
      (Tarea, $$TareasTableReferences),
      Tarea,
      PrefetchHooks Function({bool categoriaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$TareasTableTableManager get tareas =>
      $$TareasTableTableManager(_db, _db.tareas);
}
