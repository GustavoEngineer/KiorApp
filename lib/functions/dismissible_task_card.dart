
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/widgets/task_card.dart';

class DismissibleTaskCard extends ConsumerStatefulWidget {
  final Task task;
  final bool showDate;

  const DismissibleTaskCard({
    super.key,
    required this.task,
    this.showDate = true,
  });

  @override
  ConsumerState<DismissibleTaskCard> createState() => _DismissibleTaskCardState();
}

class _DismissibleTaskCardState extends ConsumerState<DismissibleTaskCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;

    return Dismissible(
      key: ValueKey(widget.task.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (widget.task.id != null) {
            ref.read(taskProvider.notifier).deleteTask(widget.task.id!);
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task "${widget.task.name}" deleted'),
              ),
            );
          }
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: cardTheme.shape,
                title: Text("Confirm", style: textTheme.titleLarge),
                content: Text(
                  "Are you sure you want to delete this task?",
                  style: textTheme.bodyMedium,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE"),
                  ),
                ],
              );
            },
          );
        } else {
          final bool isCompleted = widget.task.isCompleted;
          final confirm = await _showCompleteConfirmDialog(
            context,
            isCompleted,
          );

          if (confirm == true) {
            final updatedTask = widget.task.copyWith(
              isCompleted: !isCompleted,
            );
            ref.read(taskProvider.notifier).updateTask(updatedTask);
          }
          return false;
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: widget.task.isCompleted ? Colors.orange : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          widget.task.isCompleted ? Icons.undo : Icons.check_circle,
          color: Colors.white,
        ),
      ),
      child: TaskCard(task: widget.task, showDate: widget.showDate),
    );
  }

  Future<bool?> _showCompleteConfirmDialog(
    BuildContext context,
    bool isCompleted,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Theme.of(context).cardTheme.shape,
          title: Text(
            isCompleted ? "Mark as Pending" : "Complete Task",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            "Are you sure you want to mark this task as ${isCompleted ? 'pending' : 'completed'}?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(isCompleted ? "MARK PENDING" : "COMPLETE"),
            ),
          ],
        );
      },
    );
  }
}
