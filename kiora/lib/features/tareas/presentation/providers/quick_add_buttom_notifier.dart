import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';

final quickAddButtonProvider = Provider<QuickAddButton>((ref) {
  return const QuickAddButton();
});

class QuickAddButton extends ConsumerWidget {
  const QuickAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () =>
              ref.read(quickAddFormVisibilityProvider.notifier).show(),
          icon: const Icon(Icons.add),
          label: const Text('Agregar tarea'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(KioraColors.accentKiora),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16.0),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
        ),
      ),
    );
  }
}
