import 'package:sqflite/sqflite.dart';

import '../db/db_sqlite_helper.dart';
import 'dart:typed_data';
class SchedulePosts {
  late int? id;
  late String? content;
  late String? title;
  late String? photo;
  late String? date_end;
  late String? hashtags;
  late String? created_at;

  SchedulePosts(this.id, this.title, this.content, this.photo, this.date_end, this.created_at, this.hashtags);

  SchedulePosts.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    content = map["content"];
    photo = map["photo"];
    created_at  = map["created_at"];
    date_end = map["date_end"];
    hashtags = map["hashtags"];
  }

  Map<String, dynamic> toMap() {
    return {DatabaseHelper.columnIdSchedulePosts: id, DatabaseHelper.columnTitleSchedulePosts: title , DatabaseHelper.columnContentSchedulePosts: content,
    DatabaseHelper.columnPhotoSchedulePosts: photo, DatabaseHelper.columnDateEndSchedulePosts: date_end, DatabaseHelper.columnCreateAtSchedulePosts: created_at,
      DatabaseHelper.columnHashtagsSchedulePosts: hashtags};
  }
}
