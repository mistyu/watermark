
// import 'dart:io';
// import 'dart:math' as math;
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:watermark_camera/bloc/cubit/resource_builder.dart';
// import 'package:watermark_camera/bloc/cubit/watermark_builder.dart';
// import 'package:watermark_camera/models/resource/resource.dart';
// import 'package:watermark_camera/models/watermark/watermark.dart';
// import 'package:watermark_camera/utils/watermark.dart';
// import 'package:watermark_camera/widgets/ui/watermark_content.dart';
// import 'package:watermark_camera/widgets/watermark_bottom_sheet.dart';
// import 'package:widgets_to_image/widgets_to_image.dart';

// class Watermark extends StatefulWidget {
//   final WidgetsToImageController watermarkController;
//   const Watermark({super.key, required this.watermarkController});

//   @override
//   State<Watermark> createState() => _WatermarkState();
// }

// class _WatermarkState extends State<Watermark> {
//   final _offset = ValueNotifier(Offset.zero);
//   late double minX, maxX, minY, maxY;
//   final GlobalKey globalKey = GlobalKey();
//   final GlobalKey containerKey = GlobalKey();

//   void _onDragUpdate(DragUpdateDetails details, WatermarkFrame? boxFrame) {
//     final screenSize = MediaQuery.of(context).size;
//     // final containerSize = Size(100, 100); // 假设拖动容器的大小

//     // 计算拖动范围
//     maxX = screenSize.width - (boxFrame?.width ?? 1.sw);
//     minX = 0.0;
//     maxY = 0;
//     minY = -(globalKey.currentContext?.size?.height ?? 320) +
//         (containerKey.currentContext?.size?.height ?? 0);
//     // 更新偏移量并限制在范围内
//     Offset newOffset =
//         _offset.value.translate(details.delta.dx, details.delta.dy);
//     Offset clampedOffset = Offset(math.max(minX, math.min(newOffset.dx, maxX)),
//         math.max(minY, math.min(newOffset.dy, maxY)));
//     _offset.value = clampedOffset;
//   }

//   void _showBottomSheet(BuildContext context, WatermarkView view,
//       int templateId, Template? template) {
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       // backgroundColor: Colors.black12.withOpacity(0.05),
//       // barrierColor: Colors.black12,
//       // barrierColor: Colors.red,
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       context: context,
//       isScrollControlled: true,
//       constraints: BoxConstraints(maxHeight: 1.sh, maxWidth: 1.sw),
//       builder: (context) {
//         return WatermarkBottomSheet(
//             watermarkView: view, id: templateId, template: template);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WatermarkResourceBuilder(builder: (context, state) {
//       return WatermarkViewBuilder(builder: (context, viewState) {
//         final template = state.templates
//             .firstWhereOrNull((e) => e.id == viewState.watermarkId);

//         if (template != null) {
//           final watermarkView = viewState.watermarkView;
//           if (watermarkView != null) {
//             final boxFrame = watermarkView.frame;
//             final bodyData = watermarkView.data;

//             WatermarkData? liveShootwatermarkData = bodyData?.firstWhereOrNull(
//                 (item) =>
//                     item.type == 'RYWatermarkLiveShooting' &&
//                     item.isHidden == false);
//             WatermarkStyle? liveStyle = liveShootwatermarkData?.style;
//             return WidgetsToImage(
//               controller: widget.watermarkController,
//               child: Stack(
//                 key: globalKey,
//                 fit: StackFit.expand,
//                 children: [
//                   ValueListenableBuilder(
//                     valueListenable: _offset,
//                     builder: (context, value, child) => Positioned(
//                         bottom: value.dy == 0
//                             ? boxFrame?.bottom?.toDouble()
//                             : -value.dy,
//                         left: value.dx == 0
//                             ? boxFrame?.left?.toDouble()
//                             : value.dx,
//                         child: child!),
//                     child: GestureDetector(
//                       onTap: () {
//                         _showBottomSheet(
//                             context, watermarkView, template.id ?? 0, template);
//                       },
//                       //拖动手势
//                       onPanUpdate: (details) =>
//                           _onDragUpdate(details, boxFrame),
//                       child: FutureBuilder(
//                           future: Future.delayed(Durations.short1),
//                           builder: (context, snap) {
//                             if (snap.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             }
//                             return WatermarkContent(
//                               watermarkView: watermarkView,
//                               template: template,
//                             );
//                           }),
//                     ),
//                   ),
//                   //现场拍照背景水印
//                   Positioned(
//                       child: FutureBuilder(
//                           future: readImage(template.id.toString(),
//                               liveShootwatermarkData?.image),
//                           builder: (context, snapshot) {
//                             if (snapshot.data != null) {
//                               return Align(
//                                 alignment: Alignment.center,
//                                 child: Image.file(File(snapshot.data!),
//                                     width:
//                                         liveStyle?.iconWidth?.toDouble() ?? 0,
//                                     fit: BoxFit.cover),
//                               );
//                             }
//                             return const SizedBox.shrink();
//                           })),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }

//         return const SizedBox.shrink();
//       });
//     });
//   }
// }
