part of 'resource_cubit.dart';

@immutable
sealed class ResourceState {}

final class ResourceInitial extends ResourceState {}

final class ResourceLoaded extends ResourceState {
  final List<WmCategory> categories;
  final List<Template> templates;
  final List<RightBottom>? rightbottom;

  ResourceLoaded(
      {required this.categories, required this.templates, this.rightbottom});
}
