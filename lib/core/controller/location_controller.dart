import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/core/service/ip_service.dart';
import 'package:watermark_camera/models/location/location_result.dart';
import 'package:watermark_camera/models/weather/weather.dart';
import 'package:watermark_camera/plugin/amap_search/amap_seach.dart';
import 'package:watermark_camera/utils/logger.dart';
import 'package:watermark_camera/utils/toast_util.dart';

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
      return "xiaojianjian${map?.city}${map?.district}·$des";
    }
    if (watermarkId == 1698049556633) {
      return "${map?.city}·${map?.aois}";
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
      return map?.address;
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
    return "${map?.address}";
  }

  @override
  void onInit() {
    super.onInit();
    searchWeather();
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
    // final result = await Apis.getWeather(adcode);
    // weather.value = result;
    update();
  }

  /// 获取详细地址信息
  Future<String?> _getDetailAddress(double latitude, double longitude) async {
    try {
      final result = await Apis.getAmapRegeo(
        latitude: latitude,
        longitude: longitude,
      );

      if (result != null && result.isNotEmpty) {
        final regeocode = result['regeocode'];
        final addressComponent = regeocode['addressComponent'];
        final streetNumber = addressComponent['streetNumber'];

        // 创建LocationResult对象
        final locationData = LocationResult(
          latitude: latitude,
          longitude: longitude,
          country: addressComponent['country'],
          province: addressComponent['province'],
          city: addressComponent['city'],
          district: addressComponent['district'],
          // 处理street字段，可能是数组或字符串
          street: streetNumber['street'] is List
              ? (streetNumber['street'] as List).isNotEmpty
                  ? (streetNumber['street'] as List).first
                  : null
              : streetNumber['street'],
          // 处理number字段，可能是数组或字符串
          streetNumber: streetNumber['number'] is List
              ? (streetNumber['number'] as List).isNotEmpty
                  ? (streetNumber['number'] as List).first
                  : null
              : streetNumber['number'],
          adCode: addressComponent['adcode'],
          cityCode: addressComponent['citycode'],
          address: regeocode['formatted_address'],
        );

        // 处理AOIs信息
        if (regeocode['aois'] != null &&
            regeocode['aois'] is List &&
            (regeocode['aois'] as List).isNotEmpty) {
          final firstAoi = (regeocode['aois'] as List).first;
          locationData.aois = firstAoi['name'];
          // 将AOI名称作为描述
          locationData.description = firstAoi['name'];
        } else if (regeocode['pois'] != null &&
            regeocode['pois'] is List &&
            (regeocode['pois'] as List).isNotEmpty) {
          // 如果没有AOIs，尝试使用POIs的第一个元素
          final firstPoi = (regeocode['pois'] as List).first;
          locationData.description = firstPoi['name'];
        }

        // 更新locationResult
        locationResult.value = locationData;

        return regeocode['formatted_address'];
      }
      return null;
    } catch (e) {
      print("xiaojianjian 获取详细地址出错: $e");
      return null;
    }
  }

  Future<String> getDetailAddress() async {
    if (locationResult.value?.latitude == null ||
        locationResult.value?.longitude == null) {
      return "";
    }
    final result = await _getDetailAddress(locationResult.value?.latitude ?? 0,
        locationResult.value?.longitude ?? 0);
    return result ?? "";
  }

  Future<String> getCompass() async {
    double heading = 0.0;
    Completer<String> completer = Completer();

    // 创建一个 StreamSubscription 来管理监听
    StreamSubscription<CompassEvent>? subscription;

    subscription = FlutterCompass.events?.listen((CompassEvent event) {
      heading = event.heading ?? 0.0; // 方位角

      // 取消监听
      subscription?.cancel();

      // 完成 Future
      completer.complete(heading.toStringAsFixed(2));
    });

    // 设置超时时间（例如 5 秒）
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // 超时后取消监听
        subscription?.cancel();
        // 返回默认值
        return "0.00";
      },
    );
  }

  String getDirectionFromHeading(double heading) {
    if (heading >= 0 && heading < 22.5) {
      return "北";
    } else if (heading >= 22.5 && heading < 67.5) {
      return "东北";
    } else if (heading >= 67.5 && heading < 112.5) {
      return "东";
    } else if (heading >= 112.5 && heading < 157.5) {
      return "东南";
    } else if (heading >= 157.5 && heading < 202.5) {
      return "南";
    } else if (heading >= 202.5 && heading < 247.5) {
      return "西南";
    } else if (heading >= 247.5 && heading < 292.5) {
      return "西";
    } else if (heading >= 292.5 && heading < 337.5) {
      return "西北";
    } else if (heading >= 337.5 && heading <= 360) {
      return "北";
    } else {
      return "未知方向";
    }
  }

  double normalizeHeading(double heading) {
    if (heading < 0) {
      return heading + 360;
    }
    return heading;
  }

  //获取海拔信息
  Future<String> getAltitude() async {
    try {
      print("xiaojianjian 获取海拔信息");
      Position position = await Geolocator.getCurrentPosition();
      print("xiaojianjian 获取海拔信息 ${position.altitude}");
      return position.altitude.toStringAsFixed(2);
    } catch (e) {
      print("xiaojianjian 获取海拔信息失败: $e");
      return "0";
    }
  }

  ///开始定位
  Future<void> startLocation() async {
    searchWeather();
    // 请求权限

    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await _requestLocationPermission();
      return;
    }

    //定位结果监听
    _locationListener =
        _locationPlugin.onLocationChanged().listen((result) async {
      Logger.print("xiaojianjian 定位结果: $result");
      if (result.containsKey("latitude") && result.containsKey("longitude")) {
        if (result['latitude'] is String) {
          result['latitude'] = double.parse(result['latitude'] as String);
        }
        if (result['longitude'] is String) {
          result['longitude'] = double.parse(result['longitude'] as String);
        }

        // 先创建基本的 LocationResult
        locationResult.value = LocationResult.fromJson(result);

        // 然后获取详细地址信息
        final detailAddress = await _getDetailAddress(
            result['latitude'] as double, result['longitude'] as double);

        fullAddress.value = detailAddress;
        update();
      }
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
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = new AMapLocationOption();

      ///是否单次定位
      locationOption.onceLocation = false;

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
