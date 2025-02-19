// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watermark_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatermarkBrand _$WatermarkBrandFromJson(Map<String, dynamic> json) =>
    WatermarkBrand(
      logoPath: json['logoPath'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatermarkBrandToJson(WatermarkBrand instance) =>
    <String, dynamic>{
      'logoPath': instance.logoPath,
      'id': instance.id,
    };
