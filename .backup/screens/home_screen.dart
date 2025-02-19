import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/bloc/cubit/location_cubit.dart';
import 'package:watermark_camera/bloc/cubit/resource_cubit.dart';
import 'package:watermark_camera/bloc/cubit/right_bottom_cubit.dart';
import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/camera/camera_screen.dart';
import 'package:watermark_camera/models/template/template.dart';
import 'package:watermark_camera/user/random_user.dart';
import 'package:watermark_camera/utils/dialog.dart';
import 'package:watermark_camera/utils/http.dart';
import 'package:watermark_camera/utils/watermark.dart';

import '../config/prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _init() async {
    // permissionAdd();
    Result? res = await getUserandToken();
    final token = res?.data['token'];
    final userInfo = res?.data['userInfo'];
    await AppStorage.prefs?.setString("userInfo", json.encode(userInfo));
    await AppStorage.prefs?.setString("token", token);
  }

  // Future<void> _getLocation() async {
  //   // 检查权限
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
//
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
//
  //   // 获取当前位置
  //   // _locationData = await location.getLocation();
  //   _getAddressFromAmap();
  // }
  void permissionAdd() async {
    final permissions = [
      // Permission.notification,
      Permission.storage,
      Permission.location,
      Permission.camera,
    ];
    for (var permission in permissions) {
      final state = await permission.request();
    }
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        // locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
        );
  }

  // 使用高德 API 获取城市信息
  Future<void> _getAddressFromAmap() async {
    String apiKey = '2f0b40ebf9d7dc229eeb19cd85dcba1d'; // 替换为你自己的高德 API Ke

    try {
      final position = await _getLocation();
      var latitude = NumberFormat("###.######").format(position.latitude);
      var longitude = NumberFormat("###.######").format(position.longitude);
      // 坐标转换
      var res = await Http.getInstance(baseUrl: "https://restapi.amap.com")
          .get("/v3/assistant/coordinate/convert", params: {
        'locations': '$longitude,$latitude',
        'key': apiKey,
        'coordsys': 'gps'
      });
      var locations = res?.locations;
      // 分割字符串
      List<String> parts = locations.split(',');
      var newlatitude =
          NumberFormat("###.######").format(double.parse(parts[1]));
      var newlongitude =
          NumberFormat("###.######").format(double.parse(parts[0]));
      // 逆地理编码
      var response = await Http.getInstance(baseUrl: "https://restapi.amap.com")
          .get("/v3/geocode/regeo", params: {
        'location': '$newlongitude,$newlatitude',
        'key': apiKey
      });
      var regeocode = response?.regeocode;

      String adCode = regeocode['addressComponent']['adcode'];
      // 获取天气
      final resWeather =
          await Http.getInstance(baseUrl: "https://restapi.amap.com").get(
              '/v3/weather/weatherInfo',
              params: {"key": apiKey, "city": adCode},
              options: Options(extra: {"showError": false}));
      var weather = resWeather?.lives;
      if (context.mounted) {
        context.read<LocationCubit>().loadedLocation(
            location: regeocode,
            weather: weather[0],
            latitude: newlatitude,
            longitude: newlongitude);
      }
    } catch (e) {
      print("-----------${e.toString()}-----------------");
    }
  }

  @override
  void initState() {
    super.initState();
    // _getLocation();
    _getAddressFromAmap();
    //在每一帧绘制完成后再回调执行自定义的方法
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
      await context.read<ResourceCubit>().loadedResources();
      if (mounted) {
        final template = context
            .read<ResourceCubit>()
            .templates
            .firstWhereOrNull((e) => e.id == 1698049557635);
        // final rightbottoms = context.read<ResourceCubit>().rightbottom;
        final rightbottom = context
            .read<ResourceCubit>()
            .rightbottom
            .firstWhereOrNull((e) => e.id == 26986609252200);
        final watermarkView =
            await getWatermarkViewData(context, template?.id ?? 1698049557635);
        // if (context.mounted) {
        context.read<WatermarkCubit>().loadedWatermarkView(
              template?.id ?? 1698049557635,
              watermarkView: watermarkView,
            );
        final rightBottomView = await getRightBottomViewData(
            context, rightbottom?.id ?? 26986609252200);

        context.read<RightBottomCubit>().loadedWatermarkView(
            id: rightbottom?.id ?? 26986609252200,
            rightBottomView: rightBottomView);
      }

      final isInit = AppStorage.prefs?.getBool("init");
      if (isInit != true) {
        final result = await CommonDialog.checkPrivacyPolicy(context);
        if (true == result) {
          AppStorage.prefs?.setBool("init", true);
        } else {
          SystemNavigator.pop();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const CameraScreen();
  }
}
