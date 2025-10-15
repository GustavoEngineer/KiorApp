import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/data/repositories/task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref.watch(taskRepositoryProvider));
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _taskRepository;

  TaskNotifier(this._taskRepository) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await _taskRepository.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    loadTasks();
  }
}
