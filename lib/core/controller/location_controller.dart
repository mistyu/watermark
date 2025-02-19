import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/core/service/ip_service.dart';
import 'package:watermark_camera/models/location/location_result.dart';
import 'package:watermark_camera/models/weather/weather.dart';
import 'package:watermark_camera/plugin/amap_search/amap_seach.dart';
import 'package:watermark_camera/utils/logger.dart';

class LocationController extends GetxController {
  final weather = Rxn<Weather>();

  final fullAddress = Rxn<String>();
  final locationResult = Rxn<LocationResult>();

  StreamSubscription<Map<String, Object>>? _locationListener;

  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  void _initLocation() async {
    AMapFlutterLocation.setApiKey(
        Config.amapAndroidApiKey, Config.amapIosApiKey);
    AmapFlutterSearch.setApiKey(Config.amapAndroidApiKey, Config.amapIosApiKey);
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AmapFlutterSearch.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
  }

  String? getFormatAddress(int watermarkId) {
    var map = locationResult.value;
    String? des = map?.description?.replaceAll('在', '').replaceAll('附近', '');
    if (watermarkId == 1698049285500) {
      return "${map?.city}${map?.district}·$des";
    }

    if (watermarkId == 1698049876666 ||
        watermarkId == 1698049354422 ||
        watermarkId == 1698125685119 ||
        watermarkId == 1698049855544 ||
        watermarkId == 16986609252222 ||
        watermarkId == 16982272012263 ||
        //XX街道无点
        watermarkId == 1698125672 ||
        watermarkId == 1698125120 ||
        watermarkId == 1698125930 ||
        watermarkId == 1698317868899) {
      return map?.fullAddress.replaceAll('·', '');
    }
    if (
        //XX街道有点
        watermarkId == 1698125683355 ||
            watermarkId == 16982153599582 ||
            watermarkId == 1698049456677 ||
            watermarkId == 1698049875646 ||
            watermarkId == 16982153599999 ||
            watermarkId == 1698049811111 ||
            watermarkId == 1698049457777 ||
            watermarkId == 1698049553311 ||
            watermarkId == 1698049986253 ||
            watermarkId == 16983178686921 ||
            watermarkId == 1698049914988) {
      return map?.fullAddress;
    }
    if (watermarkId == 1698125672110) {
      return "${map?.city}$des";
    }
    // 无省份
    if (watermarkId == 1698049853333) {
      return "${map?.city}${map?.district}${map?.street}${map?.streetNumber}$des";
    }
    if (watermarkId == 1698049280000) {
      return "${map?.city}$des".replaceAll('市', '');
    }
    //无街道号
    if (watermarkId == 16982893664516) {
      return '${map?.province}${map?.city}${map?.district}${map?.street}·$des';
    }
    return "${map?.city}·$des";
  }

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  @override
  void onClose() {
    stopLocation();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener?.cancel();
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  Future<void> requestLocationPermission() async {
    await _requestLocationPermission();

    if (Platform.isIOS) {
      await _requestAccuracyAuthorization();
    }
  }

  Future<void> searchWeather() async {
    final adcode = await IpService.getCityCode();
    final result = await Apis.getWeather(adcode);
    weather.value = result;
    update();
  }

  ///开始定位
  void startLocation() {
    // searchWeather();
    _locationListener ??= _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      Logger.print("定位结果: $result");
      if (result.containsKey("latitude") && result.containsKey("longitude")) {
        if (result['latitude'] is String) {
          result['latitude'] = double.parse(result['latitude'] as String);
        }
        if (result['longitude'] is String) {
          result['longitude'] = double.parse(result['longitude'] as String);
        }
        locationResult.value = LocationResult.fromJson(result);
        fullAddress.value = locationResult.value?.fullAddress;
      }
      update();
      stopLocation();
    });

    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.ZH;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///获取iOS native的accuracyAuthorization类型
  Future<AMapAccuracyAuthorization> _requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (kDebugMode) {
      if (currentAccuracyAuthorization ==
          AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
        Logger.print("精确定位类型");
      } else if (currentAccuracyAuthorization ==
          AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
        Logger.print("模糊定位类型");
      } else {
        print("未知定位类型");
      }
    }

    return currentAccuracyAuthorization;
  }

  final _hasLocationPermission = false.obs;

  bool get hasLocationPermission => _hasLocationPermission.value;

  /// 申请定位权限
  Future<void> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      _hasLocationPermission.value = true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        _hasLocationPermission.value = true;
      } else {
        _hasLocationPermission.value = false;
      }
    }

    if (kDebugMode) {
      if (_hasLocationPermission.value) {
        Logger.print("定位权限申请通过");
      } else {
        Logger.print("定位权限申请不通过");
      }
    }
  }
}
