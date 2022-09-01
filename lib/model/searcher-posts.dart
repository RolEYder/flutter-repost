import 'dart:core';

import 'package:repost/db/db_sqlite_helper.dart';

class SearchersPosts {
  late int? id;
  late String? uid;
  late String? content;
  late String? thumbnailpic;
  late String? profilepic;
  late String? username;
  late String? created_at;

  SearchersPosts(this.id, this.uid, this.content, this.thumbnailpic,
      this.profilepic, this.username, this.created_at);

  SearchersPosts.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    uid = map["uid"];
    content = map['content'];
    thumbnailpic = map['thumbnailpic'];
    profilepic = map['profilepic'];
    username  = map['username'];
    created_at = map['created_at'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnIdSchedulePosts: id, DatabaseHelper.columnCodePostSearches: uid,
      DatabaseHelper.columnContentPostsSearches: content,
     DatabaseHelper.columnThumbnailPicPostsSearches:thumbnailpic,
      DatabaseHelper.columnProfilePicPostsSearches: profilepic, DatabaseHelper.columnUsernamePostsSearches: username,
      DatabaseHelper.columnCreatedAtPostsSearches: created_at
    };
  }
}