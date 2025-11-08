// Archivo: lib/features/tareas/data/providers/repository_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importar el Modelo de Dominio (La clase de tipo que el StreamProvider necesita)
import 'package:kiora/features/tareas/domain/models/tarea_model.dart';

// Importar el Contrato (Dominio) y la Implementación (Data)
import 'package:kiora/features/tareas/domain/repositories/tarea_repository.dart';
import 'package:kiora/features/tareas/data/repositories/tarea_repository_impl.dart';

// Importar los Providers Core.
// ¡El AppDatabaseProvider ya se encarga de instanciar app_database.dart!
import 'package:kiora/core/di/core_providers.dart';
// No necesitamos importar 'package:kiora/core/data_sources/app_database.dart' directamente
// en este archivo, lo que elimina la ambigüedad de 'Tarea'.

/// 3. Provider para el Repositorio de Tareas (Contrato)
final tareaRepositoryProvider = Provider<TareaRepository>((ref) {
  // Observa (watch) los providers necesarios del Core
  final db = ref.watch(appDatabaseProvider);
  final algoritmoService = ref.watch(algoritmoKioraServiceProvider);

  // Instancia la implementación, pasándole las dependencias inyectadas
  return TareaRepositoryImpl(db, algoritmoService);
});

// =============================================================
// PRÓXIMO PASO: PROVIDER DEL ESTADO (Lectura para la UI)
// =============================================================

/// 4. Provider del Estado de Tareas Asignadas para Hoy (Output final para la UI)
final tareasAsignadasParaHoyProvider = StreamProvider.autoDispose<List<Tarea>>((
  ref,
) {
  final repository = ref.watch(tareaRepositoryProvider);
  const double capacidadDiaria =
      8.0; // Variable C (horas_trabajo_dia) hardcodeada

  // Tarea se resuelve ahora correctamente como el modelo de dominio.
  return repository.obtenerTareasAsignadasParaHoy(capacidadDiaria);
});
