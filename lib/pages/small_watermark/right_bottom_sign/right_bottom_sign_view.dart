import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_sign/right_bottom_sign_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';

class RightBottomSignView extends StatelessWidget {
  RightBottomSignView({super.key});

  final logic = Get.find<RightBottomSignLogic>();
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
      borderSide: const BorderSide(color: Color(0xFFe2e2e2)));

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            AbsorbPointer(
              absorbing: !(logic.rightBottomLogic.rightBottomView.value?.isSupportSign ?? false),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '给你的视频照片署名',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: logic.signSwitch.value == false
                            ? (logic.rightBottomLogic.rightBottomView.value
                            ?.isSign ??
                            false)
                            : logic.signSwitch.value,
                        activeColor: "5b68ff".hex,
                        onChanged: logic.changeSignSwitch,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: logic.rightBottomLogic.signController,
                        cursorColor: const Color(0xff008577),
                        maxLength: 6,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(6.0.w),
                          counterText: '',
                          //去掉右下角计数文本
                          isCollapsed: true,
                          //是否收缩（改变边框大小）
                          focusedBorder: _outlineInputBorder,
                          border: _outlineInputBorder,
                          enabledBorder: _outlineInputBorder,
                          disabledBorder: _outlineInputBorder,
                          focusedErrorBorder: _outlineInputBorder,
                          errorBorder: _outlineInputBorder,
                          hintText: "可输入（6位字符）",
                          hintStyle: TextStyle(fontSize: 14.sp),
                          constraints: BoxConstraints(maxWidth: 260.w),
                        ),
                      ),
                      GestureDetector(
                        onTap: logic.saveSign,
                        child: Image.asset(
                          "save_img".png,
                          width: 32.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                ],
              ),
            ),
            Visibility(
                visible: !(logic.rightBottomLogic.rightBottomView.value?.isSupportSign ?? false),
                child: Row(
                  children: [
                    Image.asset(
                      "tsico".png,
                      width: 18.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "当前水印不支持署名",
                      style: TextStyle(fontSize: 14.sp, color: Colors.red),
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}
