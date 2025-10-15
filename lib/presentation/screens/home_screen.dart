import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart';
import 'package:kiorapp/presentation/screens/tags_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Task',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            if (tasks.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${tasks.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tag, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TagsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                if (task.id != null) {
                  ref.read(taskProvider.notifier).deleteTask(task.id!);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task "${task.name}" deleted')),
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
                      title: const Text("Confirm"),
                      content: const Text(
                        "Are you sure you want to delete this task?",
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
                final bool isCompleted = task.isCompleted;
                final confirm = await _showCompleteConfirmDialog(
                  context,
                  isCompleted,
                );

                if (confirm == true) {
                  final updatedTask = task.copyWith(isCompleted: !isCompleted);
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
              color: task.isCompleted ? Colors.orange : Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                task.isCompleted ? Icons.undo : Icons.check_circle,
                color: Colors.white,
              ),
            ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shadowColor: Colors.black.withAlpha((255 * 0.2).round()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: task.isCompleted ? Colors.grey[300] : Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () => _navigateToEditTask(context, ref, task),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.dueDate != null) ...[
                            Text(
                              task.dueDate!.toLocal().toString().split(' ')[0],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            task.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: task.isCompleted
                                  ? Colors.grey.shade700
                                  : Colors.black,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
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
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Task'),
        ],
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewTaskScreen()),
            );
            if (result == true) {
              ref.read(taskProvider.notifier).loadTasks();
            }
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
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
          title: Text(isCompleted ? "Mark as Pending" : "Complete Task"),
          content: Text(
            "Are you sure you want to mark this task as ${isCompleted ? 'pending' : 'completed'}?",
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
