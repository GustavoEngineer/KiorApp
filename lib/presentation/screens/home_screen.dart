import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart';
import 'package:kiorapp/presentation/screens/tags_screen.dart';
import 'package:kiorapp/presentation/widgets/horizontal_date_picker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _selectedDate = () {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }();

  final GlobalKey<HorizontalDatePickerState> _datePickerKey =
      GlobalKey<HorizontalDatePickerState>();
  bool _showGoToTodayButton = false;

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

  void _onDateSelected(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newDate = DateTime(date.year, date.month, date.day);

    setState(() {
      _selectedDate = newDate;
      _showGoToTodayButton = newDate != today;
    });
  }

  bool _isTodaySelected() {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskProvider);
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;

    final tasks = allTasks.where((task) {
      if (task.dueDate == null) {
        // Show tasks without a due date only on the current day if they are not completed
        final now = DateTime.now();
        return !task.isCompleted &&
            _selectedDate.year == now.year &&
            _selectedDate.month == now.month &&
            _selectedDate.day == now.day;
      }
      return task.dueDate!.year == _selectedDate.year &&
          task.dueDate!.month == _selectedDate.month &&
          task.dueDate!.day == _selectedDate.day;
    }).toList();

    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.local_offer,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TagsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              DateFormat.MMMM('es_ES').format(_selectedDate).toUpperCase(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          HorizontalDatePicker(
            key: _datePickerKey,
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
            initialDate: DateTime.now(),
          ),
          Expanded(
            child: ListView.builder(
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
                          SnackBar(
                            content: Text('Task "${task.name}" deleted'),
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
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
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
                        final updatedTask = task.copyWith(
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
                    color: task.isCompleted ? Colors.orange : Colors.green,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Icon(
                      task.isCompleted ? Icons.undo : Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Opacity(
                        opacity: task.isCompleted ? 0.5 : 1.0,
                        child: Card(
                          child: InkWell(
                            borderRadius:
                                (cardTheme.shape as RoundedRectangleBorder?)
                                    ?.borderRadius
                                    .resolve(Directionality.of(context)),
                            onTap: () =>
                                _navigateToEditTask(context, ref, task),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (task.dueDate != null &&
                                      (task.dueDate!.day != today.day ||
                                          task.dueDate!.month != today.month ||
                                          task.dueDate!.year !=
                                              today.year)) ...[
                                    Text(
                                      task.dueDate!.toLocal().toString().split(
                                        ' ',
                                      )[0],
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isTodaySelected()) ...[
            SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'goToToday',
                onPressed: () {
                  final today = DateTime.now();
                  _onDateSelected(today);
                  _datePickerKey.currentState!.scrollToDate(today);
                },
                child: const Icon(Icons.today, size: 20),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FloatingActionButton(
            heroTag: 'addTask',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      NewTaskScreen(selectedDate: _selectedDate),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
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
