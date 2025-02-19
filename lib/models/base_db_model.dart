abstract class BaseDBModel {
  String get tableName;

  String get createTableSql;

  Map<String, dynamic> toJson();

  BaseDBModel fromJson(Map<String, dynamic> json);
}
