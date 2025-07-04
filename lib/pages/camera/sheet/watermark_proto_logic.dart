import 'dart:io';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/db/watermark/watermark_save.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/colours.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/utils/db_helper.dart';

import '../dialog/watermark_dialog.dart';

class WatermarkProtoLogic extends GetxController {
  final watermarkUpdateId = 'watermark_update_id';
  final watermarkScaleId = 'watermark_scale_id';
  final locationLogic = Get.find<LocationController>();
  final watermarkLogic = Get.find<WaterMarkController>();
  final resource = Rxn<WatermarkResource>(); // 资源
  final watermarkView =
      Rxn<WatermarkView>(); // copy版的watermarkView 传入choose_position_logic还是
  final watermarkKey = GlobalKey<State<StatefulWidget>>();
  Rxn<double> watermarkScale = Rxn(1);
  Rxn<double> originWidth = Rxn();

  // 文字颜色
  Rx<Color> pickerColor = const Color(0xffffffff).obs;
  // 标题颜色
  Rx<Color> titlePickerColor = const Color(0xffffffff).obs;
  // 底部底色
  Rx<Color> backgroundPickerColor = const Color(0xffffffff).obs;

  List<Color> colorsList = [
    const Color(0xff0050f1),
    const Color(0xff19c1bf),
    const Color(0xffff8e59),
    const Color(0xffcc0106),
    const Color(0xffa903ac),
    const Color(0xff00a3ff),
    const Color(0xff1ce9b5),
    const Color(0xff64de16),
    const Color(0xfffec432),
    const Color(0xfffe5352),
    const Color(0xffcd49ff),
    const Color(0xff43e8fe),
    const Color(0xff64ffda),
    const Color(0xff75ff02),
    const Color(0xfffef040),
    const Color(0xfffeac91),
    const Color(0xffeb85fe),
    const Color(0xff000000),
    const Color(0xffffffff),
    const Color(0xffff6735),
  ];
  // // 标题透明度
  // Rxn<double> titleAlpha = Rxn(1.0); // 标题透明度

  // // 底部透明度
  // Rxn<double> backgroundAlpha = Rxn(1.0); // 底部透明度

  List<String> shapeTypeList = ['默认', '椭圆', '五角星', '圆形'];

  Map<String, WatermarkFont> fonts = {
    'font': WatermarkFont(name: 'Wechat_regular', size: 14.5),
  };

  Map<String, WatermarkFont> fonts582 = {
    'font': WatermarkFont(name: 'Akshar-Medium', size: 12, weight: 'w700'),
  };

  WatermarkData? get logoData => watermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');

  WatermarkData? get locationData => watermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkLocation');

  WatermarkData? get coordinateData => watermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkCoordinate');

  WatermarkData? get timeData => watermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTime');

  WatermarkData? get titleData => watermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'YWatermarkTitleBar');

  WatermarkTable? get table2Data => watermarkView.value?.tables?['table2'];

  List<WatermarkDataItemMap> get watermarkItems {
    //根据watermarkView.value?.data 和 watermarkView.value?.tables 生成watermarkItems
    List<WatermarkDataItemMap> items = [];
    if (watermarkView.value?.data != null) {
      items.addAll(watermarkView.value!.data!
          .where((e) =>
              e.title != '' &&
              surportWatermarkType.contains(e.type) &&
              e.isEdit == true)
          .map((e) => WatermarkDataItemMap(
              isTable: false,
              type: e.type!,
              title: e.title,
              data: e,
              templateId: resource.value?.id ?? 0))
          .toList());
    }

    final Map<String, WatermarkTable> tables =
        watermarkView.value?.tables ?? {};

    tables.forEach((key, table) {
      if (table.data != null) {
        items.addAll(table.data!
            .where((e) =>
                e.title != '' &&
                surportWatermarkType.contains(e.type) &&
                e.isEdit == true)
            .map((e) => WatermarkDataItemMap(
                isTable: true,
                tableKey: key,
                type: e.type!,
                title: e.title,
                data: e,
                templateId: resource.value?.id ?? 0))
            .toList());
      }
    });

    // 对于某些模板来说，要添加一个可以添加表格项的设置
    if (resource.value?.id == 1698317868899 ||
        resource.value?.id == 16982153599582) {
      //自定义选择项
      items.add(WatermarkDataItemMap(
          isTable: true,
          tableKey: "table1",
          type: watermarkCustomAddSettingTable1,
          title: "自定义添加",
          templateId: resource.value?.id ?? 0,
          data: WatermarkData(
            title: "自定义添加",
            type: watermarkCustomAddSettingTable1,
          )));
    }

    // for (var item in items) {
    //   print(
    //       "xiaojianjian watermarkSettingItems ${item.type} ${item.title} ${item.data.content}`");
    // }
    return items;
  }

  // 点击收藏水印 --- 涉及存在到本地数据库中
  void onTapSaveWatermark(BuildContext context) async {
    final saveSettings = await CommonDialog.showWatermarkSaveDialog(
        context, resource.value?.id.toString());
    if (saveSettings != null) {
      try {
        String coordinates = '';
        String time = '';
        String address = '';

        coordinates = coordinateData?.content ?? '';

        time = timeData?.content ?? '';

        address = locationLogic.fullAddress.value ?? '';

        final watermarkSaveModel = WatermarkSaveModel(
          name: saveSettings.name,
          resourceId: resource.value?.id.toString() ?? '',
          lockTime: time,
          lockAddress: address,
          lockCoordinates: coordinates,
          url: resource.value?.cover,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // 先检查表结构
        // await DBHelper.checkAndFixTableStructure();

        // 保存水印
        await DBHelper.saveWatermark(watermarkSaveModel);
        Utils.showToast("收藏成功");
      } catch (e) {
        print("xiaojianjian 保存水印失败: $e");
        Utils.showToast("收藏失败: ${e.toString().substring(0, 100)}...");
      }
    }
  }

  String getContent({required WatermarkDataItemMap item}) {
    if (item.type == watermarkBrandLogoType) {
      return '';
    }
    if (Utils.isNotNullEmptyStr(item.data.content)) {
      return item.data.content!;
    }

    if (item.type == watermarkTimeType) {
      final date = DateTime.now();
      return formatDate(date, watermarkTimeFormat);
    }
    if (item.type == watermarkLocationType) {
      return locationLogic.fullAddress.value ?? '地址定位中...';
    }
    if (item.type == watermarkWeatherType) {
      final weather = locationLogic.weather.value;
      if (weather?.weather != null && weather?.temperature != null) {
        return "${weather?.weather} ${weather?.temperature}℃";
      }
      return '';
    }
    return '';
  }

  // 获取额外内容，比如品牌logo
  Widget? getExtraContent({required WatermarkDataItemMap item}) {
    if (item.type == watermarkBrandLogoType) {
      //如果是品牌logo, 还是将内容设置到content中
      final content = item.data.content;
      if (Utils.isNotNullEmptyStr(content)) {
        return Image.network(content!, height: 48.h, fit: BoxFit.cover);
      }

      return GestureDetector(
          onTap: () => onTapChevronRight(item: item),
          child: "add_logo".png.toImage
            ..height = 24.h
            ..fit = BoxFit.cover);
    }
    return null;
  }

  bool getDisableSwitch({required WatermarkDataItemMap item}) {
    // return item.type == watermarkTimeType || item.type == watermarkLocationType;
    return item.data.isEdit != true;
  }

  /**
   * 切换开关
   */
  void onChangeSwitch(bool value, {required WatermarkDataItemMap item}) {
    item.data.isHidden = !value;

    watermarkView.update((v) {
      if (item.isTable) {
        final index = v?.tables?[item.tableKey!]?.data
            ?.indexWhere((e) => e.type == item.type && e.title == item.title);
        if (index != null && index >= 0) {
          v?.tables?[item.tableKey!]?.data?[index] = item.data;
        }
      } else {
        final index = v?.data
            ?.indexWhere((e) => e.type == item.type && e.title == item.title);
        if (index != null && index >= 0) {
          v?.data?[index] = item.data;
        }
      }
    });
    // watermarkView.value?.scale = Random().nextInt(100).toDouble();
    update([watermarkUpdateId]);
    if (value) {
      //如果value从false -> true 打开同时没有相应的content选择栏，则弹出选择栏
      onTapChevronRight(item: item);
    }
  }

  void changeDataItemContent(dynamic content,
      {required WatermarkDataItemMap item}) {
    if (item.isTable) {
      watermarkView.update((value) {
        //不能按照type来查找，因为存在type相同的情况
        value?.tables?[item.tableKey]?.data
            ?.firstWhere((element) => element.title == item.title)
            .content = content;
      });
    } else {
      watermarkView.update((value) {
        value?.data
            ?.firstWhere((element) => element.type == item.type)
            .content = content;
      });
    }
    update([watermarkUpdateId]);
  }

  /**
   * 点击右边的按钮，这里根据不同的类型进行不同的弹窗框
   */
  void onTapChevronRight({required WatermarkDataItemMap item}) async {
    dynamic result;
    switch (item.type) {
      case watermarkBrandLogoType: // 品牌图弹窗
        result = await AppNavigator.startWatermarkProtoBrandLogo(item);
        if (result != null) {
          // 更新水印视图中的数据
          watermarkView.update((value) {
            if (value != null) {
              // 找到对应的数据项并更新
              final index = value.data
                      ?.indexWhere((e) => e.type == watermarkBrandLogoType) ??
                  -1;
              if (index >= 0) {
                value.data?[index] = (result as WatermarkDataItemMap).data;
              }
            }
          });
          update([watermarkUpdateId]);
        }
        return;
      case watermarkTimeType: // 时间弹窗
        result = await WatermarkDialog.showWatermarkProtoTimeChooseDialog(
            itemMap: item);
        break;
      case watermarkQrCode: // 二维码弹窗
        result =
            await WatermarkDialog.showWatermarkProtoQrCodeDialog(itemMap: item);
        break;
      case watermarkCoordinateType: // 经纬度弹窗
        result = await WatermarkDialog.showWatermarkProtoCoordinateDialog(
            itemMap: item);
        break;
      case watermarkLocationType: // 位置弹窗
        result = await AppNavigator.startWatermarkLocation(item);
        break;
      case watermarkWeatherType: // 天气弹窗 这里要多一个image的处理
        result = await WatermarkDialog.showWatermarkProtoWeatherDialog(
            itemMap: item);
        if (result != null) {
          watermarkView.update((value) {
            if (value != null) {
              // 找到对应的数据项并更新
              final index = value.data
                      ?.indexWhere((e) => e.type == watermarkWeatherType) ??
                  -1;
              if (index >= 0) {
                value.data?[index] = (result as WatermarkDataItemMap).data;
              }
            }
          });
          update([watermarkUpdateId]);
        }
        return;
      case watermarkAltitudeType: // 海拔弹窗
        result = await WatermarkDialog.showWatermarkProtoAltitudeDialog(
            itemMap: item);
        break;
      case watermarkNotesType: // 备注弹窗
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
      case watermarkTableGeneralType:
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
      case watermarkTitleType:
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
      case watermarkHeadline:
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
      case watermarkCustom1Type:
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
      //特殊处理
      case watermarkCustomAddSettingTable1:
        result = await WatermarkDialog.showWatermarkProtoCustomAddDialog(
            itemMap: item);
        print("xiaojianjian 自定义添加 ${result.title} ${result.value}");
        if (result != null) {
          // 更新水印视图中的数据
          addDataToTabel(result, item);
        }
        return;
      case watermarkCustomAddSettingTable2:
        result = await WatermarkDialog.showWatermarkProtoCustomAddDialog(
            itemMap: item);
        if (result != null) {
          // 更新水印视图中的数据
          addDataToTabel(result, item);
        }
        return;
      case watermarkLiveShoot:
        result = await WatermarkDialog.showWatermarkWatermarkLiveShootScale(
            itemMap: item);
        print("xiaojianjian 水印缩放 ${result} ${item.type}");
        if (result != null) {
          watermarkView.update((value) {
            value?.data
                ?.firstWhere((element) => element.type == item.type)
                .scale = result;
          });
          update([watermarkUpdateId]);
        }
        return;
      case watermarkSignature: //签名
        result = await AppNavigator.startSignaturePage(item);
        break;
      case watermarkMap:
        result = await AppNavigator.startWatermarkMap(item);
        break;
      case watermarkShapeType:
        result = await WatermarkDialog.showWatermarkProtoShapeDialog(
            itemMap: item, shapeTypeList: shapeTypeList);
        break;
    }

    if (Utils.isNotNullEmptyStr(result)) {
      changeDataItemContent(result, item: item);
    }
  }

  void addDataToTabel(result, WatermarkDataItemMap item) {
    print("xiaojianjian addTale ${result.title} ${result.value}");
    watermarkView.update((value) {
      // 找到对应的数据项并更新
      WatermarkData watermarkData = WatermarkData(
          title: result.title,
          type: watermarkTableGeneralType,
          content: result.value,
          isEdit: true,
          isRequired: false,
          isHidden: false,
          isHighlight: false,
          isMove: false,
          isWithTitle: true,
          isEditTitle: false,
          showType: item.data.showType ?? 0,
          image: item.data.image ?? "",
          frame: (item.data.frame) ??
              (resource.value?.id == 16982153599582
                  ? WatermarkFrame(left: 14, top: 3)
                  : WatermarkFrame(left: 0, top: 0)),
          mark: item.data.mark ??
              (resource.value?.id == 16982153599582
                  ? WatermarkMark(
                      frame: WatermarkFrame(
                          left: 4, top: 8, right: 0, width: 4, height: 4),
                      style: WatermarkStyle(
                        backgroundColor: WatermarkBackgroundColor(
                            color: "#FFFFFF", alpha: 1),
                        radius: 2.5,
                      ),
                    )
                  : null),
          style: item.data.style ??
              WatermarkStyle(
                  isTitleAlignment: false,
                  textMaxWidth: 0,
                  fonts:
                      resource.value?.id == 16982153599582 ? fonts582 : fonts,
                  textColor:
                      WatermarkBackgroundColor(color: "#FFFFFF", alpha: 1)));

      int? len = value?.tables![item.tableKey]!.data!.length;
      int dei = 0;
      if (resource.value?.id == 1698049553311) {
        dei = 2;
      }
      int insertIndex = len! - dei;

      value?.tables![item.tableKey]!.data!.insert(insertIndex, watermarkData);
    });
    update([watermarkUpdateId]);
  }

  @override
  void onInit() {
    super.onInit();
    print("WatermarkProtoLogic onInit");
    // 初始化代码
  }

  @override
  void onClose() {
    print("WatermarkProtoLogic onClose");
    // 清理资源
    super.onClose();
  }

  void resetAll() {
    watermarkView.update((value) {
      value?.scale = 1;
      value?.frame?.width = originWidth.value ?? 1.sw;
    });
    update([watermarkUpdateId]);
  }

  void onChangeScale(double n) {
    print("xiaojianjian 开始缩放更新: $n");

    // 将百分比转换为实际缩放值，并确保在有效范围内
    final scale = (n).clamp(0.5, 2.0);
    watermarkView.update((value) {
      value?.scale = scale;
    });
    print("xiaojianjian 缩放更新: ${watermarkView.value?.scale}");
    update([watermarkUpdateId]);
  }

  void onChangeWidth(double widthPercent) {
    // 确保值在有效范围内
    const minWidth = 150.0;
    final maxWidth = 1.sw;
    final safeWidth = widthPercent.clamp(minWidth, maxWidth);
    watermarkView.update((value) {
      value?.frame?.width = safeWidth;
    });
    update([watermarkUpdateId]);
  }

  void setResource(WatermarkResource value) {
    resource.value = value;
    update([watermarkUpdateId]);
  }

  // 好像不是copysetWatermarkView数据
  void setWatermarkView(WatermarkView value) {
    originWidth.value = value.frame?.width;
    watermarkView.value = value;
    watermarkScale.value = watermarkView.value?.scale ?? 1;
    update([watermarkUpdateId]);
  }

  /**
   * 点击保存水印，主要是将copy版的watermarkView传回到真实水印，进行修改
   */
  void onSaveWatermark() async {
    if (resource.value?.id == null) return;

    // try {
    //   await Apis.userDeductTimes(1);
    // } catch (e) {
    //   AppNavigator.startVip();
    //   return;
    // }

    Utils.showLoading("保存中...");
    final settings = WatermarkSettingsModel(
      resourceId: resource.value!.id.toString(),
      watermarkView: watermarkView.value!,
      scale: watermarkScale.value,
      updatedAt: DateTime.now(),
    );

    await DBHelper.insertModel(settings);
    Utils.dismissLoading();
    // 弹窗默认是一个会增加一个路由进入路由栈，然后Get.back()会弹出路由栈
    Get.back(result: settings);
  }

  void updateFontsColor(Color color) {
    pickerColor.value = color;
    if (resource.value?.id == 16982153599988) {
      // 16982153599582 这里是特别调背景色
      updataBackgroundColor(color);
    } else {
      watermarkView.update((view) {
        view?.style?.textColor?.alpha = color.opacity;
        view?.style?.textColor?.color = Utils.color2HEX(color);
        view?.data?.forEach((item) {
          item.style?.textColor?.alpha = color.opacity;
          item.style?.textColor?.color = Utils.color2HEX(color);
        });
        view?.tables?.entries.forEach((table) {
          table.value.data?.forEach((item) {
            item.style?.textColor?.alpha = color.opacity;
            item.style?.textColor?.color = Utils.color2HEX(color);
          });
        });
      });
    }
    update([watermarkUpdateId]);
  }

  void updataBackgroundColor(Color color) {
    watermarkView.update((view) {
      final table = view?.tables!['table2'];
      table!.style?.backgroundColor?.alpha = color.opacity;
      table.style?.backgroundColor?.color = Utils.color2HEX(color);
    });
  }

  void showBottomSheetAndUpdateColor() async {
    final result = await WatermarkDialog.showWatermarkProtoColorDialog();
    if (result != null) {
      updateFontsColor(result);
    }
  }

  // 更新标题颜色
  void updateTitleColor(Color color) {
    if (watermarkView.value == null) return;
    titlePickerColor.value = color;

    watermarkView.update((view) {
      final titleData = watermarkView.value?.data
          ?.firstWhereOrNull((data) => data.type == 'YWatermarkTitleBar');
      titleData!.style?.backgroundColor?.alpha = color.opacity;
      titleData.style?.backgroundColor?.color = Utils.color2HEX(color);
    });
    update([watermarkUpdateId]);
  }

  // 更新底部底色
  void updateBackgroundColor(Color color) {
    if (watermarkView.value == null) return;

    watermarkView.update((view) {
      final table = view?.tables!['table2'];
      table!.style?.backgroundColor?.alpha = color.opacity;
      table.style?.backgroundColor?.color = Utils.color2HEX(color);
    });

    update([watermarkUpdateId]);
  }

  // 更新标题透明度
  void updateTitleAlpha(double alpha) {
    if (watermarkView.value == null) return;
    // titleAlpha.value = alpha;

    watermarkView.update((view) {
      final titleData = watermarkView.value?.data
          ?.firstWhereOrNull((data) => data.type == 'YWatermarkTitleBar');
      if (titleData != null && titleData.style?.backgroundColor != null) {
        titleData.style!.backgroundColor!.alpha = alpha;
      }
    });

    // 使用微任务延迟更新UI，减少频繁重绘
    update([watermarkUpdateId]);
  }

  // 更新底部透明度
  void updateBackgroundAlpha(double alpha) {
    if (watermarkView.value == null) return;
    // backgroundAlpha.value = alpha;

    watermarkView.update((view) {
      final table = view?.tables?['table2'];
      if (table != null && table.style?.backgroundColor != null) {
        table.style!.backgroundColor!.alpha = alpha;
      }
    });

    // 使用微任务延迟更新UI，减少频繁重绘
    update([watermarkUpdateId]);
  }

  void onExit() {
    Get.back();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void forceRefresh() {
    print("强制刷新所有 ID");
    update([watermarkUpdateId]);
  }

  void initData(WatermarkResource resource, WatermarkView watermarkView) {
    print("初始化数据");
    setResource(resource);
    setWatermarkView(watermarkView);
    // setStylesSettings();
    forceRefresh(); // 强制刷新
  }

  void setStylesSettings() {
    //主要是初始化相应的标题和底部的此时的选中颜色
    if (resource.value!.id == 1698049457777 ||
        resource.value!.id == 1698049456677) {
      final titleColorInt = Colours.hexToArgb(
          titleData!.style!.backgroundColor?.color ?? "#FFFFFF",
          titleData!.style!.backgroundColor?.alpha ?? 1.0);
      titlePickerColor.value = Color(titleColorInt);

      final backgroundColorInt = Colours.hexToArgb(
          table2Data!.style!.backgroundColor?.color ?? "#FFFFFF",
          table2Data!.style!.backgroundColor?.alpha ?? 1.0);
      backgroundPickerColor.value = Color(backgroundColorInt);
    }
  }
}
