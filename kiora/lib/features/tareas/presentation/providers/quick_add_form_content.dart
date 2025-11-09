import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';
import 'package:kiora/features/tareas/presentation/providers/widgets/inputs/task_title_input.dart';
import 'package:kiora/features/tareas/presentation/providers/widgets/inputs/category_selector.dart';
import 'package:kiora/features/tareas/presentation/providers/widgets/inputs/due_date_selector.dart';
import 'package:kiora/features/tareas/presentation/providers/widgets/inputs/duration_input.dart';

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
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título
            const TaskTitleInput(),
            const SizedBox(height: 32),
            // Campo de categoría
            const CategorySelector(),
            const SizedBox(height: 32),
            // Campo de fecha límite
            const DueDateSelector(),
            const SizedBox(height: 32),
            // Campo de duración
            const DurationInput(),
            const SizedBox(height: 24),
            // Botón dinámico (Cancelar/Guardar)
            Center(
              child: SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    if (!formState.isCompleted) {
                      ref.read(quickAddFormProvider.notifier).resetForm();
                      ref.read(quickAddFormVisibilityProvider.notifier).hide();
                    } else {
                      ref.read(quickAddFormProvider.notifier).resetForm();
                      ref.read(quickAddFormVisibilityProvider.notifier).hide();
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: formState.isCompleted
                        ? KioraColors.accentKiora
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    formState.isCompleted ? 'Guardar' : 'Cancelar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
