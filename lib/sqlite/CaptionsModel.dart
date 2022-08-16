import 'dbSqliteHelper.dart';

class Caption {
  late final int id;
  late final String content;

  Caption(this.id, this.content);

  Caption.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    content = map["content"];
  }

  Map<String, dynamic> toMap() {
    return {};
  }
}
