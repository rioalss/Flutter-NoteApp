import 'dart:developer';

import 'package:notes_app/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  NotesDatabase._init();

  static final NotesDatabase instance = NotesDatabase._init();
  final String tableName = 'notes';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb('notes.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    log("DB path : $dbPath\nFilePath : $filePath");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      time TEXT NOT NULL
    )
    ''');
  }

  Future<NoteModel> create(NoteModel noteModel) async {
    final db = await instance.database;
    final id = await db.insert(tableName, noteModel.toMap());
    log("Create id : $id");
    return noteModel.copyWith(id: id);
  }

  Future<NoteModel> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      columns: ['id', 'title', 'description', 'time'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return NoteModel.fromMap(maps.first);
    } else {
      throw Exception('id $id not found');
    }
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = 'time DESC';
    final result = await db.query(tableName, orderBy: orderBy);
    final res = result.map((e) => NoteModel.fromMap(e)).toList();

    return res;
  }

  Future<int> update(NoteModel noteModel) async {
    final db = await instance.database;
    final update = await db.update(
      tableName,
      noteModel.toMap(),
      where: 'id = ?',
      whereArgs: [noteModel.id],
    );
    log("update : $update");

    return update;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final delete = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    log("delete : $delete");
    return delete;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
