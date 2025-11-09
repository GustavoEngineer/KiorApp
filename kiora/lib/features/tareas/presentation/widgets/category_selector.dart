import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';
import 'package:kiora/config/app_theme.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(quickAddFormProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoría',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: formState.categoria,
                isExpanded: true,
                hint: const Text('Selecciona una categoría'),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref
                        .read(quickAddFormProvider.notifier)
                        .updateCategoria(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 'personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'trabajo', child: Text('Trabajo')),
                  DropdownMenuItem(value: 'estudio', child: Text('Estudio')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
