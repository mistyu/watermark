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

final _locationDio = Dio()
  ..options.baseUrl = 'https://restapi.amap.com'
  ..options.headers = {
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

  static Future getBrandLogoList(String path,
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
      var resp = TableListResp.fromJson(result.data!);
      print("getBrandLogoList resp: $resp");
      if (resp.code == 200) {
        return resp;
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
    try {
      final encodedQuery = Uri.encodeComponent(query);

      // 直接构建完整的URL
      final url = '/search?q=$encodedQuery';

      final response = await _logoDio.get(
        url,
        options: Options(
          validateStatus: (status) => true,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      );
      return response.data;
    } catch (e, stackTrace) {
      return Future.error('搜索出错: $e');
    }
  }

  static Future<dynamic> searchLocation(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);

      // 直接构建完整的URL
      final url = '/search?q=$encodedQuery';

      final response = await _logoDio.get(
        url,
        options: Options(
          validateStatus: (status) => true,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      );
      return response.data;
    } catch (e, stackTrace) {
      return Future.error('搜索出错: $e');
    }
  }

  /// 高德地图周边搜索
  /// [location] 中心点坐标，格式："116.473168,39.993015"
  /// [radius] 查询半径，单位：米
  /// [types] 查询POI类型
  /// [page] 当前页数
  /// [offset] 每页记录数
  static Future<dynamic> searchAround({
    required String location,
    String? keywords,
    int radius = 1000,
    String? types,
    int page = 1,
    int offset = 20,
  }) async {
    try {
      final response = await _locationDio.get(
        '/v5/place/around',
        queryParameters: {
          'key': Config.amapLocationApiKey,
          'location': location,
          if (keywords != null) 'keywords': keywords,
          if (types != null) 'types': types,
          'radius': radius,
          'page_size': offset,
          'page_num': page,
        },
      );
      print("高德地图周边搜索response: $response");
      if (response.data['status'] == '1') {
        return response.data;
      } else {
        Utils.showToast(response.data['info'] ?? '获取周边失败');
      }
    } catch (e) {
      return Future.error('周边搜索失败: $e');
    }
  }

  /// 高德地图关键字搜索
  /// [keywords] 查询关键字
  /// [city] 查询城市
  /// [types] 查询POI类型
  /// [page] 当前页数
  /// [pageSize] 每页记录数
  static Future<dynamic> searchByKeyword({
    required String keywords,
    String? city,
    String? types,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _locationDio.get(
        '/v5/place/text',
        queryParameters: {
          'key': Config.amapLocationApiKey,
          'keywords': keywords,
          if (city != null) 'region': city,
          if (types != null) 'types': types,
          'page_size': pageSize,
          'page_num': page,
          'show_fields': 'business,photos,indoor',
        },
      );

      if (response.data['status'] == '1') {
        return response.data;
      } else {
        Utils.showToast(response.data['info'] ?? '搜索失败');
      }
    } catch (e) {
      return Future.error('关键字搜索失败: $e');
    }
  }
}
