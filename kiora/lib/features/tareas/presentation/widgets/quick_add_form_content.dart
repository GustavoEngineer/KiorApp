import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/task_title_input.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/category_selector.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/due_date_selector.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/duration_input.dart';
import 'package:kiora/core/di/core_providers.dart';
import 'package:kiora/core/data_sources/app_database.dart' as db;
import 'package:drift/drift.dart' show Value;
import 'package:kiora/features/categorias/domain/models/categoria_model.dart'
    as cat_dom;
import 'package:kiora/features/tareas/domain/models/tarea_model.dart'
    as tarea_dom;
import 'package:kiora/features/tareas/data/providers/repository_providers.dart';

final quickAddFormProvider =
    StateNotifierProvider<QuickAddFormNotifier, QuickAddFormState>((ref) {
      return QuickAddFormNotifier();
    });

class QuickAddFormState {
  final String titulo;
  final String categoria;
  final DateTime? fechaLimite;
  final double duracionEstimada;
  final bool isDuracionEnHoras;

  QuickAddFormState({
    this.titulo = '',
    this.categoria = '',
    this.fechaLimite,
    this.duracionEstimada = 1.0,
    this.isDuracionEnHoras = true,
  });

  bool get isCompleted =>
      titulo.trim().isNotEmpty &&
      categoria.trim().isNotEmpty &&
      fechaLimite != null;

  QuickAddFormState copyWith({
    String? titulo,
    String? categoria,
    DateTime? fechaLimite,
    double? duracionEstimada,
    bool? isDuracionEnHoras,
  }) {
    return QuickAddFormState(
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      isDuracionEnHoras: isDuracionEnHoras ?? this.isDuracionEnHoras,
    );
  }
}

class QuickAddFormNotifier extends StateNotifier<QuickAddFormState> {
  QuickAddFormNotifier() : super(QuickAddFormState());

  void updateTitulo(String titulo) {
    state = state.copyWith(titulo: titulo);
  }

  void updateCategoria(String categoria) {
    state = state.copyWith(categoria: categoria);
  }

  void updateFechaLimite(DateTime fecha) {
    state = state.copyWith(fechaLimite: fecha);
  }

  void updateDuracionEstimada(double duracion) {
    state = state.copyWith(duracionEstimada: duracion);
  }

  void resetForm() {
    state = QuickAddFormState();
  }

  void toggleUnidadTiempo() {
    final newValue = !state.isDuracionEnHoras;
    // Ajustar la duración si es necesario
    double newDuracion = state.duracionEstimada;
    if (newValue && newDuracion > 24) {
      // Si cambia a horas y excede 24
      newDuracion = 24;
    } else if (!newValue && newDuracion > 31) {
      // Si cambia a días y excede 31
      newDuracion = 31;
    }
    state = state.copyWith(
      isDuracionEnHoras: newValue,
      duracionEstimada: newDuracion,
    );
  }
}

class QuickAddFormContent extends ConsumerStatefulWidget {
  const QuickAddFormContent({super.key});

  @override
  QuickAddFormContentState createState() => QuickAddFormContentState();
}

class QuickAddFormContentState extends ConsumerState<QuickAddFormContent> {
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(quickAddFormProvider);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(38.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de título
                  const TaskTitleInput(),
                  const SizedBox(height: 28),
                  // Campo de categoría
                  const CategorySelector(),
                  const SizedBox(height: 28),
                  // Campo de fecha límite
                  const DueDateSelector(),
                  const SizedBox(height: 24),
                  // Campo de duración
                  const DurationInput(),
                ],
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton(
              onPressed: () async {
                if (formState.isCompleted) {
                  // Mostrar diálogo de confirmación
                  final shouldSave = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Deseas guardar esta tarea?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  );

                  if (shouldSave ?? false) {
                    // Lógica para guardar la tarea en la DB local usando el repositorio
                    // Capturamos el ScaffoldMessenger antes de cualquier await para
                    // evitar usar BuildContext a través de saltos async.
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      final dbRef = ref.read(appDatabaseProvider);

                      // Buscar categoría por nombre en la DB; si no existe, crearla.
                      final allCats = await dbRef
                          .select(dbRef.categorias)
                          .get();
                      db.Categoria? matchedCat;
                      try {
                        matchedCat = allCats.firstWhere(
                          (r) => r.nombre == formState.categoria,
                        );
                      } catch (e) {
                        matchedCat = null;
                      }

                      if (matchedCat == null) {
                        final trimmed = formState.categoria.trim();
                        final newId = await dbRef
                            .into(dbRef.categorias)
                            .insert(
                              db.CategoriasCompanion.insert(
                                nombre: trimmed,
                                importancia: Value(1),
                                needsSync: Value(true),
                              ),
                            );
                        final refreshed = await dbRef
                            .select(dbRef.categorias)
                            .get();
                        matchedCat = refreshed.firstWhere((r) => r.id == newId);
                      }

                      // Construir modelo de dominio Categoria
                      final categoriaDominio = cat_dom.Categoria(
                        id: matchedCat.id,
                        nombre: matchedCat.nombre,
                        importancia: matchedCat.importancia,
                      );

                      // Construir modelo de dominio Tarea
                      final nuevaTarea = tarea_dom.Tarea(
                        id: null,
                        titulo: formState.titulo.trim(),
                        fechaLimite: formState.fechaLimite!,
                        duracionEstimada: formState.duracionEstimada,
                        prioridadScore: 0.0,
                        completada: false,
                        creadaEn: DateTime.now(),
                        categoria: categoriaDominio,
                      );

                      // Guardar mediante el repositorio
                      final repo = ref.read(tareaRepositoryProvider);
                      await repo.crearTarea(nuevaTarea, categoriaDominio);

                      // Feedback al usuario (usamos el messenger capturado)
                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Tarea guardada')),
                        );
                      }

                      // Clear focus and explicitly hide the keyboard to avoid it
                      // reappearing on the main screen when the form is closed.
                      FocusScope.of(context).unfocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      ref.read(quickAddFormProvider.notifier).resetForm();
                      ref.read(quickAddFormVisibilityProvider.notifier).hide();
                    } catch (e) {
                      // Mostrar error simple usando el messenger capturado
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error al guardar: $e')),
                        );
                      }
                    }
                  }
                } else {
                  // Si no está completo, simplemente salir
                  // Clear focus and explicitly hide keyboard so it doesn't
                  // reappear when returning to the main screen.
                  FocusScope.of(context).unfocus();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  ref.read(quickAddFormProvider.notifier).resetForm();
                  ref.read(quickAddFormVisibilityProvider.notifier).hide();
                }
              },
              backgroundColor: formState.isCompleted
                  ? KioraColors.successGreen
                  : Colors.grey.shade400,
              child: Icon(
                formState.isCompleted ? Icons.save : Icons.close,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
