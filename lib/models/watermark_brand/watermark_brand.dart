
import 'package:json_annotation/json_annotation.dart';

part 'watermark_brand.g.dart';

@JsonSerializable()
class WatermarkBrand {
  String? logoPath;
  int? id;

  WatermarkBrand({
    this.logoPath,
    this.id,
  });

  factory WatermarkBrand.fromJson(Map<String, dynamic> json) =>
      _$WatermarkBrandFromJson(json);

  Map<String, dynamic> toJson() => _$WatermarkBrandToJson(this);
}
