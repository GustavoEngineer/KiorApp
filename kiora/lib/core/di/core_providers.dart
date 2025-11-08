// Archivo: lib/core/di/core_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importar servicios core y de dominio
import 'package:kiora/core/data_sources/app_database.dart';
import 'package:kiora/features/tareas/domain/services/algoritmo_kiora_service.dart';

// 1. Provider para la Base de Datos (Drift)
// Se usa un Provider simple ya que la inicialización ya se maneja en _openConnection()
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  // Instancia única de la base de datos local
  return AppDatabase();
});

// 2. Provider para el Servicio del Algoritmo (Lógica Pura)
// Es una clase sin dependencias externas, por lo que es un Provider simple.
final algoritmoKioraServiceProvider = Provider<AlgoritmoKioraService>((ref) {
  return AlgoritmoKioraService();
});

// Nota: Se añadirán supabaseClientProvider y connectivityProvider en fases posteriores.
