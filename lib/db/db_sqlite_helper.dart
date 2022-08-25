import '../model/caption.dart';
import '../model/schedule-post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' show Database, Sqflite, getDatabasesPath, openDatabase, databaseFactory;

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  /// table captions
  static final table = "captions";
  static final columnId = "id";
  static final columnContent = "content";
  static final columnTitle = "title";
  ///table schedules
  static final tableSchedulePosts = "schedule_post";
  static final columnIdSchedulePosts= "id";
  static final columnTitleSchedulePosts = "title";
  static final columnContentSchedulePosts = "content";
  static final columnPhotoSchedulePosts = "photo";
  static final columnDateEndSchedulePosts = "date_end";
  static final columnCreateAtSchedulePosts = "created_at";
  static final columnHashtagsSchedulePosts = "hashtags";


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, _databaseName), onCreate: _onCreate);
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL 
        );
''');
    await db.execute('''
      CREATE TABLE $tableSchedulePosts (
        $columnIdSchedulePosts  INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitleSchedulePosts TEXT NOT NULL,
        $columnContentSchedulePosts TEXT NOT NULL,
        $columnPhotoSchedulePosts TEXT NOT NULL,
        $columnDateEndSchedulePosts TEXT NOT NULL,
        $columnCreateAtSchedulePosts TEXT NOT NULL, 
        $columnHashtagsSchedulePosts TEXT NOT NULL
      )
    ''');
  }


  // Helper methods
  Future<int> insert_schedule_post(SchedulePosts schedulePosts) async {
    Database? db = await instance.database;
    return await db!.insert(tableSchedulePosts, {"title": schedulePosts.title, "content": schedulePosts.content,
    "photo": schedulePosts.photo, "date_end": schedulePosts.date_end, "created_at": schedulePosts.created_at, "hashtags": schedulePosts.hashtags});
  }
  Future<int> insert(Captions caption) async {
    Database? db = await instance.database;
    return await db!.insert(table, {"content": caption.content, "title": caption.title});
  }


  // get all rows
  Future<List<Map<String, dynamic>>> getAllSchedulePostsRows() async {
    Database? db = await instance.database;
    return db!.query(tableSchedulePosts);
  }
  Future<List<Map<String, dynamic>>> getAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // query row
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database? db = await instance.database;
    return await db!.query(table, where: "$columnContent LIKE '%name%'");
  }

  // query row count
  Future<int?> getRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT (*) FROM $table'));
  }

  // update
  Future<int> update(Captions caption) async {
    Database? db = await instance.database;
    int id = caption.toMap()['id'];
    return await db!.update(table, caption.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  // delete
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }


  Future<int> DropTableByName(String tableName) async {
   try {
     String path = await getDatabasesPath();
     Database db = await openDatabase(path);
     await db.execute("DROP TABLE IF EXISTS $tableName");
   }
   catch (e) {
     print(e);
   }
   throw (e) {
     print(e);
   };
  }
  // delete databse
Future<Database> deleteDatabase() async{
    try {
      String path = await getDatabasesPath();
      databaseFactory.deleteDatabase(join(path, _databaseName));
    }
    catch(e) {
      print(e);
    }
    throw (e) {
      print(e);
    };
}
}

