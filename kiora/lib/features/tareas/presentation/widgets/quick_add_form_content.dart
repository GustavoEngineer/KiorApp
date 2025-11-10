import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/task_title_input.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/category_selector.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/due_date_selector.dart';
import 'package:kiora/features/tareas/presentation/widgets/inputs/duration_input.dart';

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
                    // Aquí irá la lógica para guardar
                    ref.read(quickAddFormProvider.notifier).resetForm();
                    ref.read(quickAddFormVisibilityProvider.notifier).hide();
                  }
                } else {
                  // Si no está completo, simplemente salir
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
