import 'package:get/get.dart';
import 'package:watermark_camera/pages/mine/mine_logic.dart';

class InfoMeLogic extends GetxController {
  final MineLogic mineLogic = Get.find<MineLogic>();

  String? get avatar => mineLogic.avatar;
  String get nickName => mineLogic.nickName;
  bool get isMember => mineLogic.isMember;
  DateTime? get memberExpireTime => mineLogic.memberExpireTime;

  void changeAvatar() {
    mineLogic.selectImageAndUpload();
  }

  void changeName() {
    mineLogic.startChangeNameView();
  }

  void logout() async {
    try {
      final result = await mineLogic.logout();
      if (result) {
        Get.back(); // 退出当前页面
      }
    } catch (e) {
      print("退出登录异常: $e");
    }
  }
}
