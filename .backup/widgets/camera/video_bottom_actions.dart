import 'dart:io';

import 'package:flutter/services.dart';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../camera/buttons/camera_mode_selector.dart';
import '../../camera/media_preview.dart';
import '../../edit_pic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/path_utils.dart';
import '../watermark_sheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import '../../camera/buttons/capture_button.dart' as button;

class VideoBottomActions extends StatefulWidget {
  final WidgetsToImageController watermarkController;
  const VideoBottomActions(
      {super.key, required this.state, required this.watermarkController});

  final CameraState state;

  @override
  State<VideoBottomActions> createState() => _VideoBottomActionsState();
}

class _VideoBottomActionsState extends State<VideoBottomActions> {
  // void _saveImage(Uint8List image) async {
  //   await ImageGallerySaver.saveImage(image);
  // }

  void _showBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      // backgroundColor: Colors.white,
      builder: (context) {
        return const WatermarkSheet();
      },
    );
  }

  void _drawWatermark(CaptureRequest captureRequest) async {
    captureRequest.when(single: (single) async {
      final dstBytes = await single.file?.readAsBytes();
      final srcBytes = await widget.watermarkController.capture();
      if (dstBytes != null && srcBytes != null) {
        img.Image? srcImage = img.decodeImage(srcBytes);
        img.Image? dstImage = img.decodeImage(dstBytes);
        if (srcImage != null && dstImage != null) {
          img.Image watermarkImage = img.compositeImage(dstImage, srcImage,
              dstX: 12, dstY: dstImage.height - srcImage.height - 12);
          Uint8List watermarkBytes =
              Uint8List.fromList(img.encodeJpg(watermarkImage));
          // _saveImage(watermarkBytes);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoTheme = AwesomeThemeProvider.of(context).theme;
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight, top: 8.w),
      color: photoTheme.bottomActionsBackgroundColor,
      child: Column(
        children: [
          CameraModeSelector(state: widget.state),
          AwesomeBottomActions(
            state: widget.state,
            left: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    final List<AssetEntity>? result =
                        await AssetPicker.pickAssets(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPic(
                                  result: result,
                                  watermarkVisible: true,
                                )));
                  },
                  child: StreamBuilder<MediaCapture?>(
                    stream: widget.state.captureState$,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: Colors.white38,
                                width: 2,
                              ),
                            ));
                      }

                      return SizedBox(
                        width: 48,
                        child: MediaPreview(
                          mediaCapture: snapshot.requireData,
                          onMediaTap: (mediaCapture) {
                            mediaCapture.captureRequest.when(
                                single: (single) async {
                              final List<AssetEntity>? result =
                                  await AssetPicker.pickAssets(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPic(
                                            result: result,
                                            watermarkVisible: true,
                                          )));
                              // single.file?.open();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                // const Spacer(),
                AwesomeCircleWidget(
                  child: AwesomeBouncingWidget(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: SvgPicture.asset("yin".svg,
                        width: 20.w, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            captureButton: button.CaptureButton(
              state: widget.state,
              onPhoto: _drawWatermark,
            ),
            right: AwesomeCameraSwitchButton(
              state: widget.state,
              scale: 1,
            ),
          ),
        ],
      ),
    );
  }
}
