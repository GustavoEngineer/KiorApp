import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository {
  final dbHelper = DatabaseHelper();

  Future<int> insertTag(Tag tag) async {
    final db = await dbHelper.database;
    return await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Tag>> getTags() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tags');
    return List.generate(maps.length, (i) {
      return Tag.fromMap(maps[i]);
    });
  }

  Future<int> updateTag(Tag tag) async {
    final db = await dbHelper.database;
    return await db.update(
      'tags',
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<int> deleteTag(int id) async {
    final db = await dbHelper.database;
    return await db.delete('tags', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Tag>> getTagsForTask(int taskId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT t.* FROM tags t
    INNER JOIN task_tags tt ON t.id = tt.tag_id
    WHERE tt.task_id = ?
  ''',
      [taskId],
    );
    return maps.map((map) => Tag.fromMap(map)).toList();
  }
}
