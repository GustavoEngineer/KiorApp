// Archivo: lib/features/categorias/data/models/categoria_table.dart

import 'package:drift/drift.dart';

// Genera la clase de entidad (data class) 'Categoria' y la clase de tabla 'Categorias'.
// Esta tabla es crucial porque aloja la Variable I (Importancia) para el Algoritmo Kiora.
@DataClassName('Categoria')
class Categorias extends Table {
  // 🔑 ID: Clave Primaria.
  IntColumn get id => integer().autoIncrement()();

  // Nombre: Nombre visible de la categoría[cite: 28].
  TextColumn get nombre => text().withLength(min: 1, max: 50)();

  // ⚖️ Importancia (Peso): Rol crucial en el Algoritmo como Variable I (Peso)[cite: 28].
  // El usuario debe asignarlo, siendo un valor de 1 a 5[cite: 28].
  IntColumn get importancia => integer().withDefault(const Constant(1))();

  // --- Columnas de Metadata para Sincronización (Offline-First) ---

  // Flag que indica si el dato debe ser subido a Supabase[cite: 114].
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  // Timestamp de la última sincronización, usado para la limpieza de caché[cite: 126, 127].
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
