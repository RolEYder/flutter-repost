import 'dbSqliteHelper.dart';

class Caption {
  late int? id;
  late String? content;

  Caption(this.id, this.content);

  Caption.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    content = map["content"];
  }

  Map<String, dynamic> toMap() {
    return {DatabaseHelper.columnId: id, DatabaseHelper.columnContent: content};
  }
}
