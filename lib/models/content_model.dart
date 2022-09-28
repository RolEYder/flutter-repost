import 'package:repost/services/database_service.dart';

class Archived {
  late String? id;
  late String? uid;
  late String? shortcode;
  late int? is_video;
  late String? caption;
  late String? profile_pic_url;
  late String? username;
  late String? display_url;
  late int? is_verified;
  late String? accessibility_caption;
  late List<Map<String, dynamic>>? content;

  Archived(
      this.id,
      this.uid,
      this.shortcode,
      this.is_video,
      this.caption,
      this.profile_pic_url,
      this.username,
      this.display_url,
      this.is_verified,
      this.accessibility_caption,
      this.content);

  Archived.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    uid = map["uid"];
    shortcode = map["shortcode"];
    is_video = map["is_video"];
    caption = map["caption"];
    profile_pic_url = map["profile_pic_url"];
    username = map["username"];
    display_url = map["display_url"];
    is_verified = map["is_verified"];
    accessibility_caption = map["accessibility_caption"];
    content = map["content"];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnArchivedId: id,
      DatabaseHelper.columnArchivedShortcode: shortcode,
      DatabaseHelper.columnArchivedIsVideo: is_video,
      DatabaseHelper.columnArchivedCaption: caption,
      DatabaseHelper.columnArchivedProfilePicUrl: profile_pic_url,
      DatabaseHelper.columnArchivedUsername: username,
      DatabaseHelper.columnArchivedDisplayUrl: display_url,
      DatabaseHelper.columnArchivedIsVerified: is_verified,
      DatabaseHelper.columnArchivedAccessibilityCaption: accessibility_caption,
      DatabaseHelper.columnArchivedContent: content
    };
  }
}
