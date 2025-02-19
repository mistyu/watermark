// import 'dart:async';
// import 'dart:convert';

// import 'package:alipay_kit/alipay_kit.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive/hive.dart';
// import 'package:watermark_camera/config/prefs.dart';
// import 'package:watermark_camera/utils/color_extension.dart';
// import 'package:watermark_camera/utils/http.dart';
// import 'package:watermark_camera/utils/watermark.dart';
// import 'package:watermark_camera/widgets/ui/custom_gradient_button.dart';
// import 'package:watermark_camera/widgets/watermark/WatermarkFont.dart';

// class AlipayScreen extends StatefulWidget {
//   const AlipayScreen({super.key});

//   @override
//   State<AlipayScreen> createState() => _AlipayScreenState();
// }

// class _AlipayScreenState extends State<AlipayScreen> {
//   late final StreamSubscription<AlipayResp> _paySubs;
//   late final StreamSubscription<AlipayResp> _authSubs;

//   var timestr = DateTime.now().millisecondsSinceEpoch;

//   Future<String?> getOrderStr(String title) async {
//     // 从已经打开的盒子中获取token
//     var box = await Hive.openBox("usertoken");
//     var userToken = Hive.box("usertoken");
//     String? token = userToken.get("usertoken");
//     print("token:$token");
//     final response = await Http.getInstance().get("/pay/ali/appPay",
//         params: {'orderNumber': title},
//         options: Options(headers: {
//           'Authorization': 'Bearer $token',
//         }));
//     await box.close();
//     if (response?.code == 200) {
//       return response?.data;
//     }

//     return null;
//   }

//   Future<String?> getRefundStr(String title) async {
//     // 从已经打开的盒子中获取token
//     var box = await Hive.openBox("usertoken");
//     var userToken = Hive.box("usertoken");
//     String? token = userToken.get("usertoken");
//     // String? token = AppStorage.prefs?.getString("usertoken");
//     print("token:$token");
//     final response = await Http.getInstance().post("/pay/ali/refund",
//         data: {"outRefundNo": "", "outTradeNo": title, "refundAmount": "0.01"},
//         options: Options(headers: {
//           'Authorization': 'Bearer $token',
//         }));
//     await box.close();
//     if (response?.code == 200) {
//       return response?.data;
//     }

//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     //todo 沙箱支付环境，真实支付时，将此句删掉
//     AlipayKitPlatform.instance.setEnv(env: AlipayEnv.sandbox);
//     _paySubs = AlipayKitPlatform.instance.payResp().listen(_listenPay);
//     _authSubs = AlipayKitPlatform.instance.authResp().listen(_listenAuth);
//   }

//   void _listenPay(AlipayResp resp) {
//     Map<String, dynamic> result = jsonDecode(resp.result ?? "");
//     if (resp.resultStatus == 9000) {
//       _showTips('支付成功',
//           "￥${result["alipay_trade_app_pay_response"]["total_amount"]}");
//     } else {
//       _showTips('支付失败', "");
//     }
//     // final String content = 'pay: ${resp.resultStatus} - ${resp.result}';
//     // _showTips('支付', content);
//   }

//   void _listenAuth(AlipayResp resp) {
//     final String content = 'pay: ${resp.resultStatus} - ${resp.result}';
//     _showTips('授权登录', content);
//   }

//   @override
//   void dispose() {
//     _paySubs.cancel();
//     _authSubs.cancel();
//     super.dispose();
//   }

//   // Container _createButtonContainer() {
//   //   return new Container(
//   //       alignment: Alignment.center,
//   //       child: new Row(
//   //         mainAxisSize: MainAxisSize.min,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: <Widget>[
//   //           new Container(width: 20.0),
//   //         ],
//   //       ));
//   // }

//   // Widget _resultWidget(key, value) {
//   //   return new Container(
//   //     child: new Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //       children: <Widget>[
//   //         new Container(
//   //           alignment: Alignment.centerRight,
//   //           width: 100.0,
//   //           child: new Text('$key :'),
//   //         ),
//   //         new Container(width: 5.0),
//   //         new Flexible(child: new Text('$value', softWrap: true)),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     //     List<Widget> widgets = <Widget>[];
//     // widgets.add(_createButtonContainer());

//     // if (_locationResult != null) {
//     //   _locationResult?.forEach((key, value) {
//     //     widgets.add(_resultWidget(key, value));
//     //   });
//     // }
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Alipay Kit Demo'),
//         ),
//         // body: Column(
//         //   children: widgets,
//         // ),
//         body: ListView(
//           children: <Widget>[
//             ListTile(
//                 title: Text('环境检查'),
//                 onTap: () async {
//                   // Result res = await getUserandToken();
//                   // _showTips('res', "res:${res.token}");
//                   List? template = await getTemplatesByCid(1);
//                   // print(template);
//                 }),
//             ListTile(
//               title: Text('支付'),
//               onTap: () async {
//                 print(timestr);
//                 String? orderInfo = await getOrderStr(timestr.toString());
//                 AlipayKitPlatform.instance.pay(
//                   orderInfo: orderInfo ?? "",
//                 );
//               },
//             ),
//             ListTile(
//               title: Text('退款'),
//               onTap: () async {
//                 print(timestr);
//                 String? refundInfo = await getRefundStr(timestr.toString());
//                 // AlipayKitPlatform.instance.pay(
//                 //   orderInfo: orderInfo ?? "",
//                 // );
//                 print(refundInfo);
//               },
//             ),
//             // ListTile(
//             //   title: Text('授权'),
//             //   onTap: () {
//             // AlipayKitPlatform.instance.auth(
//             //       appId: _ALIPAY_APPID,
//             //       pid: _ALIPAY_PID,
//             //       targetId: _ALIPAY_TARGETID,
//             //       signType: _ALIPAY_USE_RSA2
//             //           ? UnsafeAlipayKitPlatform.SIGNTYPE_RSA2
//             //           : UnsafeAlipayKitPlatform.SIGNTYPE_RSA,
//             //       privateKey: _ALIPAY_PRIVATEKEY,
//             //     );
//             //   },
//             // ),
//           ],
//         ));
//   }

// // 支付结束页面
//   void _showTips(String title, String result) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(10.0.w),
//           child: Column(
//             children: [
//               Expanded(
//                   child: Column(
//                 children: [
//                   Text.rich(TextSpan(
//                     children: [
//                       TextSpan(
//                           text: title,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20.0.sp)),
//                       TextSpan(
//                           text: result,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20.0.sp))
//                     ],
//                   )),
//                   Text("支付宝"),
//                 ],
//               )),
//               GradientButton(
//                 colors: ["eac4ab".hex, "ea955e".hex],
//                 tapCallback: () => {Navigator.pop(context)},
//                 child: Text("完成"),
//                 borderRadius: BorderRadius.circular(5.0.w),
//                 height: 40.0.w,
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
