import 'dart:convert';
import 'package:watermark_camera/models/base_db_model.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/logger.dart';

/**
 * 水印设置模型
 */
class WatermarkSettingsModel extends BaseDBModel {
  final int? id;
  final String resourceId;
  final WatermarkView watermarkView;
  final double? scale;
  final DateTime? updatedAt;

  WatermarkSettingsModel({
    this.id,
    required this.resourceId,
    required this.watermarkView,
    this.scale,
    this.updatedAt,
  });

  @override
  String get tableName => 'watermark_settings';

  @override
  String get createTableSql => '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      resource_id TEXT NOT NULL,
      watermark_view TEXT NOT NULL,
      scale REAL,
      updated_at INTEGER,
      UNIQUE(resource_id)
    )
  ''';

  @override
  Map<String, dynamic> toJson() {
    final watermarkViewJson = watermarkView.toJson();
    Logger.print("WatermarkView before encoding: $watermarkViewJson");
    
    final json = {
      'id': id,
      'resource_id': resourceId,
      'watermark_view': jsonEncode(watermarkViewJson),
      'scale': scale,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
    
    Logger.print("Final encoded json: $json");
    return json;
  }

  @override
  WatermarkSettingsModel fromJson(Map<String, dynamic> json) {
    return WatermarkSettingsModel(
      id: json['id'],
      resourceId: json['resource_id'],
      watermarkView:
          WatermarkView.fromJson(jsonDecode(json['watermark_view'] as String)),
      scale: json['scale'],
      updatedAt: json['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'])
          : null,
    );
  }
}
