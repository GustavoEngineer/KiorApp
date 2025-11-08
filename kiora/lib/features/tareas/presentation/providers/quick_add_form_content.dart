import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';

final quickAddFormProvider =
    StateNotifierProvider<QuickAddFormNotifier, QuickAddFormState>((ref) {
      return QuickAddFormNotifier();
    });

class QuickAddFormState {
  final String titulo;
  final String categoria;
  final DateTime? fechaLimite;
  final double duracionEstimada;

  QuickAddFormState({
    this.titulo = '',
    this.categoria = '',
    this.fechaLimite,
    this.duracionEstimada = 1.0,
  });

  QuickAddFormState copyWith({
    String? titulo,
    String? categoria,
    DateTime? fechaLimite,
    double? duracionEstimada,
  }) {
    return QuickAddFormState(
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
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
}

class QuickAddFormContent extends ConsumerWidget {
  const QuickAddFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(quickAddFormProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título
            TextField(
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: KioraColors.accentKiora),
                ),
              ),
              onChanged: (value) =>
                  ref.read(quickAddFormProvider.notifier).updateTitulo(value),
            ),
            const SizedBox(height: 16),
            // Campo de categoría
            TextField(
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: KioraColors.accentKiora),
                ),
              ),
              onChanged: (value) => ref
                  .read(quickAddFormProvider.notifier)
                  .updateCategoria(value),
            ),
            const SizedBox(height: 16),
            // Campo de fecha límite
            InkWell(
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (fecha != null) {
                  ref
                      .read(quickAddFormProvider.notifier)
                      .updateFechaLimite(fecha);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formState.fechaLimite != null
                          ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(formState.fechaLimite!)
                          : 'Fecha límite',
                      style: TextStyle(
                        color: formState.fechaLimite != null
                            ? Colors.black
                            : Colors.grey.shade600,
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de duración estimada
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Duración estimada: ${formState.duracionEstimada.toStringAsFixed(1)}h',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Slider(
                    value: formState.duracionEstimada,
                    min: 0.5,
                    max: 8,
                    divisions: 15,
                    activeColor: KioraColors.accentKiora,
                    label: '${formState.duracionEstimada.toStringAsFixed(1)}h',
                    onChanged: (value) => ref
                        .read(quickAddFormProvider.notifier)
                        .updateDuracionEstimada(value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(quickAddFormProvider.notifier).resetForm();
                    ref.read(quickAddFormVisibilityProvider.notifier).hide();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Aquí irá la lógica para guardar la tarea
                    ref.read(quickAddFormProvider.notifier).resetForm();
                    ref.read(quickAddFormVisibilityProvider.notifier).hide();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KioraColors.accentKiora,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
