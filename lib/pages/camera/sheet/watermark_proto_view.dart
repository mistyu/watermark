import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_view.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';

/**
 * 点击水印的水印修改弹出框（水印 + 设置）；同步设置进行
 */
class WatermarkProtoView extends StatefulWidget {
  final WatermarkResource resource;
  final WatermarkView watermarkView;

  const WatermarkProtoView(
      {super.key, required this.resource, required this.watermarkView});

  @override
  State<WatermarkProtoView> createState() => _WatermarkProtoViewState();
}

class _WatermarkProtoViewState extends State<WatermarkProtoView> {
  final logic = Get.find<WatermarkProtoLogic>();
  final PageController _pageController = PageController();
  @override
  void initState() {
    logic.setResource(widget.resource);
    logic.setWatermarkView(widget.watermarkView);
    // _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            children: [
              _logoWidget(),
            ],
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0).w,
              child: Visibility(
                visible: logic.watermarkView.value != null,
                child: DottedBorder(
                  strokeWidth: 2.w,
                  color: Colors.white,
                  radius: Radius.circular(4.r),
                  borderType: BorderType.RRect,
                  dashPattern: const [4, 4],
                  padding: const EdgeInsets.all(8.0).w,
                  child: GetBuilder<WatermarkProtoLogic>(
                      init: logic,
                      id: logic.watermarkScaleId,
                      builder: (logic1) {
                        return Transform.scale(
                          alignment: Alignment.bottomLeft,
                          scale: logic1.watermarkScale.value ?? 1,
                          child: GetBuilder<WatermarkProtoLogic>(
                              init: logic,
                              id: logic.watermarkUpdateId,
                              builder: (logic2) {
                                return WatermarkPreview(
                                  resource: logic2.resource.value!,
                                  watermarkView: logic2.watermarkView.value,
                                );
                              }),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
        //设置内容 --- 这里也要更新
        Container(
          height: 1.sh * 0.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r)),
              color: Styles.c_FFFFFF),
          child: Column(
            children: [_buildHeader(), _buildContent(), _bottomButtons()],
          ),
        )
      ],
    );
  }

  //如何决定设置的数量
  Widget _buildContent() {
    return Expanded(
        child: PageView(
      pageSnapping: false,
      controller: _pageController,
      children: [
        _editWatermarkContent(),
        StyleEdit(),
      ],
    ));
  }

  Widget _editWatermarkContent() {
    return GetBuilder<WatermarkProtoLogic>(
        init: logic,
        id: logic.watermarkUpdateId,
        builder: (logic) {
          return SingleChildScrollView(
              child: Column(
                  children: logic.watermarkItems
                      .map((e) => e.type != watermarkCustomAddSettingTable1
                          ? _buildSettingItem(
                              label: Utils.isNotNullEmptyStr(
                                      logic.getContent(item: e))
                                  ? '${e.title}：'
                                  : e.title ?? '',
                              extra: logic.getExtraContent(item: e),
                              content: logic.getContent(item: e),
                              value: !Utils.isNotNullBoolean(e.data.isHidden),
                              onChanged: (value) =>
                                  logic.onChangeSwitch(value, item: e),
                              disableSwitch: logic.getDisableSwitch(item: e),
                              onTapChevronRight: () =>
                                  logic.onTapChevronRight(item: e))
                          : _buildSettingItemNewAdd(
                              label: Utils.isNotNullEmptyStr(
                                      logic.getContent(item: e))
                                  ? '${e.title}：'
                                  : e.title ?? '',
                              onTapChevronRight: () =>
                                  logic.onTapChevronRight(item: e)))
                      .toList()));
        });
  }

  /**
   * 水印内容每一个item修改
   */
  Widget _buildSettingItem({
    required String label,
    required bool value,
    Widget? extra,
    String? content,
    bool disableSwitch = false,
    required Function(bool) onChanged,
    VoidCallback? onTapChevronRight,
  }) {
    // print("xiaojianjian _buildSettingItem ${label}");
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.c_EDEDED, width: 1)),
      ),
      child: Row(
        children: [
          // 禁用开关
          IgnorePointer(
              //有的按钮是禁止关闭的
              ignoring: disableSwitch,
              child: Opacity(
                  opacity: disableSwitch ? 0.55 : 1,
                  child: Switch(value: value, onChanged: onChanged))),
          16.horizontalSpace,
          Expanded(
            child: GestureDetector(
              onTap: onTapChevronRight,
              child: Row(
                children: [
                  label.toText
                    ..style = value ? Styles.ts_333333_16 : Styles.ts_666666_16,
                  if (content != null)
                    Expanded(
                      child: content.toText
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis
                        ..style =
                            value ? Styles.ts_333333_16 : Styles.ts_666666_16,
                    ),
                  if (extra != null) extra, //比如品牌logo
                  if (onTapChevronRight != null)
                    //点击修改
                    Icon(Icons.chevron_right_rounded,
                        color: Styles.c_999999, size: 24.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItemNewAdd({
    required String label,
    VoidCallback? onTapChevronRight,
  }) {
    print("xiaojianjian _buildSettingItemNewAdd ${label}");
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.c_EDEDED, width: 1)),
      ),
      child: Row(
        children: [
          //一个添加的图片
          16.horizontalSpace,
          Expanded(
            child: GestureDetector(
              onTap: onTapChevronRight,
              child: Row(
                children: [label.toText],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Styles.c_F6F6F6,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
        border:
            const Border(bottom: BorderSide(color: Styles.c_EDEDED, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "编辑水印".toText..style = Styles.ts_333333_20_medium,
          widget.resource.id.toString().toText
            ..style = Styles.ts_333333_20_medium,
          GestureDetector(
              onTap: logic.onExit,
              child: Icon(Icons.close_rounded,
                  color: Styles.c_333333, size: 24.w)),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (_pageController.page == 0.0) {
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn);
              }
              if (_pageController.page == 1.0) {
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn);
              }
            },
            child: Container(
              height: 30.w,
              width: 0.3.sw,
              decoration: BoxDecoration(
                  border: Border.all(color: "d9d9d9".hex, width: 1.5.w),
                  borderRadius: BorderRadius.circular(5.w)),
              child: Center(
                child: Text(
                  '水印样式',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          GradientButton(
            height: 35.w,
            width: 0.6.sw,
            borderRadius: BorderRadius.circular(5.w),
            colors: ['76a6ff'.hex, "3965e9".hex],
            tapCallback: logic.onSaveWatermark,
            child: Text(
              '保存水印',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoWidget() {
    // 构建logo
    return GetBuilder<WatermarkProtoLogic>(
        init: logic,
        id: logic.watermarkUpdateId,
        builder: (logic) {
          if (logic.logoData != null &&
              logic.logoData?.isHidden == false &&
              logic.logoData?.logoPositionType != 0) {
            if (logic.logoData != null &&
                logic.logoData?.isHidden == false &&
                logic.logoData?.logoPositionType != 0) {
              if (logic.logoData?.logoPositionType == 0) {
                return const SizedBox();
              }
              if (logic.logoData?.logoPositionType == 1) {
                return Positioned(top: 0, left: 0, child: _LogoWidget());
              }
              if (logic.logoData?.logoPositionType == 2) {
                return Positioned(top: 0, right: 0, child: _LogoWidget());
              }
              if (logic.logoData?.logoPositionType == 3) {
                return Positioned(bottom: 0, left: 0, child: _LogoWidget());
              }
              if (logic.logoData?.logoPositionType == 4) {
                return Positioned(bottom: 0, right: 0, child: _LogoWidget());
              }
              if (logic.logoData?.logoPositionType == 5) {
                return Positioned(
                    top: 0, left: 0, right: 0, bottom: 0, child: _LogoWidget());
              }
            }
          }
          return const SizedBox();
        });
  }
}

class _LogoWidget extends StatelessWidget {
  final logic = Get.find<WatermarkProtoLogic>();

  _LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: ImageUtil.loadNetworkImage(logic.logoData?.content ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(color: Colors.grey[300]);
        }

        // 应用缩放和透明度
        return Opacity(
          opacity: 1,
          child: Transform.scale(
            scale: 1,
            child: snapshot.data!,
          ),
        );
      },
    );
  }
}
