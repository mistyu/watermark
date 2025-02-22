import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/data_sp.dart';
import 'package:watermark_camera/utils/utils.dart';

import '../config.dart';
import '../models/api_resp.dart';

var dio = Dio()..httpClientAdapter = IOHttpClientAdapter();

// 添加一个新的 dio 实例专门用于 logo API
final _logoDio = Dio()
  ..options.baseUrl = 'https://api.logo.dev'
  ..options.headers = {
    'Authorization': 'Bearer sk_D1iigEolTKaTYqw8x1yDrg',
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept-Language': 'zh-CN,zh;q=0.9',
  };

/**
 * http工具类
 * 这里是封装dio，包括拦截器等等
 */
class HttpUtil {
  HttpUtil._();

  static void init() {
    // add interceptors
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      if (response.headers
              .value("content-type")
              ?.contains("application/json") ??
          false) {
        // 如果token过期，则重新登录
        if (response.data != null && response.data['code'] == 401) {
          DataSp.putToken('');
          AppNavigator.startSign();
        }
      }
      return handler.next(response); // continue
    }, onError: (DioException e, handler) {
      // Do something with response error
      return handler.next(e); //continue
    }));

    // 配置dio实例
    dio.options.baseUrl = Config.apiUrl;
    dio.options.connectTimeout = const Duration(seconds: 600); //30s
    dio.options.receiveTimeout = const Duration(seconds: 600);
    dio.options.sendTimeout = const Duration(seconds: 600);
  }

  static Future get(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      bool showErrorToast = true}) async {
    try {
      queryParameters ??= {};
      options ??= Options();
      options.headers ??= {};
      options.headers!['Authorization'] = "Bearer ${DataSp.token}";

      var result = await dio.get(path,
          queryParameters: queryParameters, options: options);
      var resp = ApiResp.fromJson(result.data!);
      if (resp.code == 200) {
        // 直接返回对于的data
        return resp.data;
      } else {
        if (showErrorToast && Config.isDev) {
          Utils.showToast(resp.msg);
        }
        return Future.error(resp.msg);
      }
    } catch (error) {
      if (error is DioException) {
        final errorMsg = '接口：$path  信息：${error.message}';
        if (showErrorToast && Config.isDev) Utils.showToast(errorMsg);
        return Future.error(errorMsg);
      }
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (showErrorToast && Config.isDev) Utils.showToast(errorMsg);
      return Future.error(error);
    }
  }

  static Future post(
    String path, {
    dynamic data,
    bool showErrorToast = true,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      data ??= {};
      options ??= Options();
      options.headers ??= {};
      options.headers!['Authorization'] = "Bearer ${DataSp.token}";

      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      var resp = ApiResp.fromJson(result.data!);
      if (resp.code == 200) {
        return resp.data;
      } else {
        if (showErrorToast && Config.isDev) {
          Utils.showToast(resp.msg);
          // Utils.showToast(ApiError.getMsg(resp.errCode));
        }

        return Future.error(resp.msg);
      }
    } catch (error) {
      if (error is DioException) {
        final errorMsg = '接口：$path  信息：${error.message}';
        if (showErrorToast && Config.isDev) Utils.showToast(errorMsg);
        return Future.error(errorMsg);
      }
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (showErrorToast && Config.isDev) Utils.showToast(errorMsg);
      return Future.error(error);
    }
  }

  static Future download(
    String url, {
    required String cachePath,
    CancelToken? cancelToken,
    Function(int count, int total)? onProgress,
  }) {
    return dio.download(
      url,
      cachePath,
      options: Options(
        receiveTimeout: const Duration(minutes: 10),
      ),
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
    );
  }

  static Future saveImage(Image image) async {
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      Uint8List uint8list = byteData.buffer.asUint8List();
      await Gal.putImageBytes(Uint8List.fromList(uint8list));
      var tips = "保存成功";
      Utils.showToast(tips);
    }
  }

  static Future saveUrlVideo(
    String url, {
    CancelToken? cancelToken,
    Function(int count, int total)? onProgress,
  }) async {
    final name = url.substring(url.lastIndexOf('/') + 1);
    final cachePath = await Utils.getTempFilePath(dir: 'video', name: name);
    return download(
      url,
      cachePath: cachePath,
      cancelToken: cancelToken,
      onProgress: (int count, int total) async {
        if (count == total) {
          await Gal.putVideo(cachePath);
          var tips = "保存成功";
          Utils.showToast(tips);
        }
      },
    );
  }

  static Future<void> saveImageToGallerySaver(File file) async {
    return Gal.putImage(file.path, album: '修改牛水印相机');
  }

  static Future<void> saveVideoToGallerySaver(File file) async {
    return Gal.putVideo(file.path, album: '修改牛水印相机');
  }

  /// 搜索品牌 logo
  /// [query] 搜索关键词
  static Future<dynamic> searchBrandLogo(String query) async {
    print('searchBrandLogo: $query');
    try {
      final encodedQuery = Uri.encodeComponent(query);
      print('encodedQuery: $encodedQuery');

      // 直接构建完整的URL
      final url = '/search?q=$encodedQuery';
      print('请求URL: $url');

      final response = await _logoDio.get(
        url,
        options: Options(
          validateStatus: (status) => true,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      );
      print('response: ${response.data}');
      return response.data;
    } catch (e, stackTrace) {
      print('Error searching logo: $e');
      print('Stack trace: $stackTrace');
      return Future.error('搜索出错: $e');
    }
  }
}
