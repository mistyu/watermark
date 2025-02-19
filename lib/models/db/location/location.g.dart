// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      address: json['address'] as String?,
      type: $enumDecodeNullable(_$LocationTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'type': _$LocationTypeEnumMap[instance.type],
    };

const _$LocationTypeEnumMap = {
  LocationType.collect: 'collect',
  LocationType.history: 'history',
};
