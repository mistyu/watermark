import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/utils/http.dart';

part 'resource_state.dart';

class ResourceCubit extends Cubit<ResourceState> {
  ResourceCubit() : super(ResourceInitial());

  List<WmCategory> _categories = [];
  List<Template> _templates = [];
  List<RightBottom> _rightBottom = [];

  Future<List<WmCategory>?> _getCategories() async {
    final response = await Http.getInstance().get(
      '/watermark/category/list',
      params: {"pageSize": 100},
    );
    if (response?.code == 200 && response!.total! > 0) {
      final jsonList = response.rows;
      final wmcs = jsonList?.map((item) => WmCategory.fromJson(item)).toList();
      return wmcs;
    }
    // final jsonData = await rootBundle.loadString("assets/json/category.json");
    // final jsonList = json.decode(jsonData) as List<dynamic>;
    // final wmcs = jsonList.map((item) => WmCategory.fromJson(item)).toList();

    return [];
  }

  Future<List<Template>?> _getTemplates() async {
    // final jsonData = await rootBundle.loadString("assets/json/resource.json");
    // final jsonMap = json.decode(jsonData) as Map<String,dynamic>;
    // final List<Template> list = [];
    // jsonMap.forEach((k,v) {
    //   for (var item in v) {
    //     final t = Template.fromJson(item);
    //     list.add(t);
    //   }
    // });

    final response = await Http.getInstance().get(
      '/watermark/resource/list',
      params: {"pageSize": 100},
    );

    if (response?.code == 200 && response!.total! > 0) {
      final jsonList = response.rows;
      final wmcs = jsonList?.map((item) => Template.fromJson(item)).toList();
      return wmcs;
    }

    return [];
  }

  Future<List<RightBottom>?> _getRightBottom() async {
    final response = await Http.getInstance().get(
      '/watermark/rightbottom/list',
      params: {"pageSize": 100},
    );

    if (response?.code == 200 && response!.total! > 0) {
      final jsonList = response.rows;
      final wmcs = jsonList?.map((item) => RightBottom.fromJson(item)).toList();
      return wmcs;
    }

    return [];
  }

  Future loadedResources() async {
    final categories = await _getCategories();
    final templates = await _getTemplates();
    final rightBottom = await _getRightBottom();
    _templates = templates ?? [];
    _categories = categories ?? [];
    _rightBottom = rightBottom ?? [];
    emit(ResourceLoaded(
        categories: categories ?? [],
        templates: templates ?? [],
        rightbottom: rightBottom ?? []));
  }

  List<WmCategory> get categories => _categories;
  List<Template> get templates => _templates;
  List<RightBottom> get rightbottom => _rightBottom;
}
