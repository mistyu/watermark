import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_antifake/right_bottom_antifake_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';

class RightBottomAntifakeView extends StatelessWidget {
  RightBottomAntifakeView({super.key});

  final logic = Get.find<RightBottomAntifakeLogic>();
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
              absorbing: !(logic
                      .rightBottomLogic.rightBottomView.value?.isSupportFack ??
                  false),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '随机生成照片防伪码',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: logic.antifakeSwitch.value == false
                            ? (logic.rightBottomLogic.rightBottomView.value
                                    ?.isAntiFack ??
                                false)
                            : logic.antifakeSwitch.value,
                        activeColor: "5b68ff".hex,
                        onChanged: logic.changeSwitch,
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: logic.rightBottomLogic.antifakeController,
                        cursorColor: const Color(0xff008577),
                        maxLength: 14,
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
                          hintText: "可输入（14位字符）",
                          hintStyle: TextStyle(fontSize: 14.sp),
                          constraints: BoxConstraints(maxWidth: 240.w),
                        ),
                      ),
                      GestureDetector(
                        onTap: logic.saveAntifake,
                        child: Image.asset(
                          "save_img".png,
                          width: 32.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: logic.resetAntifake,
                        child: Image.asset(
                          "reset_img".png,
                          width: 32.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 35.w,
                          child: Text(
                            '防伪位置',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {
                          logic.changePosition(
                              dx: logic.horizontalOffset.value,
                              dy: logic.verticalOffset.value,
                              status: 2);
                        },
                        child: Image.asset(
                          "edit_up_img".png,
                          width: 35.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          logic.changePosition(
                              dx: logic.horizontalOffset.value,
                              dy: logic.verticalOffset.value,
                              status: 1);
                        },
                        child: Image.asset(
                          "edit_down_img".png,
                          width: 35.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          logic.changePosition(
                              dx: logic.horizontalOffset.value,
                              dy: logic.verticalOffset.value,
                              status: 4);
                        },
                        child: Image.asset(
                          "edit_left_img".png,
                          width: 35.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          logic.changePosition(
                              dx: logic.horizontalOffset.value,
                              dy: logic.verticalOffset.value,
                              status: 3);
                        },
                        child: Image.asset(
                          "edit_right_img".png,
                          width: 35.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: logic.resetPosition,
                        child: Image.asset(
                          'reset_img'.png,
                          width: 32.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ),
            Visibility(
                visible: !(logic.rightBottomLogic.rightBottomView.value
                        ?.isSupportFack ??
                    false),
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
                      "当前水印不支持防伪",
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
