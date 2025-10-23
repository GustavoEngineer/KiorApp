import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart'
    as task_screen;

class DismissibleTaskCard extends ConsumerStatefulWidget {
  final Task task;
  final bool showDate;

  const DismissibleTaskCard({
    super.key,
    required this.task,
    this.showDate = true,
  });

  @override
  ConsumerState<DismissibleTaskCard> createState() =>
      _DismissibleTaskCardState();
}

enum _DragDirection { left, right, none }

class _DismissibleTaskCardState extends ConsumerState<DismissibleTaskCard> {
  _DragDirection _dragDirection = _DragDirection.none;

  void _navigateToEditTask(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => task_screen.NewTaskScreen(task: widget.task),
      ),
    );
    if (result == true) {
      ref.read(taskProvider.notifier).loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    final cardBorderRadius = _dragDirection == _DragDirection.right
        ? const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
          )
        : _dragDirection == _DragDirection.left
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topRight: Radius.zero,
            bottomRight: Radius.zero,
          )
        : BorderRadius.circular(12);

    final boxShadow = _dragDirection == _DragDirection.right
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(-4, 0), // Shadow on the left
            ),
          ]
        : _dragDirection == _DragDirection.left
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(4, 0), // Shadow on the right
            ),
          ]
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Listener(
        onPointerDown: (event) {
          setState(() {
            _dragDirection = _DragDirection.none;
          });
        },
        onPointerMove: (event) {
          if (_dragDirection == _DragDirection.none) {
            if (event.delta.dx > 1) {
              setState(() {
                _dragDirection = _DragDirection.right;
              });
            } else if (event.delta.dx < -1) {
              setState(() {
                _dragDirection = _DragDirection.left;
              });
            }
          }
        },
        onPointerUp: (event) {
          setState(() {
            _dragDirection = _DragDirection.none;
          });
        },
        onPointerCancel: (event) {
          setState(() {
            _dragDirection = _DragDirection.none;
          });
        },
        child: Dismissible(
          key: ValueKey(widget.task.id),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              ref.read(taskProvider.notifier).deleteTask(widget.task.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tarea "${widget.task.name}" eliminada'),
                  action: SnackBarAction(
                    label: 'Deshacer',
                    onPressed: () {
                      ref.read(taskProvider.notifier).loadTasks();
                    },
                  ),
                ),
              );
            }
          },
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 147, 248),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              _navigateToEditTask(context);
              return false;
            }
            return true;
          },
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              border: Border.all(
                color: const Color.fromARGB(255, 230, 230, 230),
                width: 1,
              ),
              borderRadius: cardBorderRadius,
              boxShadow: boxShadow,
            ),
            child: ClipRRect(
              borderRadius: cardBorderRadius,
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(widget.task.id),
                  collapsedBackgroundColor: primaryColor.withOpacity(0.1),
                  backgroundColor: primaryColor.withOpacity(0.1),
                  tilePadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 12.0,
                  ),
                  trailing: const SizedBox.shrink(),
                  title: Row(
                    children: [
                      Checkbox(
                        value: widget.task.isCompleted,
                        onChanged: (bool? value) {
                          if (value != null) {
                            ref
                                .read(taskProvider.notifier)
                                .updateTask(
                                  widget.task.copyWith(isCompleted: value),
                                );
                          }
                        },
                        activeColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.task.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Container(
                      color: Colors.white.withOpacity(0.5),
                      width: double.infinity,
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
                            const SizedBox(height: 12),
                          ],
                          if (widget.task.tagIds.isNotEmpty) ...[
                            _buildTagsDetailRow(context),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ),
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

  Widget _buildTagsDetailRow(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final allTags = ref.watch(tagProvider);
    final tagNames = widget.task.tagIds
        .map((tagId) {
          try {
            return allTags.firstWhere((t) => t.id == tagId).name;
          } catch (e) {
            return null;
          }
        })
        .where((name) => name != null);

    return _buildDetailRow(context, 'Categorías', tagNames.join(', '));
  }
}
