// Archivo: lib/core/data_sources/app_database.dart

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// 1. Importar las definiciones de las tablas
import 'package:kiora/features/categorias/data/models/categoria_table.dart';
import 'package:kiora/features/tareas/data/models/tarea_table.dart';

// Este archivo contendrá el código generado por Drift.
part 'app_database.g.dart';

// 2. Decorador principal de la base de datos
@DriftDatabase(tables: [Tareas, Categorias])
// 3. Clase abstracta que representa nuestra base de datos
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Define la versión de la base de datos (crucial para migraciones)
  @override
  int get schemaVersion => 1;

  // Implementación de migraciones (solo para la versión 1, por ahora es vacío)
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll(); // Crea todas las tablas definidas arriba
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Lógica de migración para futuras versiones (ej. schemaVersion 2, 3...)
    },
  );
}

// 4. Función de conexión a la base de datos local (SQLite)
LazyDatabase _openConnection() {
  // Drift necesita saber dónde guardar el archivo SQLite
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kiora.sqlite'));
    return NativeDatabase(file);
  });
}
