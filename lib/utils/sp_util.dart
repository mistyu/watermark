import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/**
 * 本地存储
 * 
 */
class SpUtil {
  static SharedPreferences? _prefs;

  SpUtil._();

  static final SpUtil _singleton = SpUtil._();

  factory SpUtil() => _singleton;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      print('SpUtil initialized successfully');
    } catch (e) {
      print('SpUtil initialization error: $e');
    }
  }

  Future<bool>? putObject(String key, Object value) {
    return _prefs?.setString(key, json.encode(value));
  }

  T? getObj<T>(String key, T Function(Map v) f, {T? defValue}) {
    final map = getObject(key);
    return map == null ? defValue : f(map);
  }

  Map? getObject(String key) {
    final data = _prefs?.getString(key);
    print('Getting value for $key: $data');
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  Future<bool>? putObjectList(String key, List<Object> list) {
    final dataList = list.map((value) => json.encode(value)).toList();
    return _prefs?.setStringList(key, dataList);
  }

  List<T>? getObjList<T>(
    String key,
    T Function(Map v) f, {
    List<T>? defValue = const [],
  }) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) => f(value)).toList();
    return list ?? defValue;
  }

  List<Map>? getObjectList(String key) {
    List<String>? dataLis = _prefs?.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  String? getString(String key, {String? defValue = ''}) {
    final value = _prefs?.getString(key);
    print('Getting value for $key: $value');
    return value ?? defValue;
  }

  Future<bool>? putString(String key, String value) {
    print('Saving value for $key: $value');
    return _prefs?.setString(key, value);
  }

  bool? getBool(String key, {bool? defValue = false}) {
    return _prefs?.getBool(key) ?? defValue;
  }

  Future<bool>? putBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  int? getInt(String key, {int? defValue = 0}) {
    return _prefs?.getInt(key) ?? defValue;
  }

  Future<bool>? putInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  double? getDouble(String key, {double? defValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defValue;
  }

  Future<bool>? putDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  List<String>? getStringList(String key, {List<String>? defValue = const []}) {
    return _prefs?.getStringList(key) ?? defValue;
  }

  Future<bool>? putStringList(String key, List<String> value) {
    return _prefs?.setStringList(key, value);
  }

  dynamic getDynamic(String key, {Object? defValue}) {
    return _prefs?.get(key) ?? defValue;
  }

  bool? haveKey(String key) {
    return _prefs?.getKeys().contains(key);
  }

  bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  Future<bool>? clear() {
    return _prefs?.clear();
  }

  Future<void>? reload() {
    return _prefs?.reload();
  }

  bool isInitialized() {
    return null != _prefs;
  }

  SharedPreferences? getSp() {
    return _prefs;
  }

  Future<bool>? delete(String key) {
    print('Deleting value for key: $key');
    return _prefs?.remove(key);
  }

  Future<bool>? deleteAll(List<String> keys) async {
    try {
      for (var key in keys) {
        await _prefs?.remove(key);
      }
      print('Deleted values for keys: $keys');
      return true;
    } catch (e) {
      print('Error deleting values: $e');
      return false;
    }
  }

  Future<bool>? deleteWithPrefix(String prefix) async {
    try {
      final keys = getKeys();
      if (keys == null) return false;

      final keysToDelete = keys.where((key) => key.startsWith(prefix)).toList();
      for (var key in keysToDelete) {
        await _prefs?.remove(key);
      }
      print('Deleted all values with prefix: $prefix');
      return true;
    } catch (e) {
      print('Error deleting values with prefix: $e');
      return false;
    }
  }
}
