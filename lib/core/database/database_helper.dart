import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final script = await rootBundle.loadString('lib/core/database/script.sql');
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
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN priority INTEGER DEFAULT 0",
      );
    }
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE tasks ADD COLUMN estimated_time REAL");
    }
  }
}
