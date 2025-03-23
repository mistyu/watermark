library watermark;

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

export 'http_util.dart';
export 'asset_utils.dart';
export 'custom_ext.dart';
export 'styles.dart';
export 'utils.dart';
export 'logger.dart';
export 'sp_util.dart';
export 'data_sp.dart';
export 'dialog.dart';
export 'image_util.dart';
export 'progress_util.dart';
export 'constants.dart';
export 'views.dart';

Future<String> getTempFileWithBytes({
  required String dir,
  required String name,
  required Uint8List bytes,
}) async {
  try {
    final docDir = await getApplicationDocumentsDirectory();
    final dirPath = "${docDir.path}/$dir";

    // 确保目录存在
    await Directory(dirPath).create(recursive: true);

    final path = "$dirPath/$name";
    final file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  } catch (e) {
    print("xiaojianjian 保存临时文件失败: $e");
    throw e;
  }
}
