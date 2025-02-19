import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/watermark_brand/watermark_brand.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dio/dio.dart' as dio;

class WatermarkProtoBrandLogoLogic extends GetxController {
  late RefreshController refreshController;
  late WatermarkDataItemMap itemMap;

  final comPageNum = 1.obs;
  final comPageSize = 60;

  final myPageNum = 1.obs;
  final myPageSize = 3;

  final commonBrandList = <WatermarkBrand>[].obs;
  final myBrandList = <WatermarkBrand>[].obs;

  Future<List<WatermarkBrand>> _requestBrandLogoList() async {
    return Apis.getBrandLogoList(
      pageNum: comPageNum.value,
      pageSize: comPageSize,
    );
  }

  Future<List<WatermarkBrand>> _requestMyBrandLogoList() async {
    return Apis.getMyBrandLogoList(
      pageNum: myPageNum.value,
      pageSize: myPageSize,
    );
  }

  Future<void> onRefreshBrandLogoList() async {
    try {
      final result = await _requestBrandLogoList();
      commonBrandList
        ..clear()
        ..addAll(result)
        ..refresh();
      refreshController.refreshCompleted();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoadingBrandLogoList() async {
    try {
      comPageNum.value++;
      final result = await _requestBrandLogoList();
      if (result.isEmpty || result.length < comPageSize) {
        refreshController.loadNoData();
      }
      commonBrandList
        ..addAll(result)
        ..refresh();
      refreshController.loadComplete();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
      refreshController.loadFailed();
    }
  }

  Future<void> onRefreshMyBrandLogoList() async {
    try {
      final result = await _requestMyBrandLogoList();
      myBrandList
        ..clear()
        ..addAll(result)
        ..refresh();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
    }
  }

  void onUploadBrandLogo() async {
    try {
      final assets = await AssetPicker.pickAssets(Get.context!,
          pickerConfig: const AssetPickerConfig(
            maxAssets: 1,
            specialPickerType: SpecialPickerType.noPreview,
            requestType: RequestType.image,
            themeColor: Styles.c_0C8CE9,
          ));
      if (assets != null && assets.isNotEmpty) {
        final asset = assets.first;
        final bytes = await asset.originBytes;
        final file = await asset.file;
        final ext = file?.path.split('.').last;

        if (bytes != null) {
          final mf =
              dio.MultipartFile.fromBytes(bytes, filename: "brand_logo.$ext");
          var formData = dio.FormData.fromMap({'file': mf});
          final result =
              await LoadingView.singleton.wrap(asyncFunction: () async {
            final result = await Apis.uploadBrandLogo(formData);
            return result;
          });

          if (result != null) {
            myBrandList.add(WatermarkBrand(logoPath: result.logoPath));
          }
        }
      }
    } catch (e, s) {
      Logger.print("e: $e s: $s");
    }
  }

  void onSelectBrandPath(String path) async {
    final fileName = path.split('/').last;
    final cachePath = await Utils.getTempFilePath(dir: 'logo', name: fileName);
    await HttpUtil.download(Config.staticUrl + path, cachePath: cachePath);
    Get.back(result: cachePath);
  }

  @override
  void onInit() {
    super.onInit();
    onRefreshMyBrandLogoList();
    onRefreshBrandLogoList();
    refreshController = RefreshController(initialRefresh: false);
    itemMap = Get.arguments['itemMap'];
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
