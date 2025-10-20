import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart';

class TaskCard extends ConsumerStatefulWidget {
  final Task task;
  final bool showDate;

  const TaskCard({super.key, required this.task, this.showDate = false});

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  bool _isExpanded = false;

  void _navigateToEditTask(BuildContext context, Task task) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => NewTaskScreen(task: task)));
    if (result == true) {
      ref
          .read(taskProvider.notifier)
          .loadTasks(); // 'ref' is available in ConsumerState
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;
    final today = DateTime.now();
    final allTags = ref.watch(tagProvider); // ref is available in ConsumerState

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: cardTheme.color,
        clipBehavior: Clip.antiAlias,
        elevation: 0, // Mantenemos la tarjeta sin sombra
        child: Theme(
          // Eliminamos los divisores superior e inferior del ExpansionTile
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            collapsedBackgroundColor: Theme.of(
              context,
            ).primaryColor.withOpacity(0.1),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            leading: GestureDetector(
              onTap: () {
                if (_isExpanded) {
                  _navigateToEditTask(context, widget.task);
                }
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  _isExpanded ? Icons.edit : Icons.article_outlined,
                  size: 28,
                  color: textTheme.titleLarge?.color,
                ),
              ),
            ),
            title: Text(
              widget.task.name,
              style: textTheme.titleMedium?.copyWith(
                color: textTheme.titleLarge?.color,
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: widget.task.tagIds.isNotEmpty
                  ? Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: widget.task.tagIds.map<Widget>((tagId) {
                        final tag = allTags.firstWhere(
                          (t) => t.id == tagId,
                          orElse: () => Tag(id: -1, name: 'Deleted Tag'),
                        );
                        if (tag.id == -1) return const SizedBox.shrink();
                        return Chip(
                          label: Text(tag.name),
                          padding: EdgeInsets.zero,
                          labelStyle: textTheme.bodySmall?.copyWith(
                            color: textTheme.titleLarge?.color,
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.grey[200],
                          shape: const StadiumBorder(side: BorderSide.none),
                        );
                      }).toList(),
                    )
                  : const SizedBox(
                      height: 16, // Altura mínima para mantener la consistencia
                    ),
            ),
            trailing: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: textTheme.titleLarge?.color,
              ),
            ),
            children: <Widget>[
              Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.task.description != null &&
                          widget.task.description!.isNotEmpty) ...[
                        _buildDetailRow(
                          context,
                          'Descripción',
                          widget.task.description!,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (widget.task.dueDate != null) ...[
                        _buildDetailRow(
                          context,
                          'Vencimiento',
                          DateFormat(
                            'EEE, d MMM, yyyy',
                            'es_ES',
                          ).format(widget.task.dueDate!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(label, style: textTheme.bodySmall)),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: textTheme.titleLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
