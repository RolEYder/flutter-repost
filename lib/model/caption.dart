import '../db/db_sqlite_helper.dart';

class Captions {
  late int? id;
  late String? content;
  late String? title;

  Captions(this.id, this.content);

  Captions.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    content = map["content"];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnContent: content
    };
  }
}
