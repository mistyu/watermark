/*
 * @Author: 丁健
 * @Date: 2022-04-01 10:05:24
 * @LastEditTime: 2022-04-01 10:38:55
 * @LastEditors: 丁健
 * @Description: 
 * @FilePath: /amap_flutter_search/lib/model/amap_geocode.dart
 * 可以输入预定的版权声明、个性签名、空行等
 */

class AmapGeocodeModel {
  String? adcode;
  String? building;
  String? city;
  String? citycode;
  String? country;
  String? district;
  String? formattedAddress;
  String? level;
  Location? location;
  String? neighborhood;
  String? postcode;
  String? province;
  String? township;

  AmapGeocodeModel(
      {this.adcode,
      this.building,
      this.city,
      this.citycode,
      this.country,
      this.district,
      this.formattedAddress,
      this.level,
      this.location,
      this.neighborhood,
      this.postcode,
      this.province,
      this.township});

  AmapGeocodeModel.fromJson(Map json) {
    json = Map<String, dynamic>.from(json);
    adcode = json["adcode"];
    building = json["building"];
    city = json["city"];
    citycode = json["citycode"];
    country = json["country"];
    district = json["district"];
    formattedAddress = json["formattedAddress"];
    level = json["level"];
    location =
        json["location"] == null ? null : Location.fromJson(json["location"]);
    neighborhood = json["neighborhood"];
    postcode = json["postcode"];
    province = json["province"];
    township = json["township"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["adcode"] = adcode;
    data["building"] = building;
    data["city"] = city;
    data["citycode"] = citycode;
    data["country"] = country;
    data["district"] = district;
    data["formattedAddress"] = formattedAddress;
    data["level"] = level;
    if (location != null) {
      data["location"] = location?.toJson();
    }
    data["neighborhood"] = neighborhood;
    data["postcode"] = postcode;
    data["province"] = province;
    data["township"] = township;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map json) {
    json = Map<String, dynamic>.from(json);
    latitude = json["latitude"];
    longitude = json["longitude"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    return data;
  }
}
