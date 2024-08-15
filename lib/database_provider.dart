import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'year_in_pixels.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE mood_data(date TEXT PRIMARY KEY, mood TEXT, note TEXT)",
        );
      },
    );
  }

  Future<void> insertMoodData(String date, String mood, String note) async {
    final db = await database;
    await db.insert(
      'mood_data',
      {'date': date, 'mood': mood, 'note': note},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, String>?> getMoodData(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mood_data',
      where: 'date = ?',
      whereArgs: [date],
    );
    if (maps.isNotEmpty) {
      return {
        'mood': maps.first['mood'] as String,
        'note': maps.first['note'] as String,
      };
    }
    return null;
  }
}
