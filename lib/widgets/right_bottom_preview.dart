import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

// RightBottomView的type属性：
// 0.相机两字在第二行 1.文字在一行有图片 2.文字弯曲无图片 3.水印相机四字在第二行 4.文字在一行无图片

class RightBottomPreview extends StatelessWidget {
  final RightBottomView? rightBottomView;
  final String? name;
  final String? camera;

  RightBottomPreview(
      {super.key, required this.rightBottomView, this.name, this.camera});

  final SmallWatermarkLogic logic = Get.find<SmallWatermarkLogic>();

  InlineSpan textSpan(String? text, WatermarkFont? font) {
    return TextSpan(
        text: text ?? '',
        style: TextStyle(
          fontSize: font?.size,
          // 13.sp,
        ));
  }

  Size getTextSize(InlineSpan? textSpan, BuildContext context) {
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: textSpan,
      maxLines: 1,
      locale: Localizations.localeOf(context),
    );
    painter.layout();
    return painter.size;
  }

  final List<Shadow> viewShadows = [
    const Shadow(
      offset: Offset(0.5, 0.5), // 阴影的偏移量
      blurRadius: 0.5, // 阴影的模糊半径
      color: Colors.black26, // 阴影的颜色
    )
  ];

  Widget _buildChild(RightBottomView? rightBottomView, BuildContext context) {
    final style = rightBottomView?.style;
    final layout = style?.layout;

    // name = content?.substring(0, content.length - 2);

    Alignment imageAlignment = Alignment.center;

    if (layout?.imageTitleLayout == "centerRight") {
      imageAlignment = Alignment.centerRight;
    }

    if (layout?.imageTitleLayout == "centerLeft") {
      imageAlignment = Alignment.centerLeft;
    }

    if (layout?.imageTitleLayout == "center") {
      imageAlignment = Alignment.center;
    }

    if (layout?.imageTitleLayout == "bottomCenter") {
      imageAlignment = Alignment.bottomCenter;
    }
    return Container(
      decoration: rightBottomView?.id == 26986609252220
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white.withOpacity(0.3))
          : null,
      width:
          // 60,
          rightBottomView?.frame?.width,
      child: rightBottomView?.id == 26986609252233
          ? ClipRRect(
              borderRadius: BorderRadius.circular(1.r),
              child: ShaderMask(
                  blendMode: BlendMode.srcOut,
                  shaderCallback: (Rect bounds) {
                    return
                        // ImageShader(snap.data!, TileMode.clamp,
                        //     TileMode.clamp, Matrix4.identity().storage);
                        // Image.network(
                        //     "${Config.staticUrl}/profile/upload/2024/10/17/wm_70260_20241017134530A004.png",
                        //     width: style?.iconWidth?.toDouble() ?? 180.w,
                        //     fit: BoxFit.cover),
                        const LinearGradient(
                      colors: [Colors.white],
                      stops: [0.0],
                    ).createShader(bounds);
                  },
                  child: contentWidget(rightBottomView)
                  // Text(
                  //   '修改牛水印相机',
                  //   style: TextStyle(
                  //     // color: Colors.black,
                  //     fontWeight: FontWeight.w900,
                  //     fontSize: 9,
                  //     // height: 2
                  //   ),
                  // ),
                  ),
            )
          : rightBottomView?.type == 2 ||
                  rightBottomView?.id == 26986609252266 ||
                  rightBottomView?.id == 26986609252210
              ? ArcText(
                  radius: 50,
                  text: '修改牛水印相机',
                  textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff848686),
                      fontWeight: FontWeight.bold),
                  startAngleAlignment: StartAngleAlignment.center,
                  stretchAngle: 110 * pi / 180,
                  placement: Placement.middle,
                  painterDelegate: (canvas, size, painter) {
                    painter.paint(canvas, size, offset: const Offset(25, 25));
                  })
              : Stack(
                  alignment: rightBottomView?.type == 1
                      ? rightBottomView?.id == 26986609253333
                          ? AlignmentDirectional.bottomCenter
                          : AlignmentDirectional.centerEnd
                      : AlignmentDirectional.center,
                  children: [
                    contentWidget(rightBottomView),
                    Align(
                      alignment:
                          // Alignment.centerRight,
                          imageAlignment,
                      child: imageWidget(rightBottomView),
                    ),
                  ],
                ),
    );
  }

  Widget contentWidget(RightBottomView? rightBottomView) {
    final content = rightBottomView?.content;
    final style = rightBottomView?.style;
    final layout = style?.layout;
    final font = style?.fonts?['font'];
    final font2 = style?.fonts?['font2'];
    final textColor = style?.textColor;

    CrossAxisAlignment textAlignment = CrossAxisAlignment.start;
    if (layout?.imageTitleLayout == "centerRight") {
      textAlignment = CrossAxisAlignment.start;
      // TextAlign.start;
    }

    if (layout?.imageTitleLayout == "centerLeft") {
      textAlignment = CrossAxisAlignment.end;
      // TextAlign.right;
    }

    if (layout?.imageTitleLayout == "center") {
      textAlignment = CrossAxisAlignment.center;
    }

    if (layout?.imageTitleLayout == "bottomCenter") {
      textAlignment = CrossAxisAlignment.center;
    }
    if (content == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: textAlignment,
      children: [
        // WatermarkFontBox(
        //   text: name ?? '',
        //   textStyle: style,
        // ),
        // camera != null && camera != ''
        //     ? WatermarkFontBox(
        //         text: camera ?? '',
        //         textStyle: style,
        //       )
        //     : const SizedBox.shrink(),
        Text(
          textAlign: TextAlign.center,
          name ?? logic.name.value ?? '',
          style: TextStyle(
              shadows:
                  // viewShadows,
                  style?.viewShadow == true ? viewShadows : null,
              height: 1,
              // rightBottomView?.id == 26986609252260 ||
              //         rightBottomView?.type == 3
              //     ? 1
              //     : null,
              fontSize:
                  // 10.sp,
                  font?.size,
              fontFamily:
                  // "HarmonyOS_Sans",
                  // "Wechat_regular",
                  font?.name,
              color:
                  // Colors.white
                  textColor?.color?.hexToColor(textColor.alpha?.toDouble())),
        ),
        logic.camera.value != null && logic.camera.value != ''
            ? Text(
                camera ?? logic.camera.value ?? '',
                style: TextStyle(
                    shadows:
                        // viewShadows,
                        style?.viewShadow == true ? viewShadows : null,
                    height: rightBottomView?.id == 26986609252260 ||
                            rightBottomView?.id == 26986609252255
                        ? 1
                        : null,
                    fontSize:
                        // 11.sp,
                        font2?.size,
                    fontFamily:
                        // "HYQiHeiX2",
                        font2?.name,
                    color:
                        // Colors.white
                        textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble())),
              )
            : const SizedBox.shrink(),
        // Text.rich(
        //   textAlign: textAlignment,
        //   TextSpan(
        //       children: [textSpan(name, font), textSpan(camera, font2)]),
        //   style: TextStyle(
        //       fontFamily: font?.name,
        //       color:
        //           // Colors.white
        //           textColor?.color
        //               ?.hexToColor(textColor.alpha?.toDouble())),
        // ),
      ],
    );
  }

  Widget imageWidget(RightBottomView? rightBottomView) {
    final style = rightBottomView?.style;
    final layout = style?.layout;

    return rightBottomView?.image != '' && rightBottomView?.image != null
        ? Container(
            padding: EdgeInsets.only(
                right: layout?.imageTitleSpace ?? 0,
                top:
                    // 10,
                    layout?.imageTopSpace?.abs() ?? 0),
            child: Image.network(
                "${Config.staticUrl}/profile/upload/2024/10/17/${rightBottomView?.image ?? ''}.png",
                width:
                    // layout?.imageTitleLayout == "center" ||
                    //         layout?.imageTitleLayout == "bottomCenter"
                    //     ? getTextSize(textSpan(name, font)).width
                    //     :
                    // 48,
                    (style?.iconWidth?.toDouble() ?? 0),
                fit: BoxFit.cover),
          )
        : const SizedBox.shrink();
  }

  Widget firstTypeAntifake() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          "right_jr_fw_img".png,
          width: 15.w,
          fit: BoxFit.fitWidth,
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("iv_bg_sec".png), fit: BoxFit.fill)),
          child: Text(
            logic.antifakeText.value,
            style: const TextStyle(
                fontFamily: "PT Mono Bold",
                // 第一种"PT Mono Bold",
                // 第二种"Sanchez-Regular",
                fontSize: 10,
                color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget secondTypeAntifake() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          "right_mk_fw_img".png,
          width: 15.w,
          fit: BoxFit.fitWidth,
        ),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("iv_bg_sec".png), fit: BoxFit.fill)),
          child: Text(
            logic.antifakeText.value,
            style: const TextStyle(
                fontFamily: "Sanchez-Regular",
                fontSize: 10,
                color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //水印大小
          Transform.scale(
              alignment: Alignment.bottomRight,
              scale: logic.mainScale.value,
              child: _buildChild(rightBottomView, context)),
          // 署名
          Visibility(
            visible: (logic.rightBottomView.value?.isSupportSign ?? false) &&
                (logic.rightBottomView.value?.isSign ?? false),
            child: Text(
              logic.signText.value,
              style: const TextStyle(
                  fontFamily: "HarmonyOS_Sans",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          //防伪码
          Visibility(
            visible: (logic.rightBottomView.value?.isSupportFack ?? false) &&
                (logic.rightBottomView.value?.isAntiFack ?? false),
            //防伪码大小
            child: Transform.scale(
              alignment: Alignment.bottomRight,
              scale: logic.antifakeScale.value,
              child: Container(
                  margin: EdgeInsets.only(
                      top: logic.antifakePosition.value.dy < 0
                          ? 0
                          : logic.antifakePosition.value.dy,
                      right: logic.antifakePosition.value.dx < 0
                          ? 0
                          : logic.antifakePosition.value.dx),
                  child: logic.rightBottomView.value?.antiFackType == 1
                      ? firstTypeAntifake()
                      : secondTypeAntifake()),
            ),
          )
        ],
      );
    });
  }
}
