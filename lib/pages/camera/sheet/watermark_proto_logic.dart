import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/utils/db_helper.dart';

import '../dialog/watermark_dialog.dart';

class WatermarkProtoLogic extends GetxController {
  final watermarkUpdateId = "watermark_update_id";
  final watermarkScaleId = 'watermark_scale_id';
  final locationLogic = Get.find<LocationController>();
  final watermarkLogic = Get.find<WaterMarkController>();
  final resource = Rxn<WatermarkResource>();
  final watermarkView = Rxn<WatermarkView>();
  final watermarkKey = GlobalKey<State<StatefulWidget>>();
  Rxn<double> watermarkScale = Rxn();
  Rxn<double> originWidth = Rxn();
  List<WatermarkDataItemMap> get watermarkItems {
    //根据watermarkView.value?.data 和 watermarkView.value?.tables 生成watermarkItems
    List<WatermarkDataItemMap> items = [];
    if (watermarkView.value?.data != null) {
      items.addAll(watermarkView.value!.data!
          .where((e) => e.title != '' && surportWatermarkType.contains(e.type))
          .map((e) => WatermarkDataItemMap(
              isTable: false, type: e.type!, title: e.title, data: e))
          .toList());
    }

    final Map<String, WatermarkTable> tables =
        watermarkView.value?.tables ?? {};

    tables.forEach((key, table) {
      if (table.data != null) {
        items.addAll(table.data!
            .where(
                (e) => e.title != '' && surportWatermarkType.contains(e.type))
            .map((e) => WatermarkDataItemMap(
                isTable: true,
                tableKey: key,
                type: e.type!,
                title: e.title,
                data: e))
            .toList());
      }
    });
    return items;
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
      return locationLogic.fullAddress.value ?? '���址定位中...';
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
    return item.type == watermarkTimeType || item.type == watermarkLocationType;
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

    update([watermarkUpdateId]);
    if (value) {
      onTapChevronRight(item: item);
    }
  }

  void changeDataItemContent(String? value,
      {required WatermarkDataItemMap item}) {
    // 修改水印数据项的data.content
    item.data.content = value;
    watermarkView.update((v) {
      if (item.isTable) {
        //是表格吗？
        print("xiaojianjian changeDataItemContent 是表格 item.type: ${item.type}");
        final index = v?.tables?[item.tableKey!]?.data
            ?.indexWhere((e) => e.type == item.type && e.title == item.title);
        if (index != null && index >= 0) {
          v?.tables?[item.tableKey!]?.data?[index] = item.data;
        }
      } else {
        //不是表格
        print(
            "xiaojianjian changeDataItemContent 不是表格 item.type: ${item.type}");
        final index = v?.data
            ?.indexWhere((e) => e.type == item.type && e.title == item.title);
        if (index != null && index >= 0) {
          v?.data?[index] = item.data; //更新数据
          print(
              "xiaojianjian changeDataItemContent 不是表格 index: ${v?.data?[index].content}");
        }
      }
    });
    update([watermarkUpdateId]);
  }

  void updateFontsColor(Color color) {
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
    update([watermarkUpdateId]);
  }

  /**
   * 点击右边的按钮，这里根据不同的类型进行不同的弹窗框
   */
  void onTapChevronRight({required WatermarkDataItemMap item}) async {
    String? result = '';
    switch (item.type) {
      case watermarkBrandLogoType: // 品牌图弹窗
        result = await AppNavigator.startWatermarkProtoBrandLogo(item);
        break;
      case watermarkTimeType: // 时间弹窗
        result =
            await WatermarkDialog.showWatermarkProtoTimeDialog(itemMap: item);
        break;
      case watermarkCoordinateType: // 坐标弹窗
        result = await WatermarkDialog.showWatermarkProtoCoordinateDialog(
            itemMap: item);
        break;
      case watermarkLocationType: // 位置弹窗
        result = await AppNavigator.startWatermarkLocation(item);
        break;
      case watermarkWeatherType: // 天气弹窗
        result = await WatermarkDialog.showWatermarkProtoWeatherDialog(
            itemMap: item);
        break;
      case watermarkAltitudeType: // 经纬度弹窗
        result = await WatermarkDialog.showWatermarkProtoAltitudeDialog(
            itemMap: item);
        break;
      case watermarkNotesType: // 备注弹窗
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
      case watermarkCustom1Type:
        result = await WatermarkDialog.showWatermarkProtoCustom1Dialog(
            itemMap: item);
        break;
    }
    print("xiaojianjian onTapChevronRight result: $result");
    if (Utils.isNotNullEmptyStr(result)) {
      print("result: $result");
      changeDataItemContent(result, item: item);
    }
  }

  void onChangeScale(double scale) {
    watermarkScale.value = scale;
    update([watermarkScaleId]);
  }

  void onChangeWidth(double widthPercent) {
    watermarkView.update((value) {
      value?.frame?.width = (originWidth.value ?? 1.sw) * widthPercent;
    });
    update([watermarkUpdateId]);
  }

  void setResource(WatermarkResource value) {
    resource.value = value;
  }

  void setWatermarkView(WatermarkView value) {
    originWidth.value = value.frame?.width;
    watermarkView.value = value;
    update([watermarkUpdateId]);
    loadSavedSettings();
  }

  Future<void> loadSavedSettings() async {
    if (resource.value?.id == null) return;

    final watermarkSetting =
        watermarkLogic.getDbWatermarkByResourceId(resource.value!.id!);

    if (watermarkSetting != null) {
      watermarkScale.value = watermarkSetting.scale;
      update([watermarkScaleId]);
    }
  }

  void onSaveWatermark() async {
    if (resource.value?.id == null) return;

    final settings = WatermarkSettingsModel(
      resourceId: resource.value!.id.toString(),
      watermarkView: watermarkView.value!,
      scale: watermarkScale.value,
      updatedAt: DateTime.now(),
    );

    await DBHelper.insertModel(settings);
    // 弹窗默认是一个会增加一个路由进入路由栈，然后Get.back()会弹出路由栈
    Get.back(result: settings);
  }

  void onExit() {
    Get.back();
  }
}
