import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermark_camera/utils/library.dart';

import 'utils/db_helper.dart';

class Config {
  static const uiW = 375.0;
  static const uiH = 812.0;
  static const double textScaleFactor = 1.0;

  static const wxAppId = "wx6913e84736668ecb";
  static const wxAppSecret = "5efca8f057ef031eba67bedb6f0e7383";

  static const amapAndroidApiKey = "5ae757948fbe9c097a6e71fafc9c2862";
  static const amapIosApiKey = "9a23c9b6d14aa3e6192ca5e5c5122df5";
  static const amapWebApiKey = "53fe6a655c958b481c1c6d2f8413da0a";
  static const amapLocationApiKey = "53fe6a655c958b481c1c6d2f8413da0a";
  static const baiduMapAndroidApiKey = "QiWAa53OTpTHtvgywEWrUOWFA62LZC04";

  static late bool isDev;

  static late String apiUrl;

  static late String staticUrl;

  static late String cachePath;

  static Future init(Function() runApp) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      isDev =
          dotenv.get('ENVIRONMENT', fallback: 'development').contains('dev');
      apiUrl = dotenv.get('API_URL', fallback: 'http://127.0.0.1:8080');
      staticUrl = dotenv.get("STATIC_URL", fallback: 'http://127.0.0.1:8080');

      initEazyLoading();
      await DataSp.init();
      // 初始化数据库
      await DBHelper.initDB();
      HttpUtil.init();
      final path = (await getApplicationDocumentsDirectory()).path;
      cachePath = '$path/';
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
      runApp();
      // 注册应用退出回调
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg == AppLifecycleState.detached.toString()) {
          await DBHelper.close();
        }
        return null;
      });
    } catch (e) {
      Logger.print("Config init error: $e");
    }
  }

  static initEazyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..contentPadding =
          const EdgeInsets.symmetric(vertical: 10, horizontal: 16)
      ..toastPosition = EasyLoadingToastPosition.top
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 12
      ..progressColor = Styles.c_0C8CE9
      ..backgroundColor = const Color(0xFF1A1A1A)
      ..indicatorColor = Styles.c_0C8CE9
      ..textColor = Styles.c_FFFFFF
      ..maskColor = Styles.c_0D0D0D.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = true;
  }
}
