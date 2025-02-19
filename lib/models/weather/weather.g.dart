// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      province: json['province'] as String?,
      city: json['city'] as String?,
      adcode: json['adcode'] as String?,
      weather: json['weather'] as String?,
      temperature: json['temperature'] as String?,
      winddirection: json['winddirection'] as String?,
      windpower: json['windpower'] as String?,
      humidity: json['humidity'] as String?,
      reporttime: json['reporttime'] as String?,
      temperatureFloat: json['temperatureFloat'] as String?,
      humidityFloat: json['humidityFloat'] as String?,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'province': instance.province,
      'city': instance.city,
      'adcode': instance.adcode,
      'weather': instance.weather,
      'temperature': instance.temperature,
      'winddirection': instance.winddirection,
      'windpower': instance.windpower,
      'humidity': instance.humidity,
      'reporttime': instance.reporttime,
      'temperatureFloat': instance.temperatureFloat,
      'humidityFloat': instance.humidityFloat,
    };
