import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static final String _databaseName = "open_library_books.db";
  static final String _tableName = "books";
  DatabaseHelper._init();

  // Get Database singleton object
  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $_tableName (
        id $idType,
        title $textType,
        authors $textType
      )
    ''');
  }

  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await instance.database;
    return await db.insert(_tableName, book);
  }

  Future<Map<String, dynamic>?> getBookById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }

}