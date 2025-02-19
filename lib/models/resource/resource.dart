import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  final int? id;
  final int? status;
  final String? cover;
  final String? zipUrl;

  const Resource({
    this.id,
    this.status,
    this.cover,
    this.zipUrl,
  });

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceToJson(this);
}

@JsonSerializable()
class WatermarkResource extends Resource {
  final int? cid;
  final String? title;
  final int? canShare;
  final int? editType;
  final String? demoUrl;
  final int? isHot;
  final int? isVip;
  final String? updatedDt;
  final int? updatedAt;

  const WatermarkResource({
    super.id,
    super.cover,
    super.zipUrl,
    super.status,
    this.cid,
    this.title,
    this.canShare,
    this.editType,
    this.demoUrl,
    this.isHot,
    this.isVip,
    this.updatedDt,
    this.updatedAt,
  });

  factory WatermarkResource.fromJson(Map<String, dynamic> json) =>
      _$WatermarkResourceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WatermarkResourceToJson(this);

  WatermarkResource copyWith({
    int? id,
    int? cid,
    String? title,
    String? cover,
    String? zipUrl,
    int? canShare,
    int? editType,
    String? demoUrl,
    int? isHot,
    int? isVip,
    int? status,
    String? updatedDt,
    int? updatedAt,
  }) {
    return WatermarkResource(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      title: title ?? this.title,
      cover: cover ?? this.cover,
      zipUrl: zipUrl ?? this.zipUrl,
      canShare: canShare ?? this.canShare,
      editType: editType ?? this.editType,
      demoUrl: demoUrl ?? this.demoUrl,
      isHot: isHot ?? this.isHot,
      isVip: isVip ?? this.isVip,
      status: status ?? this.status,
      updatedDt: updatedDt ?? this.updatedDt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class RightBottomResource extends Resource {
  int? rid;

  RightBottomResource({
    super.id,
    super.status,
    super.cover,
    super.zipUrl,
    this.rid,
  });

  factory RightBottomResource.fromJson(Map<String, dynamic> json) =>
      _$RightBottomResourceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RightBottomResourceToJson(this);

  RightBottomResource copyWith({
    int? id,
    int? status,
    String? cover,
    String? zipUrl,
    int? rid,
  }) {
    return RightBottomResource(
      id: id ?? this.id,
      status: status ?? this.status,
      cover: cover ?? this.cover,
      zipUrl: zipUrl ?? this.zipUrl,
      rid: rid ?? this.rid,
    );
  }
}
