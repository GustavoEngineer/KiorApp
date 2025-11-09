import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';

class TaskTitleInput extends ConsumerWidget {
  const TaskTitleInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(quickAddFormProvider);

    return TextFormField(
      initialValue: formState.titulo,
      onChanged: (value) {
        ref.read(quickAddFormProvider.notifier).updateTitulo(value);
      },
      decoration: const InputDecoration(
        labelText: 'Título de la tarea',
        border: UnderlineInputBorder(),
      ),
    );
  }
}
