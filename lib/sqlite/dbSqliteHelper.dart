import 'CaptionsModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  static final table = "captions";
  static final columnId = "id";
  static final columnContent = "content";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database = DatabaseHelper._database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
            $columnId INTERGER PRIMARY KEY AUTOINCREMENT,
            $columnContent TEXT NOT NULL
        )
''');
  }

  // Helper methods
  Future<int> insert(Caption caption) async {
    Database db = await instance.database;
    return await db.insert(table, {"content": caption.content});
  }

  // get all rows
  Future<List<Map<String, dynamic>>> getAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // query row
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnContent LIKE '%name%'");
  }

  // query row count
  Future<int?> getRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM $table'));
  }

  // update
  Future<int> update(Caption caption) async {
    Database db = await instance.database;
    int id = caption.toMap()['id'];
    return await db.update(table, caption.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  // delete
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
