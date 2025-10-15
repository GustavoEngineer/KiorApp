import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/core/database/database_helper.dart';

class TaskRepository {
  final dbHelper = DatabaseHelper();

  Future<int> insertTask(Task task) async {
    final db = await dbHelper.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await dbHelper.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await dbHelper.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
