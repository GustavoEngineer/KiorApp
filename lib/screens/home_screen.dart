import 'package:flutter/material.dart';
import 'package:kiorapp/database/database_helper.dart';
import 'package:kiorapp/screens/new_task_screen.dart';
import 'package:kiorapp/screens/tags_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await DatabaseHelper().getTasks();
    setState(() {
      _tasks = List.from(tasks); // Create a mutable copy
    });
  }

  void _navigateToEditTask(Map<String, dynamic> task) async {
    final result = await Navigator.of(
      context,
    ).push(TopDownPageRoute(child: NewTaskScreen(task: task)));
    if (result == true) {
      loadTasks();
    }
  }

  void _navigateToNewTask() async {
    final result = await Navigator.of(
      context,
    ).push(TopDownPageRoute(child: const NewTaskScreen()));

    if (result == true) {
      loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (_tasks.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${_tasks.length}',
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
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: ValueKey(task['id']),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) async {
              // This will only be triggered for deletions (startToEnd)
              if (direction == DismissDirection.startToEnd && mounted) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task "${task['name']}" deleted')),
                  );
                }
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                // Swipe Right (Delete)
                final bool? confirmDelete = await showDialog<bool>(
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
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(true), // Confirm deletion
                          child: const Text("DELETE"),
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  await DatabaseHelper().deleteTask(task['id']);
                  setState(() {
                    _tasks.removeAt(index);
                  });
                }
                return confirmDelete; // This will trigger onDismissed if true
              } else {
                // direction == DismissDirection.endToStart (Complete/Uncomplete)
                final bool isCompleted = task['is_completed'] == 1;
                final confirm = await _showCompleteConfirmDialog(isCompleted);

                if (confirm == true) {
                  final updatedTask = {
                    ...task,
                    'is_completed': isCompleted ? 0 : 1,
                  };
                  await DatabaseHelper().updateTask(updatedTask);
                  setState(() {
                    _tasks[index] = updatedTask;
                  });
                }
                // No descartar el item, solo actualizarlo.
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
              color: task['is_completed'] == 1 ? Colors.orange : Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                task['is_completed'] == 1 ? Icons.undo : Icons.check_circle,
                color: Colors.white,
              ),
            ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: task['is_completed'] == 1
                      ? Colors.grey[300]
                      : Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () => _navigateToEditTask(task),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task['due_date'] != null) ...[
                            Text(
                              DateTime.parse(
                                task['due_date'],
                              ).toLocal().toString().split(' ')[0],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            task['name'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: task['is_completed'] == 1
                                  ? Colors.grey.shade700
                                  : Colors.black,
                              decoration: task['is_completed'] == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (task['label'] != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                task['label'],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Future<bool?> _showCompleteConfirmDialog(bool isCompleted) {
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
