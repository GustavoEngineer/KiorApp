import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kiorapp/models/tag.dart';
import 'package:kiorapp/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final script = await rootBundle.loadString('lib/database/script.sql');
    final statements = script.split(';');
    for (final statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE tasks ADD COLUMN start_date INTEGER");
      await db.execute("ALTER TABLE tasks ADD COLUMN priority INTEGER DEFAULT 0");
    }
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    await db.delete('task_tags', where: 'task_id = ?', whereArgs: [id]);
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTag(Tag tag) async {
    Database db = await database;
    return await db.insert('tags', tag.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> insertTaskWithTags(Task task, List<Tag> tags) async {
    final db = await database;
    await db.transaction((txn) async {
      int taskId = await txn.insert('tasks', task.toMap());
      for (Tag tag in tags) {
        await txn.insert('task_tags', {'task_id': taskId, 'tag_id': tag.id});
      }
    });
  }

  Future<List<Tag>> getTagsForTask(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT t.* FROM tags t
    INNER JOIN task_tags tt ON t.id = tt.tag_id
    WHERE tt.task_id = ?
  ''', [taskId]);
    return maps.map((map) => Tag.fromMap(map)).toList();
  }

  Future<List<Tag>> getTags() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tags');
    return maps.map((m) => Tag.fromMap(m)).toList();
  }

  Future<int> deleteTag(int id) async {
    Database db = await database;
    return await db.delete('tags', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTag(Tag tag) async {
    Database db = await database;
    return await db.update('tags', tag.toMap(), where: 'id = ?', whereArgs: [tag.id]);
  }
}
