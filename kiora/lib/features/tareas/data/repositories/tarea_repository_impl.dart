// Archivo: lib/features/tareas/data/repositories/tarea_repository_impl.dart

import 'package:drift/drift.dart';

// Importar modelos de Dominio y el Contrato
import 'package:kiora/features/tareas/domain/repositories/tarea_repository.dart';
import 'package:kiora/features/tareas/domain/models/tarea_model.dart';
import 'package:kiora/features/categorias/domain/models/categoria_model.dart';

// Importar servicios Core y de Dominio
// NOTA: Usamos el prefijo 'db' para evitar la ambigüedad con la clase 'Tarea'
import 'package:kiora/core/data_sources/app_database.dart' as db;
import 'package:kiora/features/tareas/domain/services/algoritmo_kiora_service.dart';

// Importar el Mapper
import 'package:kiora/features/tareas/data/mappers/tarea_mapper.dart';

/// ⚙️ Implementación concreta del TareaRepository.
/// Es el orquestador que maneja: 1) Drift, 2) Algoritmo, 3) Sincronización.
class TareaRepositoryImpl implements TareaRepository {
  // Inyección de dependencias CRÍTICAS
  final db.AppDatabase _db; // <-- Usando db.AppDatabase
  final AlgoritmoKioraService _algoritmoService;

  // Asumimos un DataSource remoto para la sincronización futura (Supabase)
  // final TareaRemoteDataSource _remoteDataSource;

  TareaRepositoryImpl(this._db, this._algoritmoService);

  // =============================================================
  // 1. IMPLEMENTACIÓN DE CRUD Y ALGORITMO (Capa 1)
  // =============================================================

  @override
  Future<Tarea> crearTarea(Tarea tarea, Categoria categoriaAsignada) async {
    // 1. Llama al Algoritmo para obtener el Score (Capa 1: Ranking)
    final double prioridadScore = _algoritmoService.calcularPrioridadScore(
      tarea,
      categoriaAsignada.importancia,
    );

    // 2. Mapea el Modelo de Dominio a un Companion de Drift
    final db.TareasCompanion newEntry = TareaMapper.toDriftCompanion(
      // <-- Usando db.TareasCompanion
      tarea.copyWith(
        prioridadScore: prioridadScore,
        needsSync: true, // Siempre marcado como Pendiente de Sincronización
        creadaEn: DateTime.now(),
      ),
    );

    // 3. Inserta en la DB local (Drift)
    final int newId = await _db.into(_db.tareas).insert(newEntry);

    // 4. Retorna el modelo de Dominio actualizado con el ID real
    return tarea.copyWith(id: newId, prioridadScore: prioridadScore);
  }

  @override
  Future<Tarea> actualizarTarea(
    Tarea tarea,
    Categoria categoriaAsignada,
  ) async {
    // 1. Recalcula el Score (Capa 1)
    final double prioridadScore = _algoritmoService.calcularPrioridadScore(
      tarea,
      categoriaAsignada.importancia,
    );

    // 2. Actualiza el Modelo de Dominio para el Companion
    final Tarea updatedTarea = tarea.copyWith(
      prioridadScore: prioridadScore,
      needsSync: true, // El cambio debe ser sincronizado
    );

    final db.TareasCompanion updatedEntry = TareaMapper.toDriftCompanion(
      // <-- Usando db.TareasCompanion
      updatedTarea,
    );

    // 3. Actualiza en la DB local (Drift)
    await (_db.update(
      _db.tareas,
    )..where((t) => t.id.equals(tarea.id!))).write(updatedEntry);

    // 4. Retorna el modelo actualizado
    return updatedTarea;
  }

  @override
  Future<void> eliminarTarea(int id) async {
    // Elimina el registro local. La sincronización posterior manejará el borrado en la nube.
    await (_db.delete(_db.tareas)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> marcarComoCompletada(int id) async {
    // Crea un Companion que solo actualiza los campos completada y needsSync
    final db.TareasCompanion completionEntry = db.TareasCompanion(
      // <-- Usando db.TareasCompanion
      completada: const Value(true),
      needsSync: const Value(true),
    );

    await (_db.update(
      _db.tareas,
    )..where((t) => t.id.equals(id))).write(completionEntry);
  }

  // =============================================================
  // 2. IMPLEMENTACIÓN DE LECTURA Y PROGRAMACIÓN (Capa 2)
  // =============================================================

  @override
  Stream<List<Tarea>> obtenerTareasAsignadasParaHoy(double capacidadDiaria) {
    // Este stream obtendrá TODAS las tareas activas ordenadas por Score (Capa 1)
    return obtenerTodasTareasActivas().map((todasTareas) {
      // Aplica la Capa 2 (Algoritmo Greedy) al resultado del stream
      return _algoritmoService.asignarTareasParaHoy(
        todasTareas,
        capacidadDiaria,
      );
    });
  }

  @override
  Stream<List<Tarea>> obtenerTodasTareasActivas() {
    // Implementación usando JOIN para obtener datos de Tarea y Categoría
    final query = _db.select(_db.tareas).join([
      innerJoin(
        _db.categorias,
        _db.categorias.id.equalsExp(_db.tareas.categoriaId),
      ),
    ]);

    // Filtrar solo las no completadas y ordenar por Score (Capa 1)
    query
      ..where(_db.tareas.completada.equals(false))
      ..orderBy([
        OrderingTerm.desc(_db.tareas.prioridadScore),
      ]); // [cite: 64, 65]

    // Convierte el resultado del Stream de Drift a un Stream de Modelos de Dominio (Mapeo)
    return query.watch().map((rows) {
      return rows.map((row) {
        // Usamos readTable para leer las clases de datos generadas por Drift (con prefijo)
        final tareaData = row.readTable(_db.tareas);
        final categoriaData = row.readTable(_db.categorias);

        // El Mapper se encarga de convertir Data -> Dominio
        return TareaMapper.toDomain(tareaData, categoriaData);
      }).toList();
    });
  }

  // =============================================================
  // 3. IMPLEMENTACIÓN DEL MECANISMO DE SINCRONIZACIÓN
  // =============================================================

  @override
  Future<void> sincronizarTareasPendientes() async {
    // Lógica pendiente: Se implementará en la fase de integración con Supabase.
  }
}
