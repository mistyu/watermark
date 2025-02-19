// import 'dart:io';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:watermark_camera/config/router.dart';
// import 'package:watermark_camera/utils/asset_utils.dart';

// class SaveSuccess extends StatefulWidget {
//   const SaveSuccess({super.key});

//   @override
//   State<SaveSuccess> createState() => _SaveSuccessState();
// }

// class _SaveSuccessState extends State<SaveSuccess> {
//   final TextStyle linkStyle = TextStyle(
//       color: Colors.blue,
//       decoration: TextDecoration.underline,
//       decorationColor: Colors.blue,
//       fontSize: 12.sp);

//   final TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 12.sp);

//   TapGestureRecognizer _tapServer = TapGestureRecognizer();

//   @override
//   void initState() {
//     super.initState();
//     _tapServer = TapGestureRecognizer()
//       ..onTap = () {
//         print('点击 在线客服');
//       };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('保存成功'),
//       ),
//       body: Column(
//         children: [
//           Image.asset("bg_b".png),
//           Container(
//             constraints: BoxConstraints.expand(height: 180.w),
//             margin: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
//             padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   '保存成功请到系统相册查看',
//                   style: defaultStyle,
//                 ),
//                 Text.rich(
//                   TextSpan(children: [
//                     TextSpan(text: '使用中有任何问题请联系 ', style: defaultStyle),
//                     TextSpan(
//                         text: '在线客服', style: linkStyle, recognizer: _tapServer),
//                   ]),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           AppRouter.router?.goNamed(AppRouter.homePath);
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 const WidgetStatePropertyAll(Colors.blue),
//                             shape: WidgetStatePropertyAll(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.w))),
//                             padding: WidgetStatePropertyAll(
//                                 EdgeInsets.symmetric(horizontal: 40.w))),
//                         child: Text(
//                           '首页',
//                           style:
//                               TextStyle(fontSize: 13.sp, color: Colors.white,height: 1),
//                         )),
//                     TextButton(
//                         onPressed: () {
//                           AppRouter.router?.goNamed(AppRouter.homePath);
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 const WidgetStatePropertyAll(Colors.blue),
//                             shape: WidgetStatePropertyAll(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.w))),
//                             padding: WidgetStatePropertyAll(
//                                 EdgeInsets.symmetric(horizontal: 40.w))),
//                         child: Text(
//                           '分享',
//                           style:
//                               TextStyle(fontSize: 13.sp, color: Colors.white,height: 1),
//                         )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       // bottomSheet: Container(
//       //   constraints: BoxConstraints.expand(height: 180.w),
//       //   margin: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
//       //   padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //     children: [
//       //       Text(
//       //         '保存成功请到系统相册查看',
//       //         style: defaultStyle,
//       //       ),
//       //       Text.rich(
//       //         TextSpan(children: [
//       //           TextSpan(text: '使用中有任何问题请联系 ', style: defaultStyle),
//       //           TextSpan(
//       //               text: '在线客服', style: linkStyle, recognizer: _tapServer),
//       //         ]),
//       //       ),
//       //       Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //         children: [
//       //           TextButton(
//       //             onPressed: () {
//       //               final data='se';
//       //               print('object');
//       //               AppRouter.router?.goNamed(AppRouter.homePath);
//       //             },
//       //             child: Text('首页'),
//       //           ),
//       //           RawMaterialButton(
//       //             onPressed: () {
//       //               AppRouter.router?.goNamed(AppRouter.homePath);
//       //             },
//       //             child: Text('分享'),
//       //           )
//       //         ],
//       //       )
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
