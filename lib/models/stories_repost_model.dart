import 'dart:convert';

List<StoryRepost> storiesModelFromJson(String str) => List<StoryRepost>.from(
    json.decode(str).map((x) => StoryRepost.fromJson(x)));

class StoryRepost {
  StoryRepost({
    required this.id,
    required this.create_at,
    required this.date_end,
    required this.media_type,
    required this.url,
  });
  int id;
  String create_at;
  String date_end;
  int media_type;
  String url;
  factory StoryRepost.fromJson(Map<String, dynamic> json) => StoryRepost(
        id: json["id"],
        create_at: json["create_at"],
        date_end: json["date_end"],
        media_type: json["media_type"],
        url: json["url"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": create_at,
        "date_end": date_end,
        "media_type": media_type,
        "url": url,
      };
}
