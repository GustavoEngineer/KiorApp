// Archivo: lib/features/tareas/data/mappers/tarea_mapper.dart

import 'package:drift/drift.dart';

// Importar Modelos de Dominio (Estos se usan directamente sin prefijo)
import 'package:kiora/features/categorias/domain/models/categoria_model.dart';
import 'package:kiora/features/tareas/domain/models/tarea_model.dart'; // <--- El 'Tarea' DOMAIN aquí

// Importar Modelos de Datos de Drift (¡USAMOS EL PREFIJO 'db'!)
import 'package:kiora/core/data_sources/app_database.dart' as db;
// Ahora, todo lo que venga de Drift debe ser referenciado como db.Xyz

/// Clase estática para la conversión de modelos (Mapeo)
class TareaMapper {
  // =============================================================
  // 1. CONVERSIÓN DE DATOS A DOMINIO (Lectura desde DB)
  // =============================================================

  // Usamos db.TareaData para referirnos a la clase generada por Drift.
  static Tarea toDomain(db.Tarea data, db.Categoria categoriaData) {
    // Primero, mapear la Categoría Data a Dominio
    final categoriaDomain = Categoria(
      id: categoriaData.id,
      nombre: categoriaData.nombre,
      importancia: categoriaData.importancia,
    );

    // Luego, mapear la Tarea Data (usando el modelo de Dominio puro 'Tarea')
    return Tarea(
      id: data.id,
      titulo: data.titulo,
      fechaLimite: data.fechaLimite,
      duracionEstimada: data.duracionEstimada,
      prioridadScore: data.prioridadScore,
      completada: data.completada,
      creadaEn: data.creadaEn,
      categoria: categoriaDomain,
      needsSync: data.needsSync,
      lastSyncAt: data.lastSyncAt,
    );
  }

  // =============================================================
  // 2. CONVERSIÓN DE DOMINIO A DATOS (Escritura en DB)
  // =============================================================

  // Usamos db.TareasCompanion para referirnos a la clase de escritura de Drift.
  static db.TareasCompanion toDriftCompanion(Tarea domain) {
    return db.TareasCompanion(
      id: domain.id != null ? Value(domain.id!) : const Value.absent(),
      titulo: Value(domain.titulo),
      categoriaId: Value(domain.categoria.id!),
      fechaLimite: Value(domain.fechaLimite),
      duracionEstimada: Value(domain.duracionEstimada),
      prioridadScore: Value(domain.prioridadScore),
      completada: Value(domain.completada),
      creadaEn: Value(domain.creadaEn),
      needsSync: Value(domain.needsSync),
      lastSyncAt: Value.ofNullable(domain.lastSyncAt),
    );
  }
}
