import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/models/db/watermark/watermark_save.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

import '../models/base_db_model.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'xgn_camera.db';
  static const int dbVersion = 6;

  static LocationModel locationModel = LocationModel();
  static WatermarkSettingsModel watermarkSettingsModel =
      WatermarkSettingsModel(resourceId: '', watermarkView: WatermarkView());
  static WatermarkSaveModel watermarkSaveModel = WatermarkSaveModel(
    name: '', // 提供一个空字符串作为默认名称
    resourceId: '', // 提供一个空字符串作为默认资源ID
  );

  // 获取数据库实例的方法现在可以更简单
  static Future<Database> get database async {
    if (_db == null) {
      await initDB();
    }
    return _db!;
  }

  // 初始化数据库
  static Future<void> initDB() async {
    if (_db != null) return;
    String path = join(await getDatabasesPath(), dbName);
    final db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );

    _db = db;
  }

  // 创建表
  static Future<void> _onCreate(Database db, int version) async {
    await createTable(db, locationModel);
    await createTable(db, watermarkSettingsModel);
    await createTable(db, watermarkSaveModel);
  }

  // 升级数据库
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      // 如果是从旧版本升级，添加新表
      try {
        // 先删除旧表（如果存在）
        await db
            .execute('DROP TABLE IF EXISTS ${watermarkSaveModel.tableName}');
        // 重新创建表
        await createTable(db, watermarkSaveModel);
      } catch (e) {
        print("xiaojianjian 创建watermark_save表失败: $e");
      }
    }
  }

  // 降级数据库
  static Future<void> _onDowngrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion > dbVersion) {
      await db.execute('DROP TABLE IF EXISTS ${locationModel.tableName}');
      await db
          .execute('DROP TABLE IF EXISTS ${watermarkSettingsModel.tableName}');
      await db.execute('DROP TABLE IF EXISTS ${watermarkSaveModel.tableName}');
      await _onCreate(db, newVersion);
    }
  }

  // 插入数据
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 查询所有数据
  static Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // 根据条件查询数据
  static Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  // 更新数据
  static Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  // 删除数据
  static Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // 执行原生 SQL 查询
  static Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  // 关闭数据库
  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  // 使用 Model 创建表
  static Future<void> createTable(Database db, BaseDBModel model) async {
    await db.execute(model.createTableSql);
  }

  // 插入模型
  static Future<int> insertModel(BaseDBModel model) async {
    final db = await database;
    return await db.insert(
      model.tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 批量插入 Model
  static Future<List<int>> insertModels(List<BaseDBModel> models) async {
    final db = await database;
    final batch = db.batch();

    for (var model in models) {
      batch.insert(
        model.tableName,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final results = await batch.commit();
    return results.cast<int>();
  }

  static Future<int> updateModel(
    BaseDBModel model, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      model.tableName,
      model.toJson(),
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> deleteModel(BaseDBModel model,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(
      model.tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  // 查询并返回 Model 列表
  static Future<List<T>> queryModels<T extends BaseDBModel>(
    T model, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      model.tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );

    return maps.map((map) => model.fromJson(map) as T).toList();
  }

  // 添加保存水印相关的方法
  // 保存水印（添加url参数支持）
  static Future<int> saveWatermark(WatermarkSaveModel model) async {
    final db = await database;
    return await db.insert(
      model.tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 获取所有保存的水印
  static Future<List<WatermarkSaveModel>> getAllSavedWatermarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      orderBy: 'updated_at DESC', // 按更新时间降序排列
    );

    return maps.map((map) => watermarkSaveModel.fromJson(map)).toList();
  }

  // 根据ID获取保存的水印
  static Future<WatermarkSaveModel?> getSavedWatermarkById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return watermarkSaveModel.fromJson(maps.first);
  }

  // 更新保存的水印
  static Future<int> updateSavedWatermark(WatermarkSaveModel model) async {
    final db = await database;
    return await db.update(
      model.tableName,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // 删除保存的水印
  static Future<int> deleteSavedWatermark(int id) async {
    final db = await database;
    return await db.delete(
      watermarkSaveModel.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 根据名称搜索保存的水印
  static Future<List<WatermarkSaveModel>> searchSavedWatermarks(
      String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => watermarkSaveModel.fromJson(map)).toList();
  }

  // 检查水印名称是否已存在
  static Future<bool> isWatermarkNameExists(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  // 根据URL查询保存的水印
  static Future<WatermarkSaveModel?> getSavedWatermarkByUrl(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return watermarkSaveModel.fromJson(maps.first);
  }

  // 检查水印URL是否已存在
  static Future<bool> isWatermarkUrlExists(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  // 根据resourceId查询保存的水印列表
  static Future<List<WatermarkSaveModel>> getSavedWatermarksByResourceId(
      String resourceId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      watermarkSaveModel.tableName,
      where: 'resource_id = ?',
      whereArgs: [resourceId],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => watermarkSaveModel.fromJson(map)).toList();
  }

  // 更新水印URL
  static Future<int> updateWatermarkUrl(int id, String url) async {
    final db = await database;
    return await db.update(
      watermarkSaveModel.tableName,
      {'url': url, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // // 添加一个方法来检查并修复表结构
  // static Future<void> checkAndFixTableStructure() async {
  //   try {
  //     final db = await database;

  //     // 检查表是否存在
  //     final tables = await db.rawQuery(
  //         "SELECT name FROM sqlite_master WHERE type='table' AND name='${watermarkSaveModel.tableName}'");

  //     if (tables.isEmpty) {
  //       // 表不存在，创建它
  //       await createTable(db, watermarkSaveModel);
  //       return;
  //     }

  //     // 检查表结构
  //     final columns = await db
  //         .rawQuery("PRAGMA table_info(${watermarkSaveModel.tableName})");
  //     final columnNames = columns.map((c) => c['name'] as String).toList();

  //     // 检查是否缺少url列
  //     if (!columnNames.contains('url')) {
  //       // 添加url列
  //       await db.execute(
  //           "ALTER TABLE ${watermarkSaveModel.tableName} ADD COLUMN url TEXT");
  //       print("xiaojianjian 添加url列成功");
  //     }
  //   } catch (e) {
  //     print("xiaojianjian 检查表结构失败: $e");
  //   }
  // }
}
