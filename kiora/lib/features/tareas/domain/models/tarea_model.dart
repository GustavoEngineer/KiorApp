// Archivo: lib/features/tareas/domain/models/tarea_model.dart

import 'package:kiora/features/categorias/domain/models/categoria_model.dart';

class Tarea {
  final int? id; // Opcional si la tarea es nueva (Quick Add)
  final String titulo;
  final DateTime fechaLimite; // ⏱️ Variable T_rem
  final double duracionEstimada; // 🏋️ Variable E (Horas)
  final double prioridadScore; // 💯 Output del Algoritmo (Capa 1)
  final bool completada;
  final DateTime creadaEn;

  // Propiedad que incluye la información de Dominio de la Categoría
  final Categoria categoria;

  // Columnas de Metadata (solo para el dominio y su uso en el Repositorio)
  final bool needsSync;
  final DateTime? lastSyncAt;

  Tarea({
    this.id,
    required this.titulo,
    required this.fechaLimite,
    required this.duracionEstimada,
    required this.prioridadScore,
    required this.completada,
    required this.creadaEn,
    required this.categoria,
    this.needsSync = true,
    this.lastSyncAt,
  });

  // Método de ayuda para clonar o actualizar un objeto (necesario en State Management)
  Tarea copyWith({
    int? id,
    String? titulo,
    DateTime? fechaLimite,
    double? duracionEstimada,
    double? prioridadScore,
    bool? completada,
    DateTime? creadaEn,
    Categoria? categoria,
    bool? needsSync,
    DateTime? lastSyncAt,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      prioridadScore: prioridadScore ?? this.prioridadScore,
      completada: completada ?? this.completada,
      creadaEn: creadaEn ?? this.creadaEn,
      categoria: categoria ?? this.categoria,
      needsSync: needsSync ?? this.needsSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}
