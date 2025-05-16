import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/class_model.dart';
import '../models/event_model.dart';
import '../models/note_model.dart';
import '../models/profile_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('campus_connect.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    // classes table now matches ClassModel
    await db.execute('''
      CREATE TABLE classes (
        id          $idType,
        courseName  $textType,
        roomNumber  $textType,
        professor   $textType,
        materials   $textType
        dateTime    $textType
      )
    ''');

    // events table (unchanged) ...
    await db.execute('''
      CREATE TABLE events (
        id          $idType,
        title       $textType,
        description $textType,
        dateTime    $textType,
        dateTime    $textType,
        category    $textType,
        isRSVP      INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // notes table (unchanged) ...
    await db.execute('''
      CREATE TABLE notes (
        id          $idType,
        title       $textType,
        content     $textType,
        timestamp   $textType
      )
    ''');

    // profile table (unchanged) ...
    await db.execute('''
      CREATE TABLE profile (
        id                   INTEGER PRIMARY KEY,
        name                 $textType,
        notificationsEnabled INTEGER NOT NULL DEFAULT 1,
        syncEnabled          INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // seed default profile
    await db.insert('profile', {
      'id': 1,
      'name': 'Your Name',
      'notificationsEnabled': 1,
      'syncEnabled': 0,
    });
  }

  // ── Classes CRUD ─────────────────────────────────────────────────────────────

  Future<ClassModel> createClass(ClassModel c) async {
    final db = await database;
    final id = await db.insert('classes', c.toMap());
    return c.copyWith(id: id);
  }

  Future<ClassModel?> getClass(int id) async {
    final db = await database;
    final maps = await db.query('classes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      // inject the 'key' field as empty for local rows
      maps.first['key'] = '';
      return ClassModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ClassModel>> getAllClasses() async {
    final db = await database;
    final result = await db.query('classes');
    return result.map((m) {
      m['key'] = '';
      return ClassModel.fromMap(m);
    }).toList();
  }

  Future<int> updateClass(ClassModel c) async {
    final db = await database;
    return db.update(
      'classes',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  Future<int> deleteClass(int id) async {
    final db = await database;
    return db.delete('classes', where: 'id = ?', whereArgs: [id]);
  }

  // ── Events CRUD ──────────────────────────────────────────────────────────────

  Future<EventModel> createEvent(EventModel e) async {
    final db = await database;
    final id = await db.insert('events', e.toMap());
    return e.copyWith(id: id);
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    final result = await db.query('events');
    return result.map((m) => EventModel.fromMap(m)).toList();
  }

  Future<int> updateEvent(EventModel e) async {
    final db = await database;
    return db.update(
      'events',
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  // ── Notes CRUD ───────────────────────────────────────────────────────────────

  Future<NoteModel> createNote(NoteModel n) async {
    final db = await database;
    final id = await db.insert('notes', n.toMap());
    return n.copyWith(id: id);
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes');
    return result.map((m) => NoteModel.fromMap(m)).toList();
  }

  Future<int> updateNote(NoteModel n) async {
    final db = await database;
    return db.update(
      'notes',
      n.toMap(),
      where: 'id = ?',
      whereArgs: [n.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ── Profile CRUD ─────────────────────────────────────────────────────────────

  Future<ProfileModel> getProfile() async {
    final db = await database;
    final rows = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (rows.isNotEmpty) return ProfileModel.fromMap(rows.first);

    final defaultProfile = ProfileModel(
      id: 1,
      name: 'Your Name',
      notificationsEnabled: true,
      syncEnabled: false,
    );
    await db.insert('profile', defaultProfile.toMap());
    return defaultProfile;
  }

  Future<int> updateProfile(ProfileModel p) async {
    final db = await database;
    return db.update(
      'profile',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future close() async {
    final db = await database;
    await db.close();
  }
}
