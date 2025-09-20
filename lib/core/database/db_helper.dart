import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final db = await database;
    final results = await db.query('users', where: 'uid = ?', whereArgs: [uid]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> deleteUser(String uid) async {
    final db = await database;
    return await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
  }
}
