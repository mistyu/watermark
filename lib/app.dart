import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/custom_cupertino_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config.dart';
import 'core/controller/app_controller.dart';
import 'core/controller/location_controller.dart';
import 'core/controller/permission_controller.dart';
import 'core/controller/watermark_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/logger.dart';
import 'utils/styles.dart';
import 'services/sse_service.dart';

class WaterMarkCameraAppView extends StatelessWidget {
  const WaterMarkCameraAppView({super.key, required this.builder});
  final Widget Function(TransitionBuilder builder) builder;

  static TransitionBuilder _builder() => EasyLoading.init(
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(Config.textScaleFactor),
            ),
            child: widget!,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) => ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(Config.uiW, Config.uiH),
          minTextAdapt: true,
          splitScreenMode: true,
          child: builder(_builder())),
    );
  }
}

class WaterMarkCameraApp extends StatelessWidget {
  const WaterMarkCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Styles.c_FFFFFF,
          systemNavigationBarDividerColor: Styles.c_EDEDED,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: WaterMarkCameraAppView(
        builder: (builder) => GetMaterialApp(
          theme: Styles.lightTheme,
          debugShowCheckedModeBanner: true,
          enableLog: false,
          builder: builder,
          logWriterCallback: Logger.print,
          darkTheme: Styles.darkTheme,
          themeMode: ThemeMode.light,
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          initialRoute: AppRoutes.splash,
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            CustomCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'), // 中文简体
            //其它Locales
          ],
          // fallbackLocale: const Locale('en', 'US'), // 添加一个备用的Locale
        ),
      ),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {}
}
