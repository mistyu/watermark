import 'dart:convert';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:watermark_camera/bloc/cubit/resource_builder.dart';
import 'package:watermark_camera/bloc/cubit/resource_cubit.dart';
import 'package:watermark_camera/bloc/cubit/right_bottom_builder.dart';
import 'package:watermark_camera/bloc/cubit/right_bottom_cubit.dart';
import 'package:watermark_camera/bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/template/template.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/screens/watermark.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/colours.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'package:watermark_camera/widgets/right_bottom/right_bottom_content.dart';
import 'package:watermark_camera/widgets/right_bottom/style_edit.dart';
import 'package:watermark_camera/widgets/ui/assert_image_builder.dart';
import 'package:watermark_camera/widgets/ui/custom_gradient_button.dart';
import 'package:watermark_camera/widgets/ui/image_slider_thumb.dart';
import 'package:watermark_camera/widgets/ui/watermark_content.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class RightBottomWatermark extends StatefulWidget {
  const RightBottomWatermark({super.key});

  @override
  State<RightBottomWatermark> createState() => _RightBottomWatermarkState();
}

class _RightBottomWatermarkState extends State<RightBottomWatermark>
    with SingleTickerProviderStateMixin {
  final WidgetsToImageController _controller = WidgetsToImageController();
  late TabController _tabcontroller;
  final tabList = ['水印', '大小', '防伪', '署名', '位置/透明度'];
  WatermarkView? watermarkview;
  Template? template;

  RightBottomView? _rightBottomView;
  final GlobalKey _globalKey = GlobalKey();

  final _rightbottomPosition = ValueNotifier(Offset(10.w, 10.w));
  final _scaleFactor = ValueNotifier(1.0);
  final _opacity = ValueNotifier(1.0);

  @override
  void initState() {
    int? id = context.read<WatermarkCubit>().watermarkId;
    template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == id);
    watermarkview = context.read<WatermarkCubit>().watermarkView;

    _rightBottomView = context.read<RightBottomCubit>().rightBottomView;

    _tabcontroller = TabController(
        initialIndex: 0, length: tabList.length, vsync: this); //让程序和手机刷新频率统一
    super.initState();
  }

  @override
  void dispose() {
    _tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text("<"),
        title: Center(
          child: Text(
            '右下角水印',
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Text(
              "保存",
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: CameraAwesomeBuilder.previewOnly(builder: (context, preview) {
        var size =
            _globalKey.currentContext?.findRenderObject()?.paintBounds.size;
        final height = size?.height;
        return Stack(
          children: [
            Watermark(watermarkController: _controller),
            Positioned(
              left: watermarkview?.frame?.left ?? 0.w,
              bottom:
                  // 275.2,
                  (height ?? 0 + (watermarkview?.frame?.bottom ?? 0)),
              child: WatermarkContent(
                watermarkView: watermarkview,
                template: template,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _rightbottomPosition,
              builder: (context, value, child) {
                // final rightbottomView = view.rightBottomView;

                return Positioned(
                  right: value.dx.w,
                  bottom: ((height ?? 0) + value.dy),
                  child: child ?? const SizedBox.shrink(),
                );
              },
              child: ValueListenableBuilder(
                valueListenable: _scaleFactor,
                builder: (context, v, c) {
                  return Transform.scale(
                    alignment: Alignment.bottomRight,
                    scale: v,
                    child: c,
                  );
                },
                child: ValueListenableBuilder(
                  valueListenable: _opacity,
                  builder: (context, a, b) {
                    return Opacity(opacity: a, child: b);
                  },
                  child: RightBottomContent(
                    rightBottomView: _rightBottomView,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomSheet: WatermarkResourceBuilder(builder: (context, state) {
        final data = state.rightbottom;
        return Container(
          key: _globalKey,
          height: 0.43.sh,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(20.r),
              )),
          child: Column(
            children: [
              TabBar(
                controller: _tabcontroller,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.only(
                    left: 20.w, right: 8.w, top: 10.w, bottom: 5.w),
                labelStyle: TextStyle(fontSize: 16.sp),
                unselectedLabelStyle: TextStyle(fontSize: 16.sp),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
                unselectedLabelColor: Colours.kGrey700,
                tabs: tabList.map((item) {
                  return Tab(
                    height: 30.h,
                    text: item,
                    // style: Theme.of(context).textTheme.titleLarge,
                  );
                }).toList(),
              ),
              if (state.rightbottom != null)
                Expanded(
                  child: TabBarView(controller: _tabcontroller, children: [
                    RightBottomGridView(),
                    RightBottomSizeView(
                      rightBottomView: _rightBottomView,
                      callbackRightBottomSize: (value) {
                        _scaleFactor.value = value * 0.01;
                      },
                      callbackRightBottomantiFake: (value) {},
                    ),
                    RightBottomAntifakeView(
                      rightBottomView: _rightBottomView,
                    ),
                    RightBottomSignView(
                      rightBottomView: _rightBottomView,
                    ),
                    RightBottomStyleView(
                      rightBottomView: _rightBottomView,
                      callbackRightBottomOpacity: (value) {
                        _opacity.value = value * 0.01;
                      },
                      callbackRightBottomPosition: (v) {
                        _rightbottomPosition.value = v;
                      },
                    ),
                  ]),
                )
            ],
          ),
        );
      }),
    );
  }
}

class RightBottomGridView extends StatefulWidget {
  final int? cid;
  const RightBottomGridView({
    super.key,
    this.cid,
  });

  @override
  State<RightBottomGridView> createState() => _RightBottomGridViewState();
}

class _RightBottomGridViewState extends State<RightBottomGridView> {
  int? _activeIndex = null;

  void onChangeActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkResourceBuilder(builder: (context, state) {
      final rightbottomList = state.rightbottom;
      return Padding(
        padding: const EdgeInsets.all(12).w,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 6.w,
            crossAxisSpacing: 6.w,
            crossAxisCount: 4, // 每行4列
          ),
          itemCount: state.rightbottom?.length, // 总共
          itemBuilder: (context, index) {
            if (rightbottomList != null && rightbottomList.isNotEmpty) {
              final coverData = rightbottomList[index];
              return ItemCover(
                  coverData: coverData,
                  active: _activeIndex == index,
                  onChangeIndex: () => onChangeActiveIndex(index));
            }
            return const SizedBox.shrink();
          },
        ),
      );
    });
  }
}

class ItemCover extends StatefulWidget {
  const ItemCover(
      {super.key,
      required this.coverData,
      required this.active,
      this.onChangeIndex});

  final RightBottom coverData;
  final bool active;
  final Function()? onChangeIndex;

  @override
  State<ItemCover> createState() => _ItemCoverState();
}

class _ItemCoverState extends State<ItemCover> {
  bool _mask = false;

  bool get mask => widget.active && _mask;

  RightBottomView? _originRightBottomView;

  final controller = TextEditingController();

  void onChangeMask(bool isVisible) {
    widget.onChangeIndex?.call();
    setState(() {
      _mask = isVisible;
    });
  }

  void onChangeRightBottomView() async {
    _originRightBottomView =
        await getRightBottomViewData(context, widget.coverData.id ?? 0);
    if (context.mounted) {
      context.read<RightBottomCubit>().loadedWatermarkView(
          id: widget.coverData.id ?? 0,
          rightBottomView: _originRightBottomView);

      //   context.pop();
    }
  }

  Widget coverWidget(RightBottom rightbottom) {
    return rightbottom.cover != '' && rightbottom.cover != null
        ? Image.network("${Config.staticUrl}${rightbottom.cover ?? ''}",
            // width: style?.iconWidth?.toDouble() ?? 40.w,
            fit: BoxFit.contain)
        : const SizedBox.shrink();
  }

  Future<String?> showEditDialog() async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        // final preButtonStyle = WidgetStateProperty();
        return RightBottomViewBuilder(builder: (context, state) {
          final rightBottomView = state.rightBottomView;
          if (rightBottomView?.content != '' &&
              rightBottomView?.content != null) {
            controller.text = rightBottomView?.content ?? '';
            return Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 0.64.sh),
                // margin:
                //     EdgeInsets.symmetric(horizontal: 0.08.sw, vertical: 0.15.sh),
                margin: EdgeInsets.symmetric(horizontal: 0.08.sw),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('save_blue_img'.webp),
                        alignment: Alignment.topCenter)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: LayoutBuilder(builder: (context, constrain) {
                    return Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                            ),
                            child: Text(
                              "右下角水印",
                              style: Theme.of(context).textTheme.headlineMedium,
                            )),
                        Stack(
                          children: [
                            Image.asset(
                              'edit_preview'.png,
                            ),
                            // 原始数据
                            Positioned(
                                bottom: 4,
                                right: (constrain.maxWidth ?? 0) / 2 + 4,
                                child: RightBottomContent(
                                  rightBottomView: _originRightBottomView,
                                )),

                            Positioned(
                                right: 4,
                                bottom: 4,
                                child: RightBottomContent(
                                  rightBottomView: rightBottomView,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        TextField(
                          maxLength: rightBottomView
                              ?.content?.length, // 输入长度，右下角会显示 /20
                          maxLines: 1,
                          autofocus: true,
                          controller: controller, // 用于获取输入内容
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          enabled: true,

                          cursorColor: const Color(0xff008577),
                          // style: TextStyle(
                          //     color: Colors.grey, fontSize: 16.sp),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0.w),
                            // counterText: '', //去掉右下角计数文本
                            isCollapsed: true, //是否收缩（改变边框大小）
                            focusedBorder: _outlineInputBorder,
                            border: _outlineInputBorder,
                            enabledBorder: _outlineInputBorder,
                            disabledBorder: _outlineInputBorder,
                            focusedErrorBorder: _outlineInputBorder,
                            errorBorder: _outlineInputBorder,
                            hintText: "请输入水印文案",
                            hintStyle: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xffadadad)),
                          ),
                          // onSubmitted: (value) {
                          //   print(value);
                          //   Navigator.pop(context, value);
                          // }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rightBottomView?.content = controller.text;
                                });
                                // context
                                //     .read<RightBottomCubit>()
                                //     .loadedWatermarkView(
                                //         rightBottomView: rightBottomView);
                              },
                              child: Container(
                                width: 0.3.sw,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xff146dfe)),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "预览",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xff146dfe)),
                                ),
                              ),
                            ),
                            // TextButton(
                            //   style: ButtonStyle(
                            //       shape: WidgetStatePropertyAll<OutlinedBorder>(
                            //           OutlinedBorder())),
                            //   child: Text("预览"),
                            //   onPressed: () =>
                            //       Navigator.of(context).pop(), // 关闭对话框
                            // ),
                            GradientButton(
                              width: 0.3.sw,
                              borderRadius: BorderRadius.circular(50),
                              colors: const [
                                Color(0xff76a6ff),
                                Color(0xff146dfe)
                              ],
                              child: Text(
                                "确认修改",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              tapCallback: () {
                                //关闭对话框并返回值
                                print(controller.text);
                                Navigator.pop(context, controller.text);
                                // Navigator.of(context).pop(_controller.text);
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  }),
                ),
                // AlertDialog(
                //   // icon: Image.asset('save_blue_img'.webp),
                //   title: Center(child: Text("右下角水印")),
                //   content: Column(
                //     children: [
                //       Image.asset('edit_preview'.png),
                //       TextField(
                //         maxLength:
                //             rightBottomView?.content?.length, // 输入长度，右下角会显示 /20
                //         maxLines: 1,
                //         autofocus:
                //             true, // autofocus设置为true，输入框一出现键盘就出现，否则需要二次点击使得键盘出现
                //         controller: _controller, // 用于获取输入内容
                //         textInputAction: TextInputAction.done,
                //         keyboardType: TextInputType.text,
                //         textAlign: TextAlign.left,
                //         enabled: true,
                //         cursorColor: const Color(0xff008577),
                //         // style: TextStyle(
                //         //     color: Colors.grey, fontSize: 16.sp),
                //         decoration: InputDecoration(
                //           contentPadding: EdgeInsets.all(8.0.w),
                //           // counterText: '', //去掉右下角计数文本
                //           isCollapsed: true, //是否收缩（改变边框大小）
                //           focusedBorder: _outlineInputBorder,
                //           border: _outlineInputBorder,
                //           enabledBorder: _outlineInputBorder,
                //           disabledBorder: _outlineInputBorder,
                //           focusedErrorBorder: _outlineInputBorder,
                //           errorBorder: _outlineInputBorder,
                //           hintText: "请输入水印文案",
                //           hintStyle: TextStyle(
                //               fontSize: 16.sp, color: const Color(0xffadadad)),
                //         ),
                //         onSubmitted: (value) => Navigator.pop(context, value),
                //       ),
                //     ],
                //   ),
                //   actionsAlignment: MainAxisAlignment.spaceAround,
                //   actions: <Widget>[
                //     TextButton(
                //       child: Text("预览"),
                //       onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                //     ),
                //     TextButton(
                //       child: Text("确认修改"),
                //       onPressed: () {
                //         //关闭对话框并返回true
                //         Navigator.of(context).pop(true);
                //       },
                //     ),
                //   ],
                // ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
      },
    );
// 防止打开其他水印时出现闪动
    controller.text = '';
    return result;
  }

  @override
  void didUpdateWidget(covariant ItemCover oldWidget) {
    if (oldWidget.active != widget.active) {
      setState(() {
        _mask = widget.active;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  OutlineInputBorder get _outlineInputBorder => OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
      borderSide: const BorderSide(color: Color(0xFFe2e2e2)));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onChangeRightBottomView();
        // 编辑遮罩层出现
        onChangeMask(mask);
        // 弹窗
        showEditDialog();
      },
      child: Stack(
        children: [
          // 底层内容
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("bg_b".png), fit: BoxFit.fill)),
            padding: EdgeInsets.all(5.w),
            child: coverWidget(widget.coverData),
          ),
          // 遮罩层
          Visibility(
            visible: mask,
            child: Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                      width: 60.w,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          gradient: const LinearGradient(
                              colors: [Color(0xff76a6ff), Color(0xff146dfe)])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'editico_white'.png,
                            width: 16.w,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            '编辑',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white),
                          ),
                        ],
                      )),
                ),
                // 半透明黑色遮罩层
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RightBottomSignView extends StatefulWidget {
  final RightBottomView? rightBottomView;
  // final
  const RightBottomSignView({super.key, required this.rightBottomView});
  @override
  State<RightBottomSignView> createState() => _RightBottomSignViewState();
}

class _RightBottomSignViewState extends State<RightBottomSignView> {
  RightBottomView? _rightBottomView;
  RightBottomView? _signView;
  final _signSwitch = ValueNotifier(false);

  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
      borderSide: BorderSide(color: Color(0xFFe2e2e2)));
  @override
  void initState() {
    _rightBottomView = widget.rightBottomView?.copyWith();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '给你的视频照片署名',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder(
                  valueListenable: _signSwitch,
                  builder: (context, value, child) {
                    return Switch(
                      value: value,
                      activeColor: "5b68ff".hex,
                      onChanged: (bool? value) {
                        _signSwitch.value = value ?? false;
                      },
                    );
                  }),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                cursorColor: const Color(0xff008577),
                maxLength: 6,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0.w),
                  counterText: '', //去掉右下角计数文本
                  isCollapsed: true, //是否收缩（改变边框大小）
                  focusedBorder: _outlineInputBorder,
                  border: _outlineInputBorder,
                  enabledBorder: _outlineInputBorder,
                  disabledBorder: _outlineInputBorder,
                  focusedErrorBorder: _outlineInputBorder,
                  errorBorder: _outlineInputBorder,
                  hintText: "可输入（6位字符）",
                  hintStyle: TextStyle(fontSize: 14.sp),
                  constraints: BoxConstraints(maxWidth: 260.w),
                ),
              ),
              Image.asset(
                "save_img".png,
                width: 32.w,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          Visibility(
              visible: true,
              child: Row(
                children: [
                  Image.asset(
                    "tsico".png,
                    width: 18.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "当前水印不支持署名",
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class RightBottomAntifakeView extends StatefulWidget {
  final RightBottomView? rightBottomView;
  final ValueChanged<RightBottomView>? callbackAntifake;
  const RightBottomAntifakeView({
    super.key,
    this.callbackAntifake,
    this.rightBottomView,
  });
  @override
  State<RightBottomAntifakeView> createState() =>
      _RightBottomAntifakeViewState();
}

class _RightBottomAntifakeViewState extends State<RightBottomAntifakeView> {
  RightBottomView? _rightBottomView;
  RightBottomView? _antifake;
  final _antifakeSwitch = ValueNotifier(false);
  final _textController = TextEditingController(text: '');

  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
      borderSide: BorderSide(color: Color(0xFFe2e2e2)));
  @override
  void initState() {
    _rightBottomView = widget.rightBottomView?.copyWith();
    if (_rightBottomView?.isAntiFack ?? false) {
      _textController.text = getRandomString(14);
    }
    super.initState();
  }

  String getRandomString(int length) {
    final random = Random();
    const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _antifakeSwitch.value = _rightBottomView?.isAntiFack ?? false;

    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '随机生成照片防伪码',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder(
                  valueListenable: _antifakeSwitch,
                  builder: (context, value, child) {
                    return Switch(
                      value: value,
                      activeColor: "5b68ff".hex,
                      onChanged: (bool? value) {
                        _antifakeSwitch.value = value ?? false;
                      },
                    );
                  }),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: _textController,
                cursorColor: const Color(0xff008577),
                maxLength: 14,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0.w),
                  counterText: '', //去掉右下角计数文本
                  isCollapsed: true, //是否收缩（改变边框大小）
                  focusedBorder: _outlineInputBorder,
                  border: _outlineInputBorder,
                  enabledBorder: _outlineInputBorder,
                  disabledBorder: _outlineInputBorder,
                  focusedErrorBorder: _outlineInputBorder,
                  errorBorder: _outlineInputBorder,
                  hintText: "可输入（14位字符）",
                  hintStyle: TextStyle(fontSize: 14.sp),
                  constraints: BoxConstraints(maxWidth: 240.w),
                ),
              ),
              Image.asset(
                "save_img".png,
                width: 32.w,
                fit: BoxFit.contain,
              ),
              GestureDetector(
                onTap: () {
                  _textController.text = getRandomString(14);
                },
                child: Image.asset(
                  "reset_img".png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 35.w,
                  child: Text(
                    '防伪位置',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  )),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "edit_up_img".png,
                  width: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "edit_down_img".png,
                  width: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "edit_left_img".png,
                  width: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "edit_right_img".png,
                  width: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // _verticalOffset.value = 10;
                  // _horizontalOffset.value = 10;
                  // try {
                  //   widget.callbackRightBottomPosition!(Offset(
                  //       _horizontalOffset.value.toDouble(),
                  //       _verticalOffset.value.toDouble()));
                  // } catch (e) {
                  //   showErrorDialog(context, e.toString());
                  // }
                },
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Visibility(
              visible: !(_rightBottomView?.isSupportFack ?? false),
              child: Row(
                children: [
                  Image.asset(
                    "tsico".png,
                    width: 18.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "当前水印不支持防伪",
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class RightBottomSizeView extends StatefulWidget {
  final RightBottomView? rightBottomView;
  final ValueChanged<double>? callbackRightBottomSize;
  final ValueChanged<double>? callbackRightBottomantiFake;
  const RightBottomSizeView(
      {super.key,
      required this.rightBottomView,
      this.callbackRightBottomSize,
      this.callbackRightBottomantiFake});

  @override
  State<RightBottomSizeView> createState() => _RightBottomSizeViewState();
}

class _RightBottomSizeViewState extends State<RightBottomSizeView> {
  final _sizePercent = ValueNotifier(100.0);
  final _antiFakePercent = ValueNotifier(100.0);
  RightBottomView? rightBottomView;
  RightBottomView? _newView;
  @override
  void initState() {
    _newView = widget.rightBottomView?.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [Text('水印'), Text('大小')],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '小',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            "大",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: "f0f0f0".hex, width: 1.w)),
                      ),
                      child: AssertsImageBuilder('pic_thum'.png,
                          builder: (context, imageInfo) {
                        return ValueListenableBuilder(
                          valueListenable: _sizePercent,
                          builder: (context, key, child) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 5,
                                thumbShape: ImageSliderThumb(
                                    image: imageInfo?.image,
                                    size: const Size(30, 30),
                                    msg: '${key.toInt()}%'),
                              ),
                              child: Slider(
                                divisions: 200,
                                value: key,
                                min: 0,
                                max: 200,
                                activeColor: "e6e9f0".hex,
                                inactiveColor: "e6e9f0".hex,
                                onChanged: (newValue) {
                                  _sizePercent.value = newValue;
                                  // _newwatermarkView?.frame?.width =
                                  //     (_watermarkView?.frame?.width ?? 0) *
                                  //         (newValue / 100);
                                  try {
                                    widget.callbackRightBottomSize!(
                                        _sizePercent.value);
                                  } catch (e) {
                                    showErrorDialog(context, e.toString());
                                  }
                                },
                              ),
                            );
                          },
                          // child: ,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _sizePercent.value = 100;
                  // _newView?.viewAlpha =
                  //     (widget.rightBottomView?.viewAlpha ?? 1) *
                  //         (_sizePercent.value / 100);
                  try {
                    widget.callbackRightBottomSize!(_sizePercent.value);
                  } catch (e) {
                    showErrorDialog(context, e.toString());
                  }
                },
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('防伪码'), Text('大小')],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '小',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            "大",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: "f0f0f0".hex, width: 1.w)),
                      ),
                      child: AssertsImageBuilder('pic_thum'.png,
                          builder: (context, imageInfo) {
                        return ValueListenableBuilder(
                          valueListenable: _antiFakePercent,
                          builder: (context, key, child) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 5,
                                thumbShape: ImageSliderThumb(
                                    image: imageInfo?.image,
                                    size: const Size(30, 30),
                                    msg: '${key.toInt()}%'),
                              ),
                              child: Slider(
                                divisions: 200,
                                value: key,
                                min: 0,
                                max: 200,
                                activeColor: "e6e9f0".hex,
                                inactiveColor: "e6e9f0".hex,
                                onChanged: (newValue) {
                                  _antiFakePercent.value = newValue;
                                  // _newwatermarkView?.frame?.width =
                                  //     (_watermarkView?.frame?.width ?? 0) *
                                  //         (newValue / 100);
                                  try {
                                    widget.callbackRightBottomantiFake!(
                                        _antiFakePercent.value);
                                  } catch (e) {
                                    showErrorDialog(context, e.toString());
                                  }
                                },
                              ),
                            );
                          },
                          // child: ,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _antiFakePercent.value = 100;
                  // _newView?.viewAlpha =
                  //     (widget.rightBottomView?.viewAlpha ?? 1) *
                  //         (_antiFakePercent.value / 100);
                  try {
                    widget.callbackRightBottomantiFake!(_antiFakePercent.value);
                  } catch (e) {
                    showErrorDialog(context, e.toString());
                  }
                },
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
