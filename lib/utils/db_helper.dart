import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

import '../models/base_db_model.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'xgn_camera.db';
  static const int dbVersion = 2;

  static LocationModel locationModel = LocationModel();
  static WatermarkSettingsModel watermarkSettingsModel =
      WatermarkSettingsModel(resourceId: '', watermarkView: WatermarkView());

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
  }

  // 升级数据库
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < dbVersion) {
      await db.execute('DROP TABLE IF EXISTS ${locationModel.tableName}');
      await db
          .execute('DROP TABLE IF EXISTS ${watermarkSettingsModel.tableName}');
      await _onCreate(db, newVersion);
    }
  }

  // 降级数据库
  static Future<void> _onDowngrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion > dbVersion) {
      await db.execute('DROP TABLE IF EXISTS ${locationModel.tableName}');
      await db
          .execute('DROP TABLE IF EXISTS ${watermarkSettingsModel.tableName}');
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
  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
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

  // 插入 Model
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
}
