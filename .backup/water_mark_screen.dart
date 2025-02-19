// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:watermark_camera/bloc/cubit/resource_builder.dart';
// import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
// import 'package:watermark_camera/camera/camera_screen.dart';
// import 'package:watermark_camera/models/watermark/watermark.dart';
// import 'package:watermark_camera/screens/my.dart';
// import 'package:watermark_camera/utils/asset_utils.dart';
// import 'package:watermark_camera/utils/color_extension.dart';
// import 'package:watermark_camera/utils/watermark.dart';

// class WaterMarkScreen extends StatefulWidget {
//   const WaterMarkScreen({super.key});

//   @override
//   State<WaterMarkScreen> createState() => _WaterMarkScreenState();
// }

// class _WaterMarkScreenState extends State<WaterMarkScreen> {
//   int currentPageIndex = 0;
//   NavigationDestinationLabelBehavior labelBehavior =
//       NavigationDestinationLabelBehavior.onlyShowSelected;

//   List titles = ["首页", "我的"];
//   List normalImgUrls = [
//     "home1".png,
//     "my1".png,
//   ];
//   List selectedImgUrls = [
//     "home2".png,
//     "my2".png,
//   ];

//   int _categoryId = 1;

//   void _onTap(int categoryId) {
//     setState(() {
//       _categoryId = categoryId;
//     });
//   }

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     double itemWidth = (MediaQuery.of(context).size.width - 32.0.w) / 3;
//     return Scaffold(
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const CameraScreen()));
//           },
//           elevation: 5,
//           backgroundColor: "7eab1d".hex,
//           child: Image.asset(
//             "Camera".png,
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           shape: const CircularNotchedRectangle(),
//           child: Row(children: <Widget>[
//             SizedBox(height: 50.0.w, width: itemWidth, child: tabbar(0)),
//             SizedBox(
//               height: 50.0.w,
//               width: itemWidth,
//             ),
//             SizedBox(height: 50.0.w, width: itemWidth, child: tabbar(1)),
//           ]),
//         ),
//         body: WatermarkResourceBuilder(builder: (context, state) {
//           return Container(
//             margin: EdgeInsets.only(top: 40.0.w),
//             child: <Widget>[
//               // 首页
//               Column(children: [
//                 SizedBox(
//                   height: 40.0.w,
//                   child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: state.categories.map((k) {
//                         return Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20.0.w),
//                             child: GestureDetector(
//                                 onTap: () {
//                                   _onTap(k.id ?? 1);
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       k.title ?? "",
//                                       style: TextStyle(
//                                           color: k.id == _categoryId
//                                               ? Colors.black
//                                               : Colors.grey,
//                                           fontSize: k.id == _categoryId
//                                               ? 16.0.sp
//                                               : 14.0.sp),
//                                     ),
//                                     //被选择后的渐变下划线
//                                     Visibility(
//                                         visible: k.id == _categoryId,
//                                         child: Container(
//                                           margin: EdgeInsets.only(top: 5.0.w),
//                                           width: 20.0.w,
//                                           height: 4.0.w,
//                                           decoration: BoxDecoration(
//                                               gradient: LinearGradient(colors: [
//                                                 Color.fromARGB(
//                                                     255, 152, 195, 231),
//                                                 Color.fromARGB(255, 0, 127, 231)
//                                               ]),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(2.0.w))),
//                                         ))
//                                   ],
//                                 )));
//                       }).toList()),
//                 ),
//                 //网格列表
//                 Expanded(
//                     child: WaterMarkScreenGridView(categoryid: _categoryId)),
//               ]),

//               // const CameraScreen(),
//               // 我的页
//               const MyWidget(),
//             ][currentPageIndex],
//           );
//         }));
//   }

//   // 自定义BottomAppBar
//   Widget tabbar(int index) {
//     //设置默认未选中的状态
//     TextStyle style = TextStyle(fontSize: 12, color: Colors.black);

//     String imgUrl = normalImgUrls[index];
//     if (currentPageIndex == index) {
//       //选中的话
//       style = TextStyle(fontSize: 12.0.sp, color: "7eab1d".hex);
//       imgUrl = selectedImgUrls[index];
//     }
//     //构造返回的Widget
//     Widget item = Container(
//       child: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Image.asset(
//               imgUrl,
//               height: 25.w,
//               fit: BoxFit.fitHeight,
//             ),
//             Text(
//               titles[index],
//               style: style,
//             )
//           ],
//         ),
//         onTap: () {
//           if (currentPageIndex != index) {
//             setState(() {
//               currentPageIndex = index;
//             });
//           }
//         },
//       ),
//     );
//     return item;
//   }
// }

// class WaterMarkScreenGridView extends StatelessWidget {
//   final int categoryid;
//   const WaterMarkScreenGridView({super.key, required this.categoryid});

//   @override
//   Widget build(BuildContext context) {
//     return WatermarkResourceBuilder(builder: (context, state) {
//       final templates =
//           state.templates.where((e) => categoryid == e.cid).toList();
//       return GridView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 8.0.w),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           mainAxisSpacing: 6.w,
//           crossAxisSpacing: 6.w,
//           crossAxisCount: 2, // 每行两列
//           childAspectRatio: 16 / 13, // 宽高比
//         ),
//         itemCount: templates.length,
//         itemBuilder: (context, index) {
//           final template = templates[index];
//           return InkWell(
//             onTap: () async {
//               WatermarkView? watermarkView =
//                   await getWatermarkViewData(context, template.id ?? 0);

//               if (context.mounted) {
//                 context.read<WatermarkCubit>().loadedWatermarkView(
//                     template?.id ?? 1698049557635,
//                     watermarkView: watermarkView);
//                 context.pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CameraScreen()),
//                 );
//               }
//             },
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Image.network(
//                     "${Config.staticUrl}${template.cover ?? ''}",
//                     fit: BoxFit.cover,
//                     alignment: Alignment.bottomCenter,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8.w,
//                 ),
//                 Text(
//                   template.title ?? '',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 )
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
