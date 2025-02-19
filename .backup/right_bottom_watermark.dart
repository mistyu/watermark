// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:watermark_camera/bloc/cubit/resource_builder.dart';
// import 'package:watermark_camera/bloc/cubit/resource_cubit.dart';
// import 'package:watermark_camera/bloc/cubit/right_bottom_builder.dart';
// import 'package:watermark_camera/bloc/cubit/right_bottom_cubit.dart';
// import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
// import 'package:watermark_camera/models/resource/resource.dart';
// import 'package:watermark_camera/models/watermark/watermark.dart';
// import 'watermark.dart';
// import 'package:watermark_camera/utils/asset_utils.dart';
// import 'package:watermark_camera/utils/color_extension.dart';
// import 'package:watermark_camera/utils/colours.dart';
// import 'package:watermark_camera/utils/extension.dart';
// import 'package:watermark_camera/utils/watermark.dart';
// import 'package:watermark_camera/widgets/right_bottom/right_bottom_content.dart';
// import 'package:watermark_camera/widgets/right_bottom/style_edit.dart';
// import 'package:watermark_camera/widgets/ui/assert_image_builder.dart';
// import 'package:watermark_camera/widgets/ui/image_slider_thumb.dart';
// import 'package:watermark_camera/widgets/ui/watermark_content.dart';
// import 'package:widgets_to_image/widgets_to_image.dart';

// class RightBottomWatermark extends StatefulWidget {
//   const RightBottomWatermark({super.key});

//   @override
//   State<RightBottomWatermark> createState() => _RightBottomWatermarkState();
// }

// class _RightBottomWatermarkState extends State<RightBottomWatermark>
//     with SingleTickerProviderStateMixin {
//   final WidgetsToImageController _controller = WidgetsToImageController();
//   late TabController _tabcontroller;
//   final tabList = ['水印', '大小', '防伪', '署名', '位置/透明度'];
//   WatermarkView? watermarkview;
//   Template? template;

//   RightBottomView? rightBottomView;
//   final GlobalKey _globalKey = GlobalKey();

//   final _rightbottomPosition = ValueNotifier(Offset(10.w, 10.w));

//   @override
//   void initState() {
//     int? id = context.read<WatermarkCubit>().watermarkId;
//     template = context
//         .read<ResourceCubit>()
//         .templates
//         .firstWhereOrNull((e) => e.id == id);
//     watermarkview = context.read<WatermarkCubit>().watermarkView;

//     rightBottomView = context.read<RightBottomCubit>().rightBottomView;

//     _tabcontroller = TabController(
//         initialIndex: 0, length: tabList.length, vsync: this); //让程序和手机刷新频率统一
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabcontroller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: Text("<"),
//         title: Text(
//           '右下角水印',
//           style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {},
//             child: const Text(
//               "保存",
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           )
//         ],
//       ),
//       body: CameraAwesomeBuilder.previewOnly(builder: (context, preview) {
//         var size =
//             _globalKey.currentContext?.findRenderObject()?.paintBounds.size;
//         final height = size?.height;
//         return Stack(
//           children: [
//             Watermark(watermarkController: _controller),
//             Positioned(
//               left: watermarkview?.frame?.left ?? 0.w,
//               bottom: (height ?? 0 + (watermarkview?.frame?.bottom ?? 0)).w,
//               child: WatermarkContent(
//                 watermarkView: watermarkview,
//                 template: template,
//               ),
//             ),
//             ValueListenableBuilder(
//               valueListenable: _rightbottomPosition,
//               builder: (context, value, child) {
//                 // final rightbottomView = view.rightBottomView;

//                 return Positioned(
//                   right: value.dx,
//                   bottom: ((height ?? 0) + value.dy).w,
//                   child: child ?? const SizedBox.shrink(),
//                 );
//               },
//               child: RightBottomContent(
//                 rightBottomView: rightBottomView,
//               ),
//             ),
//           ],
//         );
//       }),
//       bottomSheet: WatermarkResourceBuilder(builder: (context, state) {
//         final data = state.rightbottom;
//         return Container(
//           key: _globalKey,
//           height: 280.w,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadiusDirectional.vertical(
//                 top: Radius.circular(20.w),
//               )),
//           child: Column(
//             children: [
//               TabBar(
//                 controller: _tabcontroller,
//                 isScrollable: true,
//                 tabAlignment: TabAlignment.start,
//                 dividerColor: Colors.transparent,
//                 labelPadding: EdgeInsets.only(
//                     left: 20.w, right: 8.w, top: 10.w, bottom: 5.w),
//                 labelStyle: TextStyle(fontSize: 16.sp),
//                 unselectedLabelStyle: TextStyle(fontSize: 16.sp),
//                 indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
//                 unselectedLabelColor: Colours.kGrey700,
//                 tabs: tabList.map((item) {
//                   return Tab(
//                     height: 25.w,
//                     text: item,
//                     // style: Theme.of(context).textTheme.titleLarge,
//                   );
//                 }).toList(),
//               ),
//               if (state.rightbottom != null)
//                 Expanded(
//                   child: TabBarView(controller: _tabcontroller, children: [
//                     RightBottomGridView(),
//                     RightBottomSizeView(
//                       rightBottomView: rightBottomView,
//                       callbackRightBottomView: (value) {},
//                     ),
//                     RightBottomAntifakeView(),
//                     RightBottomSignView(
//                       rightBottomView: rightBottomView,
//                     ),
//                     RightBottomStyleView(
//                       rightBottomView: rightBottomView,
//                       callbackRightBottomView: (value) {},
//                       callbackRightBottomPosition: (v) {
//                         _rightbottomPosition.value = v;
//                       },
//                     ),
//                   ]),
//                 )
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class RightBottomGridView extends StatelessWidget {
//   final int? cid;
//   const RightBottomGridView({super.key, this.cid});

//   @override
//   Widget build(BuildContext context) {
//     return WatermarkResourceBuilder(builder: (context, state) {
//       final rightbottomList = state.rightbottom;
//       return RightBottomViewBuilder(builder: (context, snapshot) {
//         // final rightBottomView = snapshot.rightBottomView;
// //
//         // final coverFrame = rightBottomView?.coverFrame;
//         // final content = "修改牛水印相机";
//         // // String? content = null;
//         // // final content = rightBottomView?.content;
//         // final frame = rightBottomView?.frame;
//         // final viewAlpha = rightBottomView?.viewAlpha;
//         // final style = rightBottomView?.style;
//         // final font = style?.fonts?['font'];
//         // final textColor = style?.textColor;
//         // final layout = style?.layout;
// //
//         // Alignment coverAlignment = Alignment.center;
//         // if (coverFrame?.isCenterX == true && coverFrame?.isCenterY == true) {
//         //   coverAlignment = Alignment.center;
//         // }
//         // Alignment imageAlignment = Alignment.center;
//         // if (layout?.imageTitleLayout == "centerRight") {
//         //   imageAlignment = Alignment.centerRight;
//         // }
//         // if (layout?.imageTitleLayout == "centerLeft") {
//         //   imageAlignment = Alignment.centerLeft;
//         // }
//         // if (layout?.imageTitleLayout == "center") {
//         //   imageAlignment = Alignment.center;
//         // }
//         // if (layout?.imageTitleLayout == "bottomCenter") {
//         //   imageAlignment = Alignment.bottomCenter;
//         // }
//         // Widget contentWidget() {
//         //   final camera = content?.substring(content.length - 2, content.length);
//         //   final name = content?.substring(0, content.length - 2);
//         //   // print(name);
//         //   if (content == null) {
//         //     return const SizedBox.shrink();
//         //   }
// //
//         //   return Text.rich(
//         //     TextSpan(children: [
//         //       TextSpan(
//         //           text: name,
//         //           style: TextStyle(
//         //             fontSize:
//         //                 // style?.fonts?["font"]?.size,
//         //                 13.sp,
//         //           )),
//         //       TextSpan(
//         //           text: camera,
//         //           style: TextStyle(
//         //               fontSize:
//         //                   // style?.fonts?["font2"]?.size
//         //                   11.sp)),
//         //     ]),
//         //     style: TextStyle(fontFamily: font?.name, color: Colors.white
//         //         // textColor?.color?.hexToColor(textColor?.alpha?.toDouble()),
//         //         ),
//         //   );
//         // }

//         Widget coverWidget(RightBottom rightbottom) {
//           return rightbottom.cover != '' && rightbottom.cover != null
//               ? Image.network(
//                   "${Config.staticUrl}${rightbottom.cover ?? ''}",
//                   // width: style?.iconWidth?.toDouble() ?? 40.w,
//                   fit: BoxFit.contain)
//               : const SizedBox.shrink();
//         }

//         return Padding(
//           padding: const EdgeInsets.all(12).w,
//           child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 6.w,
//               crossAxisSpacing: 6.w,
//               crossAxisCount: 4, // 每行4列
//             ),
//             itemCount: state.rightbottom?.length, // 总共
//             itemBuilder: (context, index) {
//               if (rightbottomList != null && rightbottomList.isNotEmpty) {
//                 return Container(
//                   width: 80.w,
//                   height: 80.w,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage("bg_b".png), fit: BoxFit.fill)),
//                   padding: EdgeInsets.all(5.w),
//                   child: InkWell(
//                       onTap: () async {
//                         final rightBottomView = await getRightBottomViewData(
//                             context, rightbottomList[index].id ?? 0);
//                         context.read<RightBottomCubit>().loadedWatermarkView(
//                             rightbottomList[index].id ?? 0,
//                             rightBottomView: rightBottomView);
//                       },
//                       child: coverWidget(rightbottomList[index])
//                       // Stack(
//                       //   alignment: AlignmentDirectional.centerStart,
//                       //   children: [
//                       //     // contentWidget(),
//                       //     Align(
//                       //       alignment: Alignment.centerRight,
//                       //       // imageAlignment,
//                       //       child: coverWidget(rightbottomList[index]),
//                       //     )
//                       //   ],
//                       // ),
//                       ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         );
//       });
//     });
//   }
// }

// class RightBottomSignView extends StatefulWidget {
//   final RightBottomView? rightBottomView;
//   // final
//   const RightBottomSignView({super.key, required this.rightBottomView});
//   @override
//   State<RightBottomSignView> createState() => _RightBottomSignViewState();
// }

// class _RightBottomSignViewState extends State<RightBottomSignView> {
//   RightBottomView? _rightBottomView;
//   RightBottomView? _signView;
//   final _signSwitch = ValueNotifier(false);

//   final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
//       gapPadding: 0,
//       borderRadius: BorderRadius.all(Radius.circular(4.0.w)),
//       borderSide: BorderSide(color: Color(0xFFe2e2e2)));
//   @override
//   void initState() {
//     _rightBottomView = widget.rightBottomView?.copyWith();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(10.w),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '给你的视频照片署名',
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//               ),
//               ValueListenableBuilder(
//                   valueListenable: _signSwitch,
//                   builder: (context, value, child) {
//                     return Switch(
//                       value: value,
//                       activeColor: "5b68ff".hex,
//                       onChanged: (bool? value) {
//                         _signSwitch.value = value ?? false;
//                       },
//                     );
//                   }),
//             ],
//           ),
//           SizedBox(
//             height: 8.w,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextField(
//                 cursorColor: const Color(0xff008577),
//                 maxLength: 6,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(6.0.w),
//                   counterText: '', //去掉右下角计数文本
//                   isCollapsed: true, //是否收缩（改变边框大小）
//                   focusedBorder: _outlineInputBorder,
//                   border: _outlineInputBorder,
//                   enabledBorder: _outlineInputBorder,
//                   disabledBorder: _outlineInputBorder,
//                   focusedErrorBorder: _outlineInputBorder,
//                   errorBorder: _outlineInputBorder,
//                   hintText: "可输入（6位字符）",
//                   hintStyle: TextStyle(fontSize: 14.sp),
//                   constraints: BoxConstraints(maxWidth: 260.w),
//                 ),
//               ),
//               Image.asset(
//                 "save_img".png,
//                 width: 32.w,
//                 fit: BoxFit.contain,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 18.w,
//           ),
//           Visibility(
//               visible: true,
//               child: Row(
//                 children: [
//                   Image.asset(
//                     "tsico".png,
//                     width: 18.w,
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(
//                     width: 4.w,
//                   ),
//                   Text(
//                     "当前水印不支持署名",
//                     style: TextStyle(fontSize: 14.sp, color: Colors.red),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
// }

// class RightBottomAntifakeView extends StatefulWidget {
//   final RightBottomView? rightBottomView;
//   final ValueChanged<RightBottomView>? callbackAntifake;
//   const RightBottomAntifakeView({
//     super.key,
//     this.callbackAntifake,
//     this.rightBottomView,
//   });
//   @override
//   State<RightBottomAntifakeView> createState() =>
//       _RightBottomAntifakeViewState();
// }

// class _RightBottomAntifakeViewState extends State<RightBottomAntifakeView> {
//   RightBottomView? _rightBottomView;
//   RightBottomView? _antifake;
//   final _antifakeSwitch = ValueNotifier(false);

//   final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
//       gapPadding: 0,
//       borderRadius: BorderRadius.all(Radius.circular(4.0.w)),
//       borderSide: BorderSide(color: Color(0xFFe2e2e2)));
//   @override
//   void initState() {
//     _rightBottomView = widget.rightBottomView?.copyWith();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(10.w),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '随机生成照片防伪码',
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//               ),
//               ValueListenableBuilder(
//                   valueListenable: _antifakeSwitch,
//                   builder: (context, value, child) {
//                     return Switch(
//                       value: value,
//                       activeColor: "5b68ff".hex,
//                       onChanged: (bool? value) {
//                         _antifakeSwitch.value = value ?? false;
//                       },
//                     );
//                   }),
//             ],
//           ),
//           SizedBox(
//             height: 8.w,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextField(
//                 cursorColor: const Color(0xff008577),
//                 maxLength: 14,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(6.0.w),
//                   counterText: '', //去掉右下角计数文本
//                   isCollapsed: true, //是否收缩（改变边框大小）
//                   focusedBorder: _outlineInputBorder,
//                   border: _outlineInputBorder,
//                   enabledBorder: _outlineInputBorder,
//                   disabledBorder: _outlineInputBorder,
//                   focusedErrorBorder: _outlineInputBorder,
//                   errorBorder: _outlineInputBorder,
//                   hintText: "可输入（14位字符）",
//                   hintStyle: TextStyle(fontSize: 14.sp),
//                   constraints: BoxConstraints(maxWidth: 240.w),
//                 ),
//               ),
//               Image.asset(
//                 "save_img".png,
//                 width: 32.w,
//                 fit: BoxFit.contain,
//               ),
//               Image.asset(
//                 "reset_img".png,
//                 width: 32.w,
//                 fit: BoxFit.contain,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 16.w,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                   width: 35.w,
//                   child: Text(
//                     '防伪位置',
//                     style:
//                         TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//                   )),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "edit_up_img".png,
//                   width: 35.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "edit_down_img".png,
//                   width: 35.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "edit_left_img".png,
//                   width: 35.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "edit_right_img".png,
//                   width: 35.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // _verticalOffset.value = 10;
//                   // _horizontalOffset.value = 10;
//                   // try {
//                   //   widget.callbackRightBottomPosition!(Offset(
//                   //       _horizontalOffset.value.toDouble(),
//                   //       _verticalOffset.value.toDouble()));
//                   // } catch (e) {
//                   //   showErrorDialog(context, e.toString());
//                   // }
//                 },
//                 child: Image.asset(
//                   'reset_img'.png,
//                   width: 32.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 8.w,
//           ),
//           Visibility(
//               visible: true,
//               child: Row(
//                 children: [
//                   Image.asset(
//                     "tsico".png,
//                     width: 18.w,
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(
//                     width: 4.w,
//                   ),
//                   Text(
//                     "当前水印不支持防伪",
//                     style: TextStyle(fontSize: 14.sp, color: Colors.red),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
// }

// class RightBottomSizeView extends StatefulWidget {
//   final RightBottomView? rightBottomView;
//   final ValueChanged<RightBottomView>? callbackRightBottomView;
//   const RightBottomSizeView({
//     super.key,
//     required this.rightBottomView,
//     this.callbackRightBottomView,
//   });

//   @override
//   State<RightBottomSizeView> createState() => _RightBottomSizeViewState();
// }

// class _RightBottomSizeViewState extends State<RightBottomSizeView> {
//   final _sizePercent = ValueNotifier(100.0);
//   final _antiFakePercent = ValueNotifier(100.0);
//   RightBottomView? rightBottomView;
//   RightBottomView? _newView;
//   @override
//   void initState() {
//     _newView = widget.rightBottomView?.copyWith();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(10.w),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Column(
//                 children: [Text('水印'), Text('大小')],
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       margin: EdgeInsets.only(top: 8.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '小',
//                             style: TextStyle(fontSize: 12.sp),
//                           ),
//                           Text(
//                             "大",
//                             style: TextStyle(fontSize: 14.sp),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                         bottom: 20.w,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border(
//                             bottom:
//                                 BorderSide(color: "f0f0f0".hex, width: 1.w)),
//                       ),
//                       child: AssertsImageBuilder('pic_thum'.png,
//                           builder: (context, imageInfo) {
//                         return ValueListenableBuilder(
//                           valueListenable: _sizePercent,
//                           builder: (context, key, child) {
//                             return SliderTheme(
//                               data: SliderThemeData(
//                                 trackHeight: 5.w,
//                                 thumbShape: ImageSliderThumb(
//                                     image: imageInfo?.image,
//                                     size: const Size(30, 30),
//                                     msg: '${key.toInt()}%'),
//                               ),
//                               child: Slider(
//                                 divisions: 200,
//                                 value: key,
//                                 min: 0,
//                                 max: 200,
//                                 activeColor: "e6e9f0".hex,
//                                 inactiveColor: "e6e9f0".hex,
//                                 onChanged: (newValue) {
//                                   _sizePercent.value = newValue;
//                                   // _newwatermarkView?.frame?.width =
//                                   //     (_watermarkView?.frame?.width ?? 0) *
//                                   //         (newValue / 100);
//                                 },
//                               ),
//                             );
//                           },
//                           // child: ,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _sizePercent.value = 100;
//                   // _newView?.viewAlpha =
//                   //     (widget.rightBottomView?.viewAlpha ?? 1) *
//                   //         (_sizePercent.value / 100);
//                   try {
//                     widget.callbackRightBottomView!(_newView!);
//                   } catch (e) {
//                     showErrorDialog(context, e.toString());
//                   }
//                 },
//                 child: Image.asset(
//                   'reset_img'.png,
//                   width: 32.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [Text('防伪码'), Text('大小')],
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       margin: EdgeInsets.only(top: 8.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '小',
//                             style: TextStyle(fontSize: 12.sp),
//                           ),
//                           Text(
//                             "大",
//                             style: TextStyle(fontSize: 14.sp),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                         bottom: 20.w,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border(
//                             bottom:
//                                 BorderSide(color: "f0f0f0".hex, width: 1.w)),
//                       ),
//                       child: AssertsImageBuilder('pic_thum'.png,
//                           builder: (context, imageInfo) {
//                         return ValueListenableBuilder(
//                           valueListenable: _antiFakePercent,
//                           builder: (context, key, child) {
//                             return SliderTheme(
//                               data: SliderThemeData(
//                                 trackHeight: 5.w,
//                                 thumbShape: ImageSliderThumb(
//                                     image: imageInfo?.image,
//                                     size: const Size(30, 30),
//                                     msg: '${key.toInt()}%'),
//                               ),
//                               child: Slider(
//                                 divisions: 200,
//                                 value: key,
//                                 min: 0,
//                                 max: 200,
//                                 activeColor: "e6e9f0".hex,
//                                 inactiveColor: "e6e9f0".hex,
//                                 onChanged: (newValue) {
//                                   _antiFakePercent.value = newValue;
//                                   // _newwatermarkView?.frame?.width =
//                                   //     (_watermarkView?.frame?.width ?? 0) *
//                                   //         (newValue / 100);
//                                 },
//                               ),
//                             );
//                           },
//                           // child: ,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _antiFakePercent.value = 100;
//                   // _newView?.viewAlpha =
//                   //     (widget.rightBottomView?.viewAlpha ?? 1) *
//                   //         (_antiFakePercent.value / 100);
//                   try {
//                     widget.callbackRightBottomView!(_newView!);
//                   } catch (e) {
//                     showErrorDialog(context, e.toString());
//                   }
//                 },
//                 child: Image.asset(
//                   'reset_img'.png,
//                   width: 32.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
