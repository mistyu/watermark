// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
// import 'package:watermark_camera/screens/edit_pic.dart';
// import 'package:watermark_camera/utils/color_extension.dart';
// import 'package:watermark_camera/utils/http.dart';
// import 'package:watermark_camera/utils/watermark.dart';
// import 'package:watermark_camera/widgets/ui/custom_gradient_button.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// class BrandLogo extends StatefulWidget {
//   final String? image;
//   const BrandLogo({super.key, this.image});

//   @override
//   State<BrandLogo> createState() => _BrandLogoState();
// }

// class _BrandLogoState extends State<BrandLogo> {
//   @override
//   Widget build(BuildContext context) {
//     int templateId = context.read<WatermarkCubit>().watermarkId;
//     String? _backValue;

//     return Scaffold(
//         appBar: AppBar(
//           // backgroundColor: "ffe8bf".hex,
//           // leading: Text("<"),
//           title: Text(
//             '品牌图',
//             style: TextStyle(fontSize: 16.0.sp),
//           ),
//           actions: [
//             Container(
//               margin: EdgeInsets.only(right: 20.0.w),
//               child: GradientButton(
//                 tapCallback: () {},
//                 child: Text(
//                   "联系客服",
//                   style: TextStyle(
//                       fontSize: 12.sp,
//                       color: "6b3415".hex,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 colors: [
//                   Color.fromRGBO(237, 164, 100, 0.2),
//                   Color.fromRGBO(244, 199, 168, 1),
//                 ],
//                 height: 35.0.w,
//                 width: 80.0.w,
//                 borderRadius: BorderRadius.circular(50.w),
//               ),
//             )
//           ],
//         ),
//         body: Container(
//           padding: EdgeInsets.all(10.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('你的品牌图：'),
//               Wrap(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(20.w),
//                     decoration: BoxDecoration(color: "eaf0fe".hex),
//                     child: GestureDetector(
//                       child: Text(
//                         "+",
//                         style: TextStyle(fontSize: 56.sp, height: 0.8),
//                       ),
//                       onTap: () async {
//                         final List<AssetEntity>? result =
//                             await AssetPicker.pickAssets(context);
//                         final backValue = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => EditPic(result: result)));
//                         setState(() {
//                           _backValue = backValue;
//                         });
//                       },
//                     ),
//                   ),
//                   Image.network(_backValue ?? ''),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }
