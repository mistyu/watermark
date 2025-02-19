import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int? id;
  final String? title;
  final int? rank;

  const Category({this.id, this.title, this.rank});

  @override
  String toString() => 'WmCategory(id: $id, title: $title, rank: $rank)';

  factory Category.fromJson(Map<String, dynamic> json) {
    return _$CategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    int? id,
    String? title,
    int? rank,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      rank: rank ?? this.rank,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Category) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ rank.hashCode;
}
