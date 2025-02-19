import 'package:json_annotation/json_annotation.dart';

part 'location_result.g.dart';

@JsonSerializable()
class LocationResult {
  double? latitude; // 纬度
  double? longitude; // 经度
  double? accuracy; // 精度
  double? altitude; // 海拔
  double? bearing; // 方位
  double? speed; // 速度
  String? country; // 国家
  String? province; // 省份
  String? city; // 城市
  String? district; // 行政区划名称
  String? street; // 街道
  String? streetNumber; // 街道号
  String? cityCode; // 城市编码
  String? adCode; // 行政区划代码
  String? address; // 地址
  String? description; // 描述

  LocationResult({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.bearing,
    this.speed,
    this.country,
    this.province,
    this.city,
    this.district,
    this.street,
    this.streetNumber,
    this.cityCode,
    this.adCode,
    this.address,
    this.description,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) =>
      _$LocationResultFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResultToJson(this);

  String get fullAddress {
    final baseAddress = '$province$city$district$street$streetNumber';
    if (description == null) return baseAddress.replaceAll('null', '');

    // Remove any parts from description that are already in baseAddress
    String uniqueDesc = description!;
    for (var part in [province, city, district, street, streetNumber]) {
      if (part != null) {
        uniqueDesc = uniqueDesc
            .replaceAll(part, '')
            .replaceAll('在', '')
            .replaceAll('附近', '');
      }
    }

    return uniqueDesc.isEmpty ? baseAddress : '$baseAddress·$uniqueDesc';
  }
}
