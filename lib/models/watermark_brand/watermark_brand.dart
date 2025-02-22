import 'package:json_annotation/json_annotation.dart';

part 'watermark_brand.g.dart';

class WatermarkBrand {
  final int? id;
  final String? logoUrl;
  final String? logoName;

  WatermarkBrand({
    this.id,
    this.logoUrl,
    this.logoName,
  });

  factory WatermarkBrand.fromJson(Map<String, dynamic> json) {
    return WatermarkBrand(
      id: json['id'],
      logoUrl: json['logoUrl'],
      logoName: json['logoName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logoUrl': logoUrl,
      'logoName': logoName,
    };
  }

  @override
  String toString() {
    return 'WatermarkBrand{id: $id, logoUrl: $logoUrl, logoName: $logoName}';
  }
}
