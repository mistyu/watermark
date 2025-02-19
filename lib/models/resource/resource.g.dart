// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      zipUrl: json['zipUrl'] as String?,
    );

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'cover': instance.cover,
      'zipUrl': instance.zipUrl,
    };

WatermarkResource _$WatermarkResourceFromJson(Map<String, dynamic> json) =>
    WatermarkResource(
      id: (json['id'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      zipUrl: json['zipUrl'] as String?,
      status: (json['status'] as num?)?.toInt(),
      cid: (json['cid'] as num?)?.toInt(),
      title: json['title'] as String?,
      canShare: (json['canShare'] as num?)?.toInt(),
      editType: (json['editType'] as num?)?.toInt(),
      demoUrl: json['demoUrl'] as String?,
      isHot: (json['isHot'] as num?)?.toInt(),
      isVip: (json['isVip'] as num?)?.toInt(),
      updatedDt: json['updatedDt'] as String?,
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatermarkResourceToJson(WatermarkResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'cover': instance.cover,
      'zipUrl': instance.zipUrl,
      'cid': instance.cid,
      'title': instance.title,
      'canShare': instance.canShare,
      'editType': instance.editType,
      'demoUrl': instance.demoUrl,
      'isHot': instance.isHot,
      'isVip': instance.isVip,
      'updatedDt': instance.updatedDt,
      'updatedAt': instance.updatedAt,
    };

RightBottomResource _$RightBottomResourceFromJson(Map<String, dynamic> json) =>
    RightBottomResource(
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      zipUrl: json['zipUrl'] as String?,
      rid: (json['rid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RightBottomResourceToJson(
        RightBottomResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'cover': instance.cover,
      'zipUrl': instance.zipUrl,
      'rid': instance.rid,
    };
