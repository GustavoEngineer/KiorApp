import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository {
  final dbHelper = DatabaseHelper();

  Future<int> insertTask(Task task) async {
    final db = await dbHelper.database;
    final taskId = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Limpiar etiquetas viejas y guardar las nuevas
    await db.delete('task_tags', where: 'taskId = ?', whereArgs: [taskId]);
    for (final tagId in task.tagIds) {
      await db.insert('task_tags', {'taskId': taskId, 'tagId': tagId});
    }
    return taskId;
  }

  Future<List<Task>> getTasks() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks');
    final List<Task> tasks = [];

    for (final taskMap in taskMaps) {
      final taskId = taskMap['id'];
      final List<Map<String, dynamic>> tagMaps = await db.query(
        'task_tags',
        where: 'taskId = ?',
        whereArgs: [taskId],
      );
      final tagIds = tagMaps.map((map) => map['tagId'] as int).toList();
      tasks.add(Task.fromMap(taskMap, tagIds: tagIds));
    }
    return tasks;
  }

  Future<int> updateTask(Task task) async {
    final db = await dbHelper.database;
    final result = await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    // Limpiar etiquetas viejas y guardar las nuevas
    await db.delete('task_tags', where: 'taskId = ?', whereArgs: [task.id]);
    for (final tagId in task.tagIds) {
      await db.insert('task_tags', {'taskId': task.id, 'tagId': tagId});
    }
    return result;
  }

  Future<int> deleteTask(int id) async {
    final db = await dbHelper.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
