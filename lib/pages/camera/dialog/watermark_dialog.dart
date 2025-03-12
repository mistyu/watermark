import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_message_dialog.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/WatermarkLiveShootScale.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_altitude.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_color.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_coordinate.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_custom.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_custom_add.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_qt.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_shapeTime.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_time.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_time_choose.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto/watermark_proto_weather.dart';
import 'package:watermark_camera/widgets/no_location_permission_banner.dart';

import '../sheet/watermark_proto_view.dart';
import 'watermark_save_image_dialog.dart';
import 'watermark_save_video_dialog.dart';

enum SimulatorSheetType {
  top,
  bottom,
  center,
}

class WatermarkDialog {
  /**
   * 显示一个模态弹窗 弹窗的内容由 child 参数指定
   */
  static Future<T?> showSimulatorSheet<T>({
    required Widget child,
    bool barrierDismissible = false,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 300),
    SimulatorSheetType sheetType = SimulatorSheetType.bottom, //底部弹窗
  }) async {
    final alignment = sheetType == SimulatorSheetType.top
        ? Alignment.topCenter
        : sheetType == SimulatorSheetType.center
            ? Alignment.center
            : Alignment.bottomCenter;
    final offset = sheetType == SimulatorSheetType.top
        ? const Offset(0, -1.0)
        : sheetType == SimulatorSheetType.center
            ? Offset.zero
            : const Offset(0, 1.0);
    /**
     * 显示弹窗
     */
    return await showGeneralDialog<T>(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) =>
          Align(alignment: alignment, child: child),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          )),
          child: child, // 弹窗的内容由child决定的
        );
      },
    );
  }

  static Future<bool> showSaveImageDialog(Uint8List imageBytes) async {
    final result = await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.r),
      ),
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      content: WatermarkSaveImageDialog(imageBytes: imageBytes),
    ));

    return result ?? false;
  }

  static Future<bool> showMessageDialog(String message) async {
    final result = await Get.dialog(AlertDialog(
      elevation: 10,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      content: ShowMessageDialog(message: message),
    ));

    return result ?? false;
  }

  static Future<bool> showSaveVideoDialog(File file) async {
    final result = await Get.dialog<bool>(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.r),
      ),
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      content: WatermarkSaveVideoDialog(file: file),
    ));

    return result ?? false;
  }

  /**
   * 弹窗里面的内容里面的一项
   */
  static Future<bool> showNoLocationPermissionBanner({
    required Future<bool> Function() onGrantPermission,
  }) async {
    final result = await showSimulatorSheet<bool>(
        child: NoLocationPermissionBanner(onGrantPermission: onGrantPermission),
        sheetType: SimulatorSheetType.top,
        barrierColor: Colors.transparent);
    return result ?? false;
  }

  /// 修改水印项弹出
  static Future<dynamic> showWatermarkProtoSheet({
    required WatermarkResource resource,
    required WatermarkView watermarkView,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoView(
            resource: resource, watermarkView: watermarkView),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击颜色的弹出
  static Future<dynamic> showWatermarkProtoColorDialog() async {
    return await showSimulatorSheet<dynamic>(
        child: const WatermarkProtoColor(),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击时间的弹出
  static Future<dynamic> showWatermarkProtoTimeDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoTime(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击天气的弹出
  static Future<dynamic> showWatermarkProtoWeatherDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoWeather(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击经纬度的弹出
  static Future<dynamic> showWatermarkProtoCoordinateDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoCoordinate(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击海拔的弹出
  static Future<dynamic> showWatermarkProtoAltitudeDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoAltitude(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击自定义类型的弹出
  static Future<dynamic> showWatermarkProtoCustom1Dialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoCustom1(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击自定义类型的弹出
  static Future<dynamic> showWatermarkProtoCustomAddDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoCustomAdd(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  static Future<dynamic> showWatermarkProtoTimeChooseDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: DatePickerTimeChoose(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  /// 修改水印点击二维码的弹出
  static Future<dynamic> showWatermarkProtoQrCodeDialog({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkProtoQrCode(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  static Future<dynamic> showWatermarkWatermarkLiveShootScale({
    required WatermarkDataItemMap itemMap,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child: WatermarkLiveShootScale(itemMap: itemMap),
        sheetType: SimulatorSheetType.bottom);
  }

  static Future<dynamic> showWatermarkProtoShapeDialog({
    required WatermarkDataItemMap itemMap,
    required List<String> shapeTypeList,
  }) async {
    return await showSimulatorSheet<dynamic>(
        child:
            WatermarkProtoShape(itemMap: itemMap, shapeTypeList: shapeTypeList),
        sheetType: SimulatorSheetType.bottom);
  }
}
