// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watermark_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatermarkBrand _$WatermarkBrandFromJson(Map<String, dynamic> json) =>
    WatermarkBrand(
      logoUrl: json['logoUrl'] as String?,
      logoName: json['logoName'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatermarkBrandToJson(WatermarkBrand instance) =>
    <String, dynamic>{
      'logoUrl': instance.logoUrl,
      'logoName': instance.logoName,
      'id': instance.id,
    };
