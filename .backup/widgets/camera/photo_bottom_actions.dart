import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_builder.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import '../../camera/buttons/camera_mode_selector.dart';
import '../../camera/media_preview.dart';
import 'package:watermark_camera/config/router.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import '../../edit_pic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/path_utils.dart';
import '../watermark_bottom_sheet.dart';
import '../watermark_sheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import '../../camera/buttons/capture_button.dart' as button;

class PhotoBottomActions extends StatefulWidget {
  final WidgetsToImageController watermarkController;
  const PhotoBottomActions(
      {super.key, required this.state, required this.watermarkController});

  final PhotoCameraState state;

  @override
  State<PhotoBottomActions> createState() => _PhotoBottomActionsState();
}

class _PhotoBottomActionsState extends State<PhotoBottomActions> {
  void _saveImage(Uint8List image) async {
    await ImageGallerySaver.saveImage(image);
  }

  void _showBottomSheet(BuildContext context,
      {WatermarkView? view, int? templateId, Template? template}) {
    view != null && templateId != null
        ? showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(maxHeight: 1.sh, maxWidth: 1.sw),
            builder: (context) {
              return WatermarkBottomSheet(
                  watermarkView: view, id: templateId, template: template);
            },
          )
        : showBottomSheet(
            context: context,
            builder: (context) {
              return const WatermarkSheet();
            });
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
          _saveImage(watermarkBytes);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // int watermarkId = context.read<WatermarkCubit>().watermarkId;
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final photoTheme = AwesomeThemeProvider.of(context).theme;
    return WatermarkViewBuilder(builder: (context, state) {
      int? watermarkId = state.watermarkId;
      WatermarkView? watermarkView = state.watermarkView;
      Template? template = context
          .read<ResourceCubit>()
          .templates
          .firstWhereOrNull((e) => e.id == watermarkId);
      return Container(
        padding:
            EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight, top: 10.w),
        color: photoTheme.bottomActionsBackgroundColor,
        child: Column(
          children: [
            GestureDetector(
              child: Image.asset(
                'main_water'.png,
                height: 32.w,
                fit: BoxFit.contain,
              ),
              onTap: () {},
            ),
            AwesomeBottomActions(
              state: widget.state,
              left: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AwesomeBouncingWidget(
                    onTap: () async {
                      final List<AssetEntity>? result =
                          await AssetPicker.pickAssets(context);
                      // AppRouter.router?.goNamed(AppRouter.editPicPath);
                      if (result != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPic(
                                      result: result,
                                      watermarkVisible: true,
                                    )));
                      }
                    },
                    child: StreamBuilder<MediaCapture?>(
                      stream: widget.state.captureState$,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Column(
                            children: [
                              Image(
                                image: AssetImage('home_ico_photo'.png),
                                width: 30.w,
                              ),
                              Text(
                                '相册',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ],
                          );
                        }

                        return SizedBox(
                          width: 30.w,
                          child: Column(
                            children: [
                              MediaPreview(
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
                              Text(
                                '相册',
                                style: TextStyle(fontSize: 13.sp),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  AwesomeBouncingWidget(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('home_ico_water'.png),
                            width: 30.w,
                          ),
                          Text(
                            '水印',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      ))
                ],
              ),
              captureButton: button.CaptureButton(
                state: widget.state,
                onPhoto: _drawWatermark,
              ),
              right: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //修改
                  AwesomeBouncingWidget(
                      onTap: () {
                        _showBottomSheet(context,
                            view: watermarkView,
                            templateId: watermarkId,
                            template: template);
                      },
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('home_ico_edit'.png),
                            width: 30.w,
                          ),
                          Text(
                            '修改',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      )),
                  // 定位
                  AwesomeLocationButton(
                    state: widget.state,
                    iconBuilder: (saveGpsLocation) {
                      return Column(
                        children: [
                          Image(
                            image: AssetImage('home_ico_location'.png),
                            width: 30.w,
                          ),
                          Text(
                            '定位',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            CameraModeSelector(state: widget.state),
          ],
        ),
      );
    });
  }
}
