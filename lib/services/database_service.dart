import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:repost/models/content_model.dart';
import 'package:repost/models/searcherPost_model.dart';
import 'package:repost/models/caption_model.dart';
import 'package:repost/models/schedulepPost_model.dart';
import 'package:path/path.dart';
import 'dart:convert' show JsonEncoder, jsonDecode, jsonEncode, utf8;
import 'package:repost/models/stories_repost_model.dart';
import 'package:sqflite/sqflite.dart'
    show Database, Sqflite, getDatabasesPath, openDatabase, databaseFactory;

import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  /// table captions
  static final table = "captions";
  static final columnId = "id";
  static final columnContent = "content";
  static final columnTitle = "title";

  /// table archived
  static final tableArchived = "archived";
  static final columnArchivedId = "id";
  static final columnArchivedUid = "uid";
  static final columnArchivedShortcode = "shortcode";
  static final columnArchivedIsVideo = "is_video";
  static final columnArchivedCaption = "caption";
  static final columnArchivedProfilePicUrl = "profile_pic_url";
  static final columnArchivedUsername = "username";
  static final columnArchivedDisplayUrl = "display_url";
  static final columnArchivedIsVerified = "is_verified";
  static final columnArchivedAccessibilityCaption = "accessibility_caption";
  static final columnArchivedContent = "content";

  ///table posts schedules
  static final tableSchedulePosts = "schedule_post";
  static final columnIdSchedulePosts = "id";
  static final columnUsernameSchedulePost = "username";
  static final columnProfilePicSchedulePost = "profile_pic";
  static final columnTitleSchedulePosts = "title";
  static final columnContentSchedulePosts = "content";
  static final columnPhotoSchedulePosts = "photo";
  static final columnDateEndSchedulePosts = "date_end";
  static final columnCreateAtSchedulePosts = "created_at";
  static final columnHashtagsSchedulePosts = "hashtags";

  /// table stories schedules
  static final tableScheduleStories = "schedule_story";
  static final columnIdScheduleStories = "id";
  static final columnCreateAtScheduleStories = "created_at";
  static final columnDateEndScheduleStories = "date_end";
  static final columnUrlScheduleStories = "url";
  static final columnMediaTypelScheduleStories = "media_type";

  /// table post-searches
  static final tablePostsSearches = "searches_posts";
  static final columnIdPostsSearches = "id";
  static final columnCodePostSearches = "uid";
  static final columnContentPostsSearches = "content";
  static final columnTitlePostsSearches = "title";
  static final columnProfilePicPostsSearches = "profilepic";
  static final columnThumbnailPicPostsSearches = "thumbnailpic";
  static final columnUsernamePostsSearches = "username";
  static final columnCreatedAtPostsSearches = "created_at";

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
        $columnUsernamePostsSearches TEXT NOT NULL,
        $columnProfilePicSchedulePost TEXT NOT NULL,
        $columnContentSchedulePosts TEXT NOT NULL,
        $columnPhotoSchedulePosts TEXT NOT NULL,
        $columnDateEndSchedulePosts TEXT NOT NULL,
        $columnCreateAtSchedulePosts TEXT NOT NULL, 
        $columnHashtagsSchedulePosts TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePostsSearches (
        $columnIdPostsSearches INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCodePostSearches TEXT NOT NULL, 
        $columnContentPostsSearches TEXT NOT NULL, 
        $columnProfilePicPostsSearches TEXT NOT NULL,
        $columnThumbnailPicPostsSearches TEXT NOT NULL,
        $columnUsernamePostsSearches TEXT NOT NULL,
        $columnCreatedAtPostsSearches TEXT NOT NULL
      )

    ''');
    await db.execute(''' 
    CREATE TABLE $tableArchived (
      $columnArchivedId  INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnArchivedUid TEXT NOT NULL,
      $columnArchivedShortcode TEXT NOT NULL,
      $columnArchivedIsVideo INTERGER NOT NULL,
      $columnArchivedCaption TEXT NOT NULL,
      $columnArchivedProfilePicUrl TEXT NOT NULL,
      $columnArchivedUsername TEXT NOT NULL,
      $columnArchivedDisplayUrl TEXT NOT NULL,
      $columnArchivedIsVerified INTEGER NOT NULL, 
      $columnArchivedAccessibilityCaption TEXT NOT NULL,
      $columnArchivedContent TEXT NOT NULL
    )
    ''');
    await db.execute('''
        CREATE TABLE $tableScheduleStories (
        $columnIdScheduleStories INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnCreateAtScheduleStories TEXT NOT NULL, 
        $columnDateEndScheduleStories TEXT NOT NULL, 
        $columnUrlScheduleStories TEXT NOT NULL, 
        $columnMediaTypelScheduleStories INT NOT NULL
        )
      ''');
  }

  Future<int> insert_archived(Archived archived) async {
    try {
      // check if the archvied already exists
      final res = await getArchivedByUid(archived.uid.toString());
      if (res == 0) {
        Database? db = await instance.database;
        return await db!.insert(tableArchived, {
          "uid": archived.uid.toString(),
          "shortcode": archived.shortcode.toString(),
          "is_video": archived.is_video,
          "caption": archived.caption.toString(),
          "profile_pic_url": archived.profile_pic_url.toString(),
          "username": archived.username.toString(),
          "display_url": archived.display_url.toString(),
          "is_verified": archived.is_verified,
          "accessibility_caption": archived.accessibility_caption.toString(),
          "content": jsonEncode(archived.content)
        });
      }
    } catch (Exception) {
      print(Exception);
      rethrow;
    }
    return 1;
  }

  // Helper methods
  Future<int> insert_searcher_post(SearchersPosts searchersPosts) async {
    try {
      // check if the post already exists
      final response = await getPostByUid(searchersPosts.uid.toString());
      log(response.toString());
      if (response == 0) {
        Database? db = await instance.database;
        return await db!.insert(tablePostsSearches, {
          "uid": searchersPosts.uid.toString(),
          "content": searchersPosts.content.toString(),
          "profilepic": searchersPosts.profilepic.toString(),
          "thumbnailpic": searchersPosts.thumbnailpic.toString(),
          "username": searchersPosts.username.toString(),
          "created_at": searchersPosts.created_at.toString()
        });
      }
    } catch (Exception) {
      print(Exception);
      rethrow;
    }
    return 0;
  }

  Future<int> insert_schedule_story(StoryRepost storyRepost) async {
    Database? db = await instance.database;
    return await db!.insert(tableScheduleStories, {
      "date_end": storyRepost.date_end,
      "create_at": storyRepost.create_at,
      "media_type": storyRepost.media_type,
      "url": storyRepost.url,
    });
  }

  Future<int> insert_schedule_post(SchedulePosts schedulePosts) async {
    Database? db = await instance.database;
    return await db!.insert(tableSchedulePosts, {
      "profile_pic": schedulePosts.profile_pic,
      "username": schedulePosts.username,
      "title": schedulePosts.title,
      "content": schedulePosts.content,
      "photo": schedulePosts.photo,
      "date_end": schedulePosts.date_end,
      "created_at": schedulePosts.created_at,
      "hashtags": schedulePosts.hashtags
    });
  }

  Future<int> insert(Captions caption) async {
    Database? db = await instance.database;
    return await db!
        .insert(table, {"content": caption.content, "title": caption.title});
  }

  /// get all archived
  Future<List<Map<String, dynamic>>> get_all_archived_rows() async {
    Database? db = await instance.database;
    return await db!.query(tableArchived);
  }

  Future<List<Map<String, dynamic>>> getAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> getAllSearchersRowsPosts() async {
    Database? db = await instance.database;
    return await db!.query(tablePostsSearches);
  }

  // get all schedule post
  Future<List<Map<String, dynamic>>> getAllSchedulePosts() async {
    Database? db = await instance.database;
    return await db!.query(tableSchedulePosts);
  }

  // query row
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database? db = await instance.database;
    return await db!.query(table, where: "$columnContent LIKE '%name%'");
  }

  // get a archived by Shortcode
  Future<int?> getArchivedByUid(String _uid) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery(
        'SELECT COUNT (*) FROM $tableArchived WHERE $columnArchivedUid = $_uid'));
  }

  // get a post by uid
  Future<int?> getPostByUid(String _uid) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery(
        'SELECT COUNT (*) FROM $tablePostsSearches WHERE $columnCodePostSearches = $_uid'));
  }

  // query row count
  Future<int?> getRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT (*) FROM $table'));
  }

  // clean history recent post
  Future<int?> cleanHistory() async {
    Database? db = await instance.database;
    return await db!.delete(tablePostsSearches);
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
    } catch (e) {
      print(e);
    }
    throw (e) {
      print(e);
    };
  }

  // delete databse
  Future<Database> deleteDatabase() async {
    try {
      String path = await getDatabasesPath();
      databaseFactory.deleteDatabase(join(path, _databaseName));
    } catch (e) {
      print(e);
    }
    throw (e) {
      print(e);
    };
  }
}
