import 'dart:convert';
import 'package:watermark_camera/models/base_db_model.dart';
import 'package:watermark_camera/utils/logger.dart';

/**
 * 保存的水印模型
 * 简化版本，只存储基本信息和引用ID
 */
class WatermarkSaveModel extends BaseDBModel {
  final int? id;
  final String name; // 水印名称（必需）
  final String resourceId; // 原始水印ID（必需）
  final String? url; // 水印URL（可选）
  final String? lockTime; // 锁定的时间（可选）
  final String? lockDate; // 锁定的日期（可选）
  final String? lockAddress; // 锁定的地址（可选）
  final String? lockCoordinates; // 锁定的经纬度（可选）
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WatermarkSaveModel({
    this.id,
    required this.name,
    required this.resourceId,
    this.url,
    this.lockTime,
    this.lockDate,
    this.lockAddress,
    this.lockCoordinates,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String get tableName => 'watermark_save';

  @override
  String get createTableSql => '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      resource_id TEXT NOT NULL,
      url TEXT,
      lock_time TEXT,
      lock_date TEXT,
      lock_address TEXT,
      lock_coordinates TEXT,
      created_at INTEGER,
      updated_at INTEGER
    )
  ''';

  @override
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'resource_id': resourceId,
      'url': url,
      'lock_time': lockTime,
      'lock_date': lockDate,
      'lock_address': lockAddress,
      'lock_coordinates': lockCoordinates,
      'created_at': createdAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    };

    return json;
  }

  @override
  WatermarkSaveModel fromJson(Map<String, dynamic> json) {
    return WatermarkSaveModel(
      id: json['id'],
      name: json['name'],
      resourceId: json['resource_id'],
      url: json['url'],
      lockTime: json['lock_time'],
      lockDate: json['lock_date'],
      lockAddress: json['lock_address'],
      lockCoordinates: json['lock_coordinates'],
      createdAt: json['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'])
          : null,
    );
  }

  // 从WatermarkSaveSettings创建
  factory WatermarkSaveModel.fromSettings({
    required String name,
    required String resourceId,
    String? url,
    String? lockTime,
    String? lockDate,
    String? lockAddress,
    String? lockCoordinates,
  }) {
    return WatermarkSaveModel(
      name: name,
      resourceId: resourceId,
      url: url,
      lockTime: lockTime,
      lockDate: lockDate,
      lockAddress: lockAddress,
      lockCoordinates: lockCoordinates,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // 复制并修改
  WatermarkSaveModel copyWith({
    int? id,
    String? name,
    String? resourceId,
    String? url,
    String? lockTime,
    String? lockDate,
    String? lockAddress,
    String? lockCoordinates,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatermarkSaveModel(
      id: id ?? this.id,
      name: name ?? this.name,
      resourceId: resourceId ?? this.resourceId,
      url: url ?? this.url,
      lockTime: lockTime ?? this.lockTime,
      lockDate: lockDate ?? this.lockDate,
      lockAddress: lockAddress ?? this.lockAddress,
      lockCoordinates: lockCoordinates ?? this.lockCoordinates,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
