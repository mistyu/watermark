import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  String? province; // 省
  String? city; // 市
  String? adcode; // 区域编码
  String? weather; // 天气
  String? temperature; // 温度
  String? winddirection; // 风向
  String? windpower; // 风力
  String? humidity; // 湿度
  String? reporttime; // 报告时间
  String? temperatureFloat; // 温度浮点数
  String? humidityFloat; // 湿度浮点数

  Weather({
    this.province,
    this.city,
    this.adcode,
    this.weather,
    this.temperature,
    this.winddirection,
    this.windpower,
    this.humidity,
    this.reporttime,
    this.temperatureFloat,
    this.humidityFloat,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
