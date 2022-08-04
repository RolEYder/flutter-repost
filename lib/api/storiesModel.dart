import 'dart:convert';

List<StoriesModel> storiesModelFromJson(String str) => List<StoriesModel>.from(
    json.decode(str).map((x) => StoriesModel.fromJson(x)));

class StoriesModel {
  StoriesModel({
    required this.id,
    required this.take_at,
    required this.exporing_at,
    required this.media_type,
    required this.image_version2,
    required this.original_width,
    required this.original_height,
  });
  int id;
  int take_at;
  int exporing_at;
  int media_type;
  Object image_version2;
  int original_width;
  int original_height;
  factory StoriesModel.fromJson(Map<String, dynamic> json) => StoriesModel(
        id: json["id"],
        take_at: json["take_at"],
        exporing_at: json["exporing_at"],
        media_type: json["media_type"],
        image_version2: json["image_version2"],
        original_width: json["original_width"],
        original_height: json["original_height"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "take_at": take_at,
        "exporing_at": exporing_at,
        "media_type": media_type,
        "image_version2": image_version2,
        "original_width": original_width,
        "original_height": original_height,
      };
}
