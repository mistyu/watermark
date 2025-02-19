import 'package:dio/dio.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/resource/resource.dart';

import 'models/watermark_brand/watermark_brand.dart';
import 'models/weather/weather.dart';
import 'utils/http_util.dart';

class Apis {
  static Future<List<WatermarkBrand>> getBrandLogoList(
      {int? pageNum, int? pageSize}) async {
    final result = await HttpUtil.get(Urls.brandLogo, queryParameters: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
    if (result != null) {
      return (result as List).map((e) => WatermarkBrand.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<WatermarkBrand>> getMyBrandLogoList(
      {int? pageNum, int? pageSize}) async {
    final result = await HttpUtil.get(Urls.myBrandLogo, queryParameters: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
    if (result != null) {
      return (result as List).map((e) => WatermarkBrand.fromJson(e)).toList();
    }
    return [];
  }

  static Future<WatermarkBrand?> uploadBrandLogo(FormData formData) async {
    final result = await HttpUtil.post(Urls.uploadBrandLogo, data: formData);
    if (result != null) {
      return WatermarkBrand.fromJson(result);
    }
    return null;
  }

  static Future<Weather?> getWeather(String adcode) async {
    final result =
        await HttpUtil.get(Urls.weather, queryParameters: {"adcode": adcode});
    if (result != null) {
      return Weather.fromJson(result);
    }
    return null;
  }

  static Future<List<Category>> getCategory() async {
    final result = await HttpUtil.get(Urls.category);
    if (result != null) {
      return (result as List).map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<WatermarkResource>> getResource() async {
    final result = await HttpUtil.get(Urls.resource);
    if (result != null) {
      return (result as List)
          .map((e) => WatermarkResource.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<RightBottomResource>> getRightBottomResource() async {
    final result = await HttpUtil.get(Urls.rightBottomResource);
    if (result != null) {
      return (result as List)
          .map((e) => RightBottomResource.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<String?> login(String operationId) async {
    final result = await HttpUtil.post(Urls.phoneLogin,
        data: {"operationId": operationId});
    return result['token'];
  }

  static Future<dynamic> register() async {
    return await HttpUtil.post(Urls.visitorLogin);
  }

  static Future<dynamic> Login() async {
    return await HttpUtil.get(Urls.checkLogin);
  }

  static Future<dynamic> checkLogin() async {
    return await HttpUtil.get(Urls.checkLogin);
  }

  static Future<dynamic> visitorLogin(String deviceId) async {
    return await HttpUtil.post(Urls.visitorLogin, data: {"deviceId": deviceId});
  }

  static Future<dynamic> getCode(String phone) async {
    return await HttpUtil.post(Urls.getCode,
        data: {"phone": phone, 'code': ""});
  }

  static Future<dynamic> smsLogin(String phone, String code) async {
    return await HttpUtil.post(Urls.phoneLogin,
        data: {"phone": phone, 'code': code});
  }

  static Future<dynamic> getUserInfo() async {
    return await HttpUtil.get(Urls.getUserInfo);
  }

  static Future<dynamic> exchangeActivateCode(String code) async {
    print("exchangeActivateCode: $code");
    String url = Urls.exchangeActivateCode + "/$code";
    return await HttpUtil.post(url);
  }
}

class Urls {
  static const String checkLogin = "/app/api/user/checkLogin"; // 检查登入
  static const String getCode = "/app/api/user/smsCode"; // 获取验证码
  static const String smsLogin = "/app/api/user/smsLogin"; // 短信登录
  static const String getUserInfo = "/app/api/user/getUserInfo"; // 获取用户信息
  static const String phoneLogin = "/app/api/user/phoneLogin"; // 手机号登录
  static const String visitorLogin = "/app/api/user/visitorLogin"; // 游客登入
  static const String exchangeActivateCode =
      "/app/api/times/activation"; // 激活码兑换

  static const String weather = "/app/api/third/weather"; // 天气
  static const String category = "/app/api/category"; // 水印分类
  static const String resource = "/app/api/resource"; // 水印资源
  static const String rightBottomResource = "/app/api/rightbottom/"; // 右下角水印资源

  static const String brandLogo = "/client/brand/list"; // 品牌logo
  static const String uploadBrandLogo = "/client/brand/upload"; // 上传品牌logo
  static const String myBrandLogo = "/client/brand/myList"; // 品牌logo
}
