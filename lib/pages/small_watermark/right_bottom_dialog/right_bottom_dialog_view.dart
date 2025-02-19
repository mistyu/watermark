import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_dialog/right_bottom_dialog_logic.dart';
import 'package:watermark_camera/utils/library.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/right_bottom_preview.dart';

class RightBottomDialogView extends StatelessWidget {
  RightBottomView rightBottomView;
  Widget? rightBottomWidget;

  RightBottomDialogView(
      {super.key, required this.rightBottomView, this.rightBottomWidget});

  OutlineInputBorder get _outlineInputBorder => OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
      borderSide: const BorderSide(color: Color(0xFFe2e2e2)));

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(RightBottomDialogLogic());
    if (rightBottomView.content != '' && rightBottomView.content != null) {
      // logic.dialogController.text = rightBottomView.content ?? '';
      return Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 0.5.sh),
          // margin:
          //     EdgeInsets.symmetric(horizontal: 0.08.sw, vertical: 0.15.sh),
          margin: EdgeInsets.symmetric(horizontal: 0.08.sw),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage('save_blue_img'.webp),
                  alignment: Alignment.topCenter)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: LayoutBuilder(builder: (context, constrain) {
              return Obx(() {
                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                        child: Text(
                          "右下角水印",
                          style: Theme.of(context).textTheme.headlineMedium,
                        )),
                    Stack(
                      children: [
                        Image.asset(
                          'edit_preview'.png,
                        ),

                        // 原始数据
                        Positioned(
                            bottom: 4,
                            right: (constrain.maxWidth) / 2 + 4,
                            child: RightBottomPreview(
                              rightBottomView: logic.rightBottomView.value,
                              camera: logic.camera1.value,
                              name: logic.name1.value,
                            )),

                        logic.rightBottomCopy.value != null
                            ? Positioned(
                                right: 4,
                                bottom: 4,
                                child: RightBottomPreview(
                                  rightBottomView: logic.rightBottomCopy.value!,
                                  name: logic.name.value,
                                  camera: logic.camera.value,
                                ))
                            : const SizedBox.shrink(),
                      ],
                    ),
                    16.verticalSpace,
                    TextField(
                      maxLength: rightBottomView.content?.length,
                      // 输入长度，右下角会显示 /20
                      maxLines: 1,
                      autofocus: true,
                      controller: logic.dialogController,
                      // 用于获取输入内容
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      enabled: true,
                      cursorColor: const Color(0xff008577),
                      // style: TextStyle(
                      //     color: Colors.grey, fontSize: 16.sp),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0.w),
                        // counterText: '', //去掉右下角计数文本
                        isCollapsed: true,
                        //是否收缩（改变边框大小）
                        focusedBorder: _outlineInputBorder,
                        border: _outlineInputBorder,
                        enabledBorder: _outlineInputBorder,
                        disabledBorder: _outlineInputBorder,
                        focusedErrorBorder: _outlineInputBorder,
                        errorBorder: _outlineInputBorder,
                        hintText: "请输入水印文案",
                        hintStyle: TextStyle(
                            fontSize: 16.sp, color: const Color(0xffadadad)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: logic.dialogPreviewRightBottomView,
                          child: Container(
                            width: 0.3.sw,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                                border: Border.all(color: Styles.c_0C8CE9),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              textAlign: TextAlign.center,
                              "预览",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Styles.c_0C8CE9),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: logic.saveEditRightBottom,
                          child: Container(
                            width: 0.3.sw,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xff76a6ff),
                                  Color(0xff146dfe)
                                ]),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              textAlign: TextAlign.center,
                              "确认修改",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        // GradientButton(
                        //   width: 0.3.sw,
                        //   borderRadius: BorderRadius.circular(50),
                        //   colors: const [Color(0xff76a6ff), Color(0xff146dfe)],
                        //   child: Text(
                        //     "确认修改",
                        //     style: TextStyle(fontSize: 16.sp,color: Colors.white),
                        //   ),
                        //   tapCallback: logic.saveEditRightBottom,
                        // ),
                      ],
                    )
                  ],
                );
              });
            }),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
