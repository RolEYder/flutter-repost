import 'package:repost/services/database_service.dart';

class SchedulePosts {
  late int? id;
  late String? content;
  late String? title;
  late String? photo;
  late String? date_end;
  late String? hashtags;
  late String? created_at;
  late String? username;
  late String? profile_pic;

  SchedulePosts(this.id, this.title, this.content, this.photo, this.date_end,
      this.created_at, this.hashtags, this.username, this.profile_pic);

  SchedulePosts.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    content = map["content"];
    photo = map["photo"];
    created_at = map["created_at"];
    date_end = map["date_end"];
    hashtags = map["hashtags"];
    username = map["username"];
    profile_pic = map["profile_pic"];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnIdSchedulePosts: id,
      DatabaseHelper.columnTitleSchedulePosts: title,
      DatabaseHelper.columnContentSchedulePosts: content,
      DatabaseHelper.columnPhotoSchedulePosts: photo,
      DatabaseHelper.columnDateEndSchedulePosts: date_end,
      DatabaseHelper.columnCreateAtSchedulePosts: created_at,
      DatabaseHelper.columnHashtagsSchedulePosts: hashtags,
      DatabaseHelper.columnUsernamePostsSearches: username,
      DatabaseHelper.columnProfilePicSchedulePost: profile_pic
    };
  }
}
