import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';

class DurationInput extends ConsumerWidget {
  const DurationInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(quickAddFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Duración: ${formState.duracionEstimada.toStringAsFixed(1)} ${formState.isDuracionEnHoras ? "hrs" : "días"}',
              style: const TextStyle(color: Colors.black87),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(quickAddFormProvider.notifier).toggleUnidadTiempo(),
              child: Text(
                formState.isDuracionEnHoras
                    ? "Cambiar a días"
                    : "Cambiar a horas",
                style: TextStyle(color: KioraColors.accentKiora),
              ),
            ),
          ],
        ),
        Slider(
          value: formState.duracionEstimada,
          min: 0.5,
          max: formState.isDuracionEnHoras ? 24.0 : 31.0,
          divisions: formState.isDuracionEnHoras
              ? 47
              : 61, // Para incrementos de 0.5
          activeColor: KioraColors.accentKiora,
          label:
              '${formState.duracionEstimada.toStringAsFixed(1)} ${formState.isDuracionEnHoras ? "hrs" : "días"}',
          onChanged: (value) => ref
              .read(quickAddFormProvider.notifier)
              .updateDuracionEstimada(value),
        ),
      ],
    );
  }
}
