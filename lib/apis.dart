import 'package:dio/dio.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/network_brand/network_brand.dart';
import 'package:watermark_camera/models/resource/resource.dart';

import 'models/watermark_brand/watermark_brand.dart';
import 'models/weather/weather.dart';
import 'utils/http_util.dart';

class Apis {
  static Future<dynamic> getMyBrandLogoList(
      {int pageNum = 1, int pageSize = 10, String? logoName}) async {
    print("getMyBrandLogoList api");
    final result =
        await HttpUtil.getBrandLogoList(Urls.myBrandLogo, queryParameters: {
      "pageNum": pageNum,
      "pageSize": pageSize,
      "logoName": logoName,
    });
    print("getMyBrandLogoList result: $result");
    return result;
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
    String url = Urls.exchangeActivateCode + "/$code";
    return await HttpUtil.post(url);
  }

  static Future<dynamic> changeNickName(String name) async {
    return await HttpUtil.post(Urls.updateUserInfo, data: {"nickname": name});
  }

  static Future<dynamic> upLoadFile(FormData formData) async {
    return await HttpUtil.post(
      Urls.uploadImage, // 使用正确的上传头像API地址
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Accept': '*/*',
        },
      ),
    );
  }

  static Future<dynamic> getMembershipPackage() async {
    return await HttpUtil.get(Urls.getMembershipPackage);
  }

  static Future<dynamic> pay(String packageId) async {
    String url = Urls.pay + "/$packageId";
    return await HttpUtil.post(url);
  }

  static Future<List<NetworkBrand>> searchBrandLogo(String query) async {
    try {
      final result = await HttpUtil.searchBrandLogo(query);

      // 确保 result 是 List 类型
      if (result is List) {
        return result.map((item) => NetworkBrand.fromJson(item)).toList();
      } else {
        print('Unexpected result type: ${result.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error in searchBrandLogo: $e');
      return [];
    }
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
  static const String pay = "/app/api/pay/create"; // 支付
  static const String getMembershipPackage = "/app/api/package/list"; // 获取会员套餐
  static const String uploadImage = "/app/api/user/uploadAvatar"; // 上传图片
  static const String updateUserInfo = "/app/api/user/updateNickname"; // 修改昵称

  static const String weather = "/app/api/third/weather"; // 天气
  static const String category = "/app/api/category"; // 水印分类
  static const String resource = "/app/api/resource"; // 水印资源
  static const String rightBottomResource = "/app/api/rightbottom/"; // 右下角水印资源

  static const String uploadBrandLogo = "/app/api/brandLogo/upload"; // 上传品牌logo
  static const String myBrandLogo = "/app/api/brandLogo/list"; // 品牌logo
}
