// Archivo: lib/features/tareas/domain/services/algoritmo_kiora_service.dart

import 'package:kiora/features/tareas/domain/models/tarea_model.dart'; // Asumimos la existencia de un modelo de dominio puro.

/// 🧠 Implementación de la Lógica de Doble Etapa del Algoritmo OWLv1.
/// Este servicio debe ser independiente de cualquier tecnología de persistencia (Drift/Supabase).
class AlgoritmoKioraService {
  /// Constante para el Factor de Escalamiento (F_esc) de urgencia inmediata[cite: 52].
  /// Se usa si la tarea vence hoy (menor o igual a día)[cite: 52].
  static const double _factorEscalamientoInmediato = 10000.0;

  /// Constante para el Factor de Escalamiento (F_esc) general[cite: 52].
  /// Se usa en cualquier otro caso de vencimiento[cite: 52].
  static const double _factorEscalamientoNormal = 100.0;

  /// Constante para la Regla de Normalización para evitar la división por cero[cite: 52].
  /// Se usa si T_rem es menor o igual a 0 (tarea vencida)[cite: 52].
  static const double _normalizacionVencida = 0.01;

  // =============================================================
  // CAPA 1: CÁLCULO DE RANKING (Prioridad_Score)
  // =============================================================

  /// Calcula el Prioridad_Score de una tarea (Fase de Escritura).
  /// Esta función se dispara ante Creación/Edición de Tarea o Cambio de Hora (Diario)[cite: 84].
  ///
  /// Retorna un double: El valor de ranking que se almacena en Tarea.Prioridad_Score[cite: 54].
  double calcularPrioridadScore(
    Tarea tarea,
    int importanciaCategoria, // Variable I (Peso de Categoría)
  ) {
    // 1. Obtener los inputs del algoritmo:
    final double duracionEstimada =
        tarea.duracionEstimada; // Variable E (Esfuerzo)[cite: 40].
    final DateTime? fechaLimite =
        tarea.fechaLimite; // Base para T_rem (Urgencia)[cite: 40].

    if (fechaLimite == null) {
      // Regla: Asignar un score bajo si no hay fecha límite.
      return 0.0;
    }

    // 2. Calcular Días Restantes (T_rem) y Factor de Escalamiento (F_esc).
    final DateTime hoy = DateTime.now();
    final Duration diferencia = fechaLimite.difference(hoy);
    double diasRestantes = diferencia.inHours / 24.0;

    double fEsc = _factorEscalamientoNormal;
    if (diasRestantes <= 1.0) {
      // Si la tarea vence hoy (menor o igual a día), F_esc = 10000[cite: 52].
      fEsc = _factorEscalamientoInmediato;
    }

    // 3. Aplicar la Regla de Normalización de Tareas Vencidas.
    double denominador = diasRestantes;
    if (denominador <= 0) {
      // Evita la división por cero y asigna urgencia máxima (score más alto)[cite: 52].
      denominador = _normalizacionVencida;
    }

    // 4. Aplicar la Fórmula de Ranking (Capa 1):
    // Prioridad_Score = (Importancia x Duración_estimada (Horas) x F_esc) / Días Restantes Normalizados[cite: 49].
    final double numerador = importanciaCategoria * duracionEstimada * fEsc;

    return numerador / denominador;
  }

  // =============================================================
  // CAPA 2: ASIGNACIÓN DIARIA (Programación Realista)
  // =============================================================

  /// Ejecuta la lógica Greedy para asignar tareas al día (Fase de Lectura y Ejecución Lógica)[cite: 58].
  ///
  /// Retorna una lista de Tareas que cumplen con el límite de capacidad[cite: 78].
  List<Tarea> asignarTareasParaHoy(
    List<Tarea> todasLasTareas,
    double capacidadDiaria, // Variable C (horas_trabajo_dia)[cite: 40, 66].
  ) {
    // 1. Filtrar y Ordenar por Score.
    // Solo procesamos tareas NO completadas [cite: 63] y ordenamos por Prioridad_Score (mayor a menor)[cite: 64].
    final List<Tarea> tareasActivas = todasLasTareas
        .where((t) => !t.completada)
        .toList();

    // El ordenamiento es CRÍTICO: de mayor a menor score.
    tareasActivas.sort((a, b) => b.prioridadScore.compareTo(a.prioridadScore));

    // 2. Restricción de Capacidad: Iniciar contador y definir límite[cite: 66].
    final List<Tarea> asignadasParaHoy = [];
    double tiempoAsignadoHoy = 0.0;

    // 3. Iteración y Asignación (Algoritmo Greedy)[cite: 67, 71].
    for (final tarea in tareasActivas) {
      final double duracionEstimada =
          tarea.duracionEstimada; // Variable E[cite: 40].

      // Verificar si la tarea cabe en la capacidad restante del día[cite: 72].
      if ((tiempoAsignadoHoy + duracionEstimada) <= capacidadDiaria) {
        // La tarea cabe, se añade a la lista de Hoy.
        asignadasParaHoy.add(tarea);
        tiempoAsignadoHoy += duracionEstimada;
      } else {
        // Si no cabe, la tarea se salta y queda pendiente para mañana[cite: 74, 75].
        // Continuamos con el bucle para ver si tareas más pequeñas caben (Lógica Greedy).
        continue;
      }

      // La iteración se detiene cuando la capacidad total (C) se agota (casi agotada).
      if (tiempoAsignadoHoy >= capacidadDiaria) {
        break;
      }
    }

    return asignadasParaHoy;
  }
}
