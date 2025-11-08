// Archivo: lib/features/tareas/domain/repositories/tarea_repository.dart

import 'package:kiora/features/tareas/domain/models/tarea_model.dart';
import 'package:kiora/features/categorias/domain/models/categoria_model.dart';

/// 🎯 Contrato (Interface) para el Repositorio de Tareas.
/// Define las reglas y operaciones que la aplicación necesita.
/// Es la base de la comunicación entre la Capa de Dominio y la Capa de Datos.
abstract class TareaRepository {
  // =============================================================
  // OPERACIONES DE CRUD Y ALGORITMO (DOMAIN)
  // =============================================================

  /// 📥 Crea una nueva Tarea. Debe disparar el cálculo del Prioridad_Score (Capa 1).
  ///
  /// Retorna la Tarea creada (con ID y Score asignados) para el feedback inmediato de la UI.
  Future<Tarea> crearTarea(Tarea tarea, Categoria categoriaAsignada);

  /// 🔄 Actualiza una Tarea existente. Debe disparar el recálculo del Prioridad_Score (Capa 1).
  Future<Tarea> actualizarTarea(Tarea tarea, Categoria categoriaAsignada);

  /// 🗑️ Elimina una Tarea por su ID.
  Future<void> eliminarTarea(int id);

  /// 🟢 Marca una tarea como completada, actualizando el estado 'completada'.
  Future<void> marcarComoCompletada(int id);

  // =============================================================
  // STREAM DE LECTURA Y PROGRAMACIÓN (PRESENTATION)
  // =============================================================

  /// 👁️ Provee un Stream de todas las Tareas activas, ya procesadas y ordenadas.
  /// La Capa de Presentación (Riverpod) observará este Stream.
  ///
  /// Retorna: Un Stream de la lista de tareas asignadas para 'Hoy' (Output de la Capa 2).
  Stream<List<Tarea>> obtenerTareasAsignadasParaHoy(double capacidadDiaria);

  /// 📅 Provee un Stream de todas las Tareas activas (para las vistas 'Semanal' o 'Calendario').
  /// Retorna: Un Stream de la lista completa de tareas activas, ordenadas por Score.
  Stream<List<Tarea>> obtenerTodasTareasActivas();

  // =============================================================
  // MECANISMO DE SINCRONIZACIÓN (OFFLINE-FIRST)
  // =============================================================

  /// 🌐 Dispara el proceso asíncrono que sube los datos marcados con needsSync = true a Supabase.
  Future<void> sincronizarTareasPendientes();
}
