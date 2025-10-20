import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/functions/dismissible_task_card.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';
import 'package:kiorapp/presentation/widgets/tag_chip.dart';

final selectedTagProvider = StateProvider<int?>((ref) => null);

class AllTasksList extends ConsumerWidget {
  final List<Task> tasks;
  const AllTasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTags = ref.watch(tagProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allTags.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: allTags.length,
              itemBuilder: (context, index) {
                final tag = allTags[index];
                return TagChip(
                  tag: tag,
                  isSelected: selectedTag == tag.id,
                  onSelected: (isSelected) {
                    final notifier = ref.read(selectedTagProvider.notifier);
                    if (notifier.state == tag.id) {
                      notifier.state = null; // Deseleccionar
                    } else {
                      notifier.state = tag.id; // Seleccionar
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    'No hay tareas para el filtro aplicado.',
                    style: textTheme.bodyLarge,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final previousTask = index > 0 ? tasks[index - 1] : null;

                    // Determinar si se debe mostrar el encabezado de la fecha
                    final bool showHeader =
                        index == 0 ||
                        !DateUtils.isSameDay(
                          task.dueDate,
                          previousTask?.dueDate,
                        );

                    if (showHeader) {
                      final date = task.dueDate;
                      String dateText = date == null
                          ? 'Sin Fecha'
                          : DateFormat(
                              'EEE, d MMM, yyyy',
                              'es_ES',
                            ).format(date);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
                            child: Text(
                              dateText,
                              style: textTheme.headlineSmall,
                            ),
                          ),
                          DismissibleTaskCard(task: task, showDate: false),
                        ],
                      );
                    }
                    return DismissibleTaskCard(task: task, showDate: false);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                ),
        ),
      ],
    );
  }
}
