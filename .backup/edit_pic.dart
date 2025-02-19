// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:dio/dio.dart' as dio;
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive/hive.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_editor/image_editor.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
// import 'package:watermark_camera/config/router.dart';
// import 'package:watermark_camera/main.dart';
// import 'package:watermark_camera/models/watermark/watermark.dart';
// import 'watermark.dart';
// import 'package:watermark_camera/utils/asset_utils.dart';
// import 'package:watermark_camera/utils/color_extension.dart';
// import 'package:watermark_camera/utils/http.dart';
// import 'package:watermark_camera/utils/path_utils.dart';
// import 'package:watermark_camera/widgets/watermark_sheet.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:widgets_to_image/widgets_to_image.dart';

// class EditPic extends StatefulWidget {
//   final List<AssetEntity>? result;
//   final bool? watermarkVisible;
//   const EditPic({super.key, this.result, this.watermarkVisible});

//   @override
//   State<EditPic> createState() => _EditPicState();
// }

// class _EditPicState extends State<EditPic> {
//   final WidgetsToImageController _controller = WidgetsToImageController();

//   // Future<ByteData?> _afterImg = Future(() {
//   //   return null;
//   // });

//   final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

//   void _showBottomSheet(BuildContext context) {
//     showBottomSheet(
//       context: context,
//       // backgroundColor: Colors.white,
//       builder: (context) {
//         return const WatermarkSheet();
//       },
//     );
//   }

//   void rotate(bool right) {
//     editorKey.currentState?.rotate(right: right);
//   }

//   void _saveImage(Uint8List image) async {
//     await ImageGallerySaver.saveImage(image);
//   }

//   void _drawWatermark(Uint8List? dstBytes) async {
//     if (await Permission.storage.request().isGranted) {
//       // final dstBytes = await afterImage;
//       final srcBytes = await _controller.capture();
//       if (dstBytes != null && srcBytes != null) {
//         img.Image? srcImage = img.decodeImage(srcBytes);
//         img.Image? dstImage = img.decodeImage(dstBytes);
//         if (srcImage != null && dstImage != null) {
//           img.Image watermarkImage = img.compositeImage(dstImage, srcImage,
//               dstX: 12, dstY: dstImage.height - srcImage.height - 12);
//           Uint8List watermarkBytes =
//               Uint8List.fromList(img.encodeJpg(watermarkImage));
//           _saveImage(watermarkBytes);
//         }
//       }
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("没有文件存储权限，请前往应用设置打开！")),
//         );
//       }
//     }
//   }

//   Future<Uint8List?> cropImageDataWithNativeLibrary(
//       {required ExtendedImageEditorState state}) async {
//     print('native library start cropping');
//     Rect cropRect = state.getCropRect()!;
//     if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
//       final ImmutableBuffer buffer =
//           await ImmutableBuffer.fromUint8List(state.rawImageData);
//       final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

//       final double widthRatio = descriptor.width / state.image!.width;
//       final double heightRatio = descriptor.height / state.image!.height;
//       cropRect = Rect.fromLTRB(
//         cropRect.left * widthRatio,
//         cropRect.top * heightRatio,
//         cropRect.right * widthRatio,
//         cropRect.bottom * heightRatio,
//       );
//     }

//     final EditActionDetails action = state.editAction!;

//     final int rotateAngle = action.rotateAngle.toInt();
//     final bool flipHorizontal = action.flipY;
//     final bool flipVertical = action.flipX;
//     final Uint8List img = state.rawImageData;

//     final ImageEditorOption option = ImageEditorOption();

//     if (action.needCrop) {
//       option.addOption(ClipOption.fromRect(cropRect));
//     }

//     if (action.needFlip) {
//       option.addOption(
//           FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
//     }

//     if (action.hasRotateAngle) {
//       option.addOption(RotateOption(rotateAngle));
//     }

//     final DateTime start = DateTime.now();
//     final Uint8List? result = await ImageEditor.editImage(
//       image: img,
//       imageEditorOption: option,
//     );

//     print('${DateTime.now().difference(start)} ：total time');
//     return result;
//   }

//   int _indexPic = 1;

//   final bottomList = [
//     {'image': 'ic_edit1', 'title': '水印', 'function': 0},
//     {'image': 'ic_edit2', 'title': '右下角', 'function': 1},
//     {'image': 'ic_edit3', 'title': '文字', 'function': 2},
//     {'image': 'ic_edit4', 'title': '旋转', 'function': 3},
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: Text("<"),
//         title: RichText(
//             text: TextSpan(
//                 style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
//                 children: [
//               const TextSpan(
//                 text: '图片编辑',
//               ),
//               TextSpan(
//                 text: widget.result!.length > 1
//                     ? '$_indexPic/${widget.result!.length}'
//                     : '',
//               )
//             ])),
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               final state = editorKey.currentState;
//               final Uint8List img = Uint8List.fromList(
//                   (await cropImageDataWithNativeLibrary(state: state!))!);
//               if (widget.watermarkVisible ?? false) {
//                 _drawWatermark(img);
//                 AppRouter.router?.goNamed(AppRouter.cameraPath);
//               } else {
//                 dio.FormData formData = dio.FormData.fromMap({
//                   'file': dio.MultipartFile.fromBytes(img,
//                       filename: '${DateTime.timestamp().toString()}.jpg')
//                 });

//                 final res = await Http.getInstance().post('/common/upload',
//                     formData: formData,
//                     options: dio.Options(
//                       contentType: 'multipart/form-data',
//                     ));
//                 AppRouter.router?.pop(res?.url);
//               }
//             },
//             child: widget.watermarkVisible ?? false
//                 ? Text(
//                     "保存",
//                   )
//                 : Image.asset(
//                     'ok'.png,
//                     width: 30.w,
//                     fit: BoxFit.fitWidth,
//                   ),
//           ),
//           SizedBox(
//             width: 10,
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 PageView(
//                   children: widget.result?.map(
//                         (e) {
//                           return FutureBuilder(
//                               future: e.file,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ExtendedImage.file(
//                                     snapshot.data ?? File(''),
//                                     extendedImageEditorKey: editorKey,
//                                     mode: ExtendedImageMode.editor,
//                                     fit: BoxFit.contain,
//                                     enableLoadState: true,
//                                     cacheRawData: true,
//                                     // afterPaintImage:
//                                     //     (canvas, rect, image, paint) {
//                                     //   setState(() {
//                                     //     _afterImg = image.toByteData();
//                                     //   });
//                                     // },
//                                     // initEditorConfigHandler: (_) =>
//                                     //     EditorConfig(
//                                     //   maxScale: 8.0,
//                                     //   // cropRectPadding:
//                                     //   //     const EdgeInsets.all(20.0),
//                                     //   hitTestSize: 20.0,
//                                     //   cropAspectRatio: 2 / 1,
//                                     // ),
//                                   );
//                                 }
//                                 return SizedBox.shrink();
//                               });
//                           // AssetEntityImage(e, isOriginal: true,);
//                         },
//                       ).toList() ??
//                       [const SizedBox.shrink()],
//                   onPageChanged: (value) {
//                     setState(() {
//                       _indexPic = value + 1;
//                     });
//                   },
//                 ),
//                 Visibility(
//                     visible: widget.watermarkVisible ?? false,
//                     child: Positioned(
//                         child: Watermark(watermarkController: _controller))),
//               ],
//             ),
//           ),
//           Visibility(
//             visible: widget.watermarkVisible ?? false,
//             child: Builder(builder: (context) {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: bottomList.map((item) {
//                   return GestureDetector(
//                     onTap: () {
//                       if (item['function'] == 0) {
//                         _showBottomSheet(context);
//                       } else if (item['function'] == 1) {
//                       } else if (item['function'] == 2) {
//                       } else if (item['function'] == 3) {
//                         rotate(true);
//                       }
//                     },
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           item['image'].toString().png,
//                           width: 10.w,
//                           fit: BoxFit.fitWidth,
//                         ),
//                         // Container(
//                         //   width: 50.w,
//                         //   height: 20.w,
//                         //   decoration: BoxDecoration(color: Colors.black),
//                         // ),
//                         Text(item['title'].toString())
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
