import 'package:dio/dio.dart';
import 'package:watermark_camera/config.dart';
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
    print("getMyBrandLogoList result: ${result}");
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

  static Future<dynamic> wechatLogin(String code) async {
    final result = await HttpUtil.post(Urls.wechatLogin, data: {"code": code});
    return result;
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

  /// 高德地图周边搜索
  static Future<dynamic> searchNearbyPOI({
    required double latitude,
    required double longitude,
    String? keywords,
    int radius = 1000,
    String? types,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final location = '$longitude,$latitude';
      final result = await HttpUtil.searchAround(
        location: location,
        keywords: keywords,
        radius: radius,
        types: types,
        page: page,
        offset: pageSize,
      );

      // 直接返回原始数据，让调用方处理
      return result;
    } catch (e) {
      print('Error in searchNearbyPOI: $e');
      return {'pois': [], 'count': '0'};
    }
  }

  /// 高德地图关键字搜索d
  static Future<List<dynamic>> searchPOIByKeyword({
    required String keywords,
    String? city,
    String? types,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await HttpUtil.searchByKeyword(
        keywords: keywords,
        city: city,
        types: types,
        page: page,
        pageSize: pageSize,
      );

      return result['pois'] ?? [];
    } catch (e) {
      print('Error in searchPOIByKeyword: $e');
      return [];
    }
  }

  /// 发送消息到AI接口
  static Future<Map<String, dynamic>> sendMessageToAI(String message) async {
    final key = "sk-tpwpjajnnwujcjevdzmjazrquyvcksilcohcwuidkdahvavk";

    String text = "根据这个问题“$message？”, 根据";
    final chooseAns = [
      "（1）亲，首先点击左下角水印，然后选择要修改的水印，进入编辑页，选择时间和日期修改，保存确定即可。",
      "（2）亲，首先点击左下角的水印，然后选择要修改的水印，进入编辑页，选择地点修改，保存确定即可。",
      "（3）亲，在拍照页面点右上角更多-把右下角水印开关打开，就可以选择想要的右下角水印添加了。",
      "（4）首先点击左下角的相册，然后点【照片】图标，选择需要修改的照片，点击水印根据需要添加水印，最后点击保存就可以完成了。"
    ];
    for (var i = 0; i < chooseAns.length; i++) {
      text += message;
    }
    String len = chooseAns.length.toString();
    text += "从上述$len个选项中， 推断一下最合适的选项进行回复。";

    text +=
        "只选择一个最合适的进行回复, 如果都不符合, 默认返回”请联系人工客服，谢谢“这几个字。注意不要有多余的字，严格按照选项中的内容和默认内容直接返回";

    try {
      final Map<String, dynamic> data = {
        "model": "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
        "messages": [
          {"role": "user", "content": text}
        ],
        "stream": false,
        "max_tokens": 512,
        "stop": null,
        "temperature": 0.7,
        "top_p": 0.7,
        "top_k": 50,
        "frequency_penalty": 0.5,
        "n": 1,
        "response_format": {"type": "text"},
        "tools": [
          {
            "type": "function",
            "function": {
              "description": "",
              "name": "",
              "parameters": {},
              "strict": false
            }
          }
        ]
      };

      final result = await HttpUtil.post(
        'https://api.siliconflow.cn/v1/chat/completions',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${key}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (result != null) {
        return result;
      }
      return {};
    } catch (e) {
      print('Error sending message to AI: $e');
      return {};
    }
  }

  /// 高德地图逆地理编码
  static Future<Map<String, dynamic>> getAmapRegeo({
    required double latitude,
    required double longitude,
  }) async {
    return await HttpUtil.getAmapRegeo(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// 验证码
  static Future<Map<String, dynamic>?> getCaptcha() async {
    final response = await HttpUtil.get(Urls.captcha, queryParameters: {
      "len": "4",
      "type": "0",
      "app_id": "npyzntnormmjploq",
      "app_secret": "NpQq9yOc1nYYkilb8NhuM7DsxBdxOPiX",
    });
    return response;
  }

  static Future<dynamic> getCustomerService() async {
    final response = await HttpUtil.get(Urls.customerService);
    if (response != null) {
      return Config.apiUrl + response['url'];
    }
    return "";
  }

  static Future<dynamic> userDeductTimes(int count) async {
    final url = "${Urls.userDeductTimes}/$count";
    final result = await HttpUtil.post(url);
  }
}

class Urls {
  static const String checkLogin = "/app/api/user/checkLogin"; // 检查登入
  static const String getCode = "/app/api/user/smsCode"; // 获取验证码
  static const String smsLogin = "/app/api/user/smsLogin"; // 短信登录
  static const String getUserInfo = "/app/api/user/getUserInfo"; // 获取用户信息
  static const String phoneLogin = "/app/api/user/phoneLogin"; // 手机号登录
  static const String visitorLogin = "/app/api/user/visitorLogin"; // 游客登入
  static const String wechatLogin = "/app/api/user/wechatLogin"; // 微信登录
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

  static const String aiChat = 'https://api.siliconflow.cn/v1/chat/completions';

  static const String captcha =
      'https://www.mxnzp.com/api/verifycode/code'; // 验证码

  static const String customerService = "/app/api/common/current";

  static const String userDeductTimes = "/app/api/times/deduct/"; // 扣除次数
}
