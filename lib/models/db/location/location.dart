import 'package:json_annotation/json_annotation.dart';
import 'package:watermark_camera/models/base_db_model.dart';

part 'location.g.dart';

enum LocationType {
  collect,
  history,
}

@JsonSerializable()
class LocationModel extends BaseDBModel {
  String? address;

  LocationType? type;

  LocationModel({
    this.address,
    this.type,
  });

  @override
  String get tableName => 'locations';

  @override
  String get createTableSql => '''
      CREATE TABLE IF NOT EXISTS locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT NOT NULL,
        type INTEGER
      )
    ''';

  @override
  LocationModel fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
