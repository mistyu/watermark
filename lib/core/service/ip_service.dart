import 'dart:io';

import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:dio/dio.dart';

class IpService {
  // 获取公网ip
  static Future<String> getCityCode() async {
    const url = "https://restapi.amap.com/v3/ip";
    try {
      final response =
          await dio.get(url, queryParameters: {"key": Config.amapWebApiKey});
      if (response.data != null) {
        return response.data['adcode'] ?? '';
      }
      return '';
    } on DioException catch (e) {
      Logger.print('获取公网ip失败: $e');
    } catch (e) {
      Logger.print('获取公网ip失败: $e');
    }
    return '';
  }

  // 获取局域网ip
  static Future<String?> getLocalIp() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();

      // 遍历接口获取第一个非回环的 IPv4 地址
      for (var i in interfaces) {
        for (var address in i.addresses) {
          if (address.type == InternetAddressType.IPv4 &&
              !address.isLoopback &&
              address.address.startsWith('192.168.') &&
              address.address.startsWith('172.')) {
            Logger.print('设备局域网 IP 地址: ${address.address}');
            return address.address;
          }
        }
      }
      return null;
    } catch (e) {
      Logger.print('获取设备局域网  IP 地址失败: $e');
    }
    return null;
  }
}
