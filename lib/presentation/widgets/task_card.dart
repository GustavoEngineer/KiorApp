import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final bool showDate;

  const TaskCard({super.key, required this.task, this.showDate = false});

  void _navigateToEditTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => NewTaskScreen(task: task)));
    if (result == true) {
      ref.read(taskProvider.notifier).loadTasks();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;
    final today = DateTime.now();
    final allTags = ref.watch(tagProvider);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          color: task.isCompleted ? Colors.grey[200] : cardTheme.color,
          child: InkWell(
            borderRadius: (cardTheme.shape as RoundedRectangleBorder?)
                ?.borderRadius
                .resolve(Directionality.of(context)),
            onTap: () => _navigateToEditTask(context, ref, task),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDate &&
                      task.dueDate != null &&
                      !DateUtils.isSameDay(task.dueDate, today)) ...[
                    Text(
                      task.dueDate!.toLocal().toString().split(' ')[0],
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    task.name,
                    style: textTheme.titleLarge?.copyWith(
                      color: task.isCompleted
                          ? textTheme.bodySmall?.color
                          : textTheme.titleLarge?.color,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      task.description!,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (task.tagIds.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: task.tagIds.map((tagId) {
                        final tag = allTags.firstWhere(
                          (t) => t.id == tagId,
                          orElse: () => Tag(id: -1, name: 'Deleted Tag'),
                        );
                        if (tag.id == -1) return const SizedBox.shrink();
                        return Chip(
                          label: Text(tag.name),
                          padding: EdgeInsets.zero,
                          labelStyle: textTheme.bodySmall,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
