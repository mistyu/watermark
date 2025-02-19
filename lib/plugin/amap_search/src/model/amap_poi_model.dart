/*
 * @Author: 丁健
 * @Date: 2022-04-01 11:24:12
 * @LastEditTime: 2022-04-01 11:24:13
 * @LastEditors: 丁健
 * @Description: 
 * @FilePath: /amap_flutter_search/lib/model/amap_poi_model.dart
 * 可以输入预定的版权声明、个性签名、空行等
 */

import 'amap_geocode.dart';

class AMapPoi {
  String? adcode; // 行政区划代码
  String? address; // 地址
  String? businessArea; // 商圈
  String? city; // 城市
  String? province; // 省/自治区/直辖市/特别行政区名称
  String? citycode; // 城市编码
  String? direction; // 方向
  int? distance; // 距离
  String? district; // 行政区划名称
  String? email; // 邮箱
  String? gridcode; // 网格编码
  bool? hasIndoorMap; // 是否有室内地图
  Location? location; // 经纬度
  String? name; // 名称
  String? parkingType; // 停车场类型
  String? pcode; // 省编码

  AMapPoi(
      {this.adcode,
      this.address,
      this.businessArea,
      this.city,
      this.province,
      this.citycode,
      this.direction,
      this.distance,
      this.district,
      this.email,
      this.gridcode,
      this.hasIndoorMap,
      this.location,
      this.name,
      this.parkingType,
      this.pcode});

  AMapPoi.fromJson(Map json) {
    json = Map<String, dynamic>.from(json);
    adcode = json["adcode"];
    address = json["address"];
    businessArea = json["businessArea"];
    city = json["city"];
    province = json['province'] ?? '';
    citycode = json["citycode"];
    direction = json["direction"];
    distance = json["distance"];
    district = json["district"];
    email = json["email"];
    gridcode = json["gridcode"];
    hasIndoorMap = json["hasIndoorMap"];
    location =
        json["location"] == null ? null : Location.fromJson(json["location"]);
    name = json["name"];
    parkingType = json["parkingType"];
    pcode = json["pcode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["adcode"] = adcode;
    data["address"] = address;
    data["businessArea"] = businessArea;
    data["city"] = city;
    data['province'] = province;
    data["citycode"] = citycode;
    data["direction"] = direction;
    data["distance"] = distance;
    data["district"] = district;
    data["email"] = email;
    data["gridcode"] = gridcode;
    data["hasIndoorMap"] = hasIndoorMap;
    if (location != null) data["location"] = location?.toJson();
    data["name"] = name;
    data["parkingType"] = parkingType;
    data["pcode"] = pcode;
    return data;
  }

  String get fullAddress => '$city$district$address·$name';
}
