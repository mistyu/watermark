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
  String? name;
  String? location;
  String? poiId;

  LocationModel({
    this.address,
    this.type,
    this.name,
    this.location,
    this.poiId,
  });

  @override
  String get tableName => 'locations';

  @override
  String get createTableSql => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      address TEXT,
      type INTEGER,
      name TEXT,
      location TEXT,
      poiId TEXT
    )
  ''';

  @override
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'type': type?.index,
      'name': name,
      'location': location,
      'poiId': poiId,
    };
  }

  @override
  LocationModel fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] as String?,
      type: json['type'] != null
          ? LocationType.values[json['type'] as int]
          : null,
      name: json['name'] as String?,
      location: json['location'] as String?,
      poiId: json['poiId'] as String?,
    );
  }
}
