// Archivo: lib/features/tareas/data/models/tarea_table.dart

import 'package:drift/drift.dart';

// Importar la definición de la tabla Categorias para la Clave Foránea (FK)
import 'package:kiora/features/categorias/data/models/categoria_table.dart';

// Genera la clase de entidad 'Tarea' y la clase de tabla 'Tareas'.
@DataClassName('Tarea')
class Tareas extends Table {
  // 🔑 ID: Clave Primaria (PK) autoincremental[cite: 26].
  IntColumn get id => integer().autoIncrement()();

  // Título: Nombre visible[cite: 26].
  TextColumn get titulo => text().withLength(min: 1, max: 100)();

  // Clave Foránea a Categorías: Rol: Variable I (Importancia)[cite: 26, 40].
  // Usamos KeyAction.restrict para evitar eliminar una categoría que está en uso.
  IntColumn get categoriaId =>
      integer().references(Categorias, #id, onDelete: KeyAction.restrict)();

  // ⏱️ Fecha Límite: Rol: Variable T_rem (Días Restantes/Urgencia)[cite: 26, 40].
  DateTimeColumn get fechaLimite => dateTime()();

  // 🏋️ Duración Estimada: Rol: Variable E (Esfuerzo). Crucial para Asignación[cite: 26, 40].
  // En horas (RealColumn permite valores flotantes/dobles).
  RealColumn get duracionEstimada => real().withDefault(const Constant(0.5))();

  // ✅ Completada: Filtro (Solo se procesan tareas con 'Completada = Falso')[cite: 26, 40].
  BoolColumn get completada => boolean().withDefault(const Constant(false))();

  // 💯 Prioridad Score: RESULTADO del Algoritmo OWLv1. Es el Índice de Ranking[cite: 26].
  RealColumn get prioridadScore => real().withDefault(const Constant(0.0))();

  // Timestamp de Creación: Criterio de desempate en la Programación[cite: 26].
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();

  // --- Columnas de Metadata para Sincronización (Offline-First) [cite: 114] ---

  // Flag para el Mecanismo de Sincronización[cite: 114].
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  // Timestamp de la última sincronización, usado para la Regla de Borrado Local[cite: 127].
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
