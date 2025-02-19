import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/bloc/cubit/right_bottom_builder.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'dart:ui' as ui;

import 'package:watermark_camera/widgets/watermark/WatermarkFont.dart';

// RightBottomView的type属性：
// 0.相机两字在第二行 1.文字在一行有图片 2.文字弯曲无图片 3.水印相机四字在第二行 4.文字在一行无图片

class RightBottomContent extends StatefulWidget {
  final RightBottomView? rightBottomView;
  const RightBottomContent({
    super.key,
    this.rightBottomView,
  });
  @override
  State<RightBottomContent> createState() => _RightBottomContentState();
}

class _RightBottomContentState extends State<RightBottomContent> {
  RightBottomView? _rightBottomView;
  RightBottomView? _newrightBottomView;
  String? name = '';
  String? camera = '';

  @override
  void initState() {
    _rightBottomView = widget.rightBottomView;
    _newrightBottomView = widget.rightBottomView?.copyWith();

    super.initState();
  }

  List<Shadow> viewShadows = [
    const Shadow(
      offset: Offset(0.5, 0.5), // 阴影的偏移量
      blurRadius: 0.5, // 阴影的模糊半径
      color: Colors.black26, // 阴影的颜色
    )
  ];

  @override
  Widget build(BuildContext context) {
    return RightBottomViewBuilder(builder: (context, snap) {
      _newrightBottomView = snap.rightBottomView;
      final viewAlpha = _newrightBottomView?.viewAlpha;
      final style = _newrightBottomView?.style;
      final layout = style?.layout;
      final textColor = style?.textColor;

      final content = _newrightBottomView?.content;
      if (_newrightBottomView?.type == 0 || _newrightBottomView?.type == null) {
        name = content?.substring(0, content.length - 2);
        camera = content?.substring(content.length - 2, content.length);
      } else if (_newrightBottomView?.type == 4 ||
          _newrightBottomView?.type == 1) {
        name = content;
        camera = '';
      } else if (_newrightBottomView?.type == 3) {
        name = content?.substring(0, content.length - 4);
        camera = content?.substring(content.length - 4, content.length);
      }
      // name = content?.substring(0, content.length - 2);
      final font = style?.fonts?['font'];
      final font2 = style?.fonts?['font2'];

      Alignment imageAlignment = Alignment.center;
      Alignment contentAlignment = Alignment.center;
      // TextAlign textAlignment = TextAlign.start;
      CrossAxisAlignment textAlignment = CrossAxisAlignment.start;
      if (layout?.imageTitleLayout == "centerRight") {
        imageAlignment = Alignment.centerRight;
        textAlignment = CrossAxisAlignment.start;
        // TextAlign.start;
      }
      contentAlignment = Alignment.centerLeft;
      if (layout?.imageTitleLayout == "centerLeft") {
        imageAlignment = Alignment.centerLeft;
        textAlignment = CrossAxisAlignment.end;
        // TextAlign.right;
      }
      contentAlignment = Alignment.centerRight;
      if (layout?.imageTitleLayout == "center") {
        imageAlignment = Alignment.center;
        textAlignment = CrossAxisAlignment.center;
        // TextAlign.center;
        contentAlignment = _newrightBottomView?.id == 26986609253333
            ? Alignment.bottomCenter
            : Alignment.center;
      }

      if (layout?.imageTitleLayout == "bottomCenter") {
        imageAlignment = Alignment.bottomCenter;
        textAlignment = CrossAxisAlignment.center;
        // TextAlign.center;
        contentAlignment = Alignment.center;
      }

      Widget contentWidget() {
        // final content = _newrightBottomView?.content;
        // // final content = "修改牛水印相机";
        // // String? content = null;
        // final camera = content?.substring(content.length - 2, content.length);
        // final name = content?.substring(0, content.length - 2);
        // final style = _newrightBottomView?.style;
        // final font = style?.fonts?['font'];
        // final font2 = style?.fonts?['font2'];
        // final textColor = style?.textColor;

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
              name ?? '',
              style: TextStyle(
                  shadows:
                      // viewShadows,
                      style?.viewShadow == true ? viewShadows : null,
                  height: 1,
                  // _newrightBottomView?.id == 26986609252260 ||
                  //         _newrightBottomView?.type == 3
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
                      textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble())),
            ),
            camera != null && camera != ''
                ? Text(
                    camera ?? '',
                    style: TextStyle(
                        shadows:
                            // viewShadows,
                            style?.viewShadow == true ? viewShadows : null,
                        height: _newrightBottomView?.id == 26986609252260 ||
                                _newrightBottomView?.id == 26986609252255
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

      Widget imageWidget() {
        // final style = rightbottom?.style;
        // final layout = style?.layout;
        // final content = rightbottom?.content;
        // final name = content?.substring(0, content.length - 2);

        // final font = style?.fonts?['font'];

        return _newrightBottomView?.image != '' &&
                _newrightBottomView?.image != null
            ? Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top:
                        // 10,
                        layout?.imageTopSpace?.abs() ?? 0),
                child: Image.network(
                    "${Config.staticUrl}/profile/upload/2024/10/17/${_newrightBottomView?.image ?? ''}.png",
                    width:
                        // layout?.imageTitleLayout == "center" ||
                        //         layout?.imageTitleLayout == "bottomCenter"
                        //     ? getTextSize(textSpan(name, font)).width
                        //     :
                        // 48,
                        (style?.iconWidth?.toDouble() ?? 0).w,
                    fit: BoxFit.cover),
              )
            : const SizedBox.shrink();
      }

      return Container(
        decoration: _newrightBottomView?.id == 26986609252220
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white.withOpacity(0.3))
            : null,
        width:
            // 72,
            _newrightBottomView?.frame?.width,
        child: _newrightBottomView?.type == 2 ||
                _newrightBottomView?.id == 26986609252266 ||
                _newrightBottomView?.id == 26986609252210
            ? ArcText(
                radius: 50.r,
                text: '修改牛水印相机',
                textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff848686),
                    fontWeight: FontWeight.bold),
                startAngle: -pi / 5,
                // pi / 6,
                // startAngleAlignment: StartAngleAlignment.end,
                stretchAngle: 1.2,
                painterDelegate: (canvas, size, painter) {
                  painter.paint(canvas, size, offset: Offset(25, 50));
                })
            : Stack(
                alignment: _newrightBottomView?.type == 1
                    ? _newrightBottomView?.id == 26986609253333
                        ? AlignmentDirectional.bottomCenter
                        : AlignmentDirectional.centerEnd
                    : AlignmentDirectional.center,
                children: [
                  contentWidget(),
                  Align(
                    alignment:
                        // Alignment.centerRight,
                        imageAlignment,
                    child: imageWidget(),
                  ),

                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(3.r),
                  //   child: ShaderMask(
                  //       blendMode: BlendMode.srcOut,
                  //       shaderCallback: (Rect bounds) {
                  //         return
                  //             // ImageShader(snap.data!, TileMode.clamp,
                  //             //     TileMode.clamp, Matrix4.identity().storage);
                  //             // Image.network(
                  //             //     "${Config.staticUrl}/profile/upload/2024/10/17/wm_70260_20241017134530A004.png",
                  //             //     width: style?.iconWidth?.toDouble() ?? 180.w,
                  //             //     fit: BoxFit.cover),
                  //             const LinearGradient(
                  //           colors: [Colors.white],
                  //           stops: [0.0],
                  //         ).createShader(bounds);
                  //       },
                  //       child: contentWidget()
                  //       // Text(
                  //       //   '修改牛水印相机',
                  //       //   style: TextStyle(
                  //       //     // color: Colors.black,
                  //       //     fontWeight: FontWeight.w900,
                  //       //     fontSize: 9,
                  //       //     // height: 2
                  //       //   ),
                  //       // ),
                  //       ),
                  // )
                ],
              ),
      );
    });
    // Placeholder(
    //   fallbackWidth: widget.rightBottomView?.frame?.width ?? 80.w,
    //   fallbackHeight: 30.w,
    // );
  }
}
