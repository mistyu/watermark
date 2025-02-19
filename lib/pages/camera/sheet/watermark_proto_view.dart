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
        Obx(() => Container(
              height: 1.sh * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r)),
                  color: Styles.c_FFFFFF),
              child: Column(
                children: [_buildHeader(), _buildContent(), _bottomButtons()],
              ),
            ))
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(
        child: PageView(
      pageSnapping: false,
      controller: _pageController,
      children: [
        _editWatermarkContent(),
        // Text("data"),
        // _editWatermarkStyle(),
        StyleEdit(),
      ],
    ));
  }

  Widget _editWatermarkContent() {
    return SingleChildScrollView(
      child: Column(
        children: logic.watermarkItems
            .map((e) => _buildSettingItem(
                label: Utils.isNotNullEmptyStr(logic.getContent(item: e))
                    ? '${e.title}：'
                    : e.title ?? '',
                extra: logic.getExtraContent(item: e),
                content: logic.getContent(item: e),
                value: !Utils.isNotNullBoolean(e.data.isHidden),
                onChanged: (value) => logic.onChangeSwitch(value, item: e),
                disableSwitch: logic.getDisableSwitch(item: e),
                onTapChevronRight: () => logic.onTapChevronRight(item: e)))
            .toList(),
      ),
    );
  }

  Widget _buildSettingItem({
    required String label,
    required bool value,
    Widget? extra,
    String? content,
    bool disableSwitch = false,
    required Function(bool) onChanged,
    VoidCallback? onTapChevronRight,
  }) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.c_EDEDED, width: 1)),
      ),
      child: Row(
        children: [
          IgnorePointer(
              ignoring: disableSwitch,
              child: Opacity(
                  opacity: disableSwitch ? 0.55 : 1,
                  child: Switch(value: value, onChanged: onChanged))),
          16.horizontalSpace,
          label.toText
            ..style = value ? Styles.ts_333333_16 : Styles.ts_666666_16,
          if (content != null)
            Expanded(
              child: content.toText
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis
                ..style = value ? Styles.ts_333333_16 : Styles.ts_666666_16,
            ),
          if (extra != null) extra,
          if (onTapChevronRight != null)
            GestureDetector(
                onTap: onTapChevronRight,
                child: Icon(Icons.chevron_right_rounded,
                    color: Styles.c_999999, size: 24.w)),
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
          widget.resource.id.toString().toText..style = Styles.ts_333333_20_medium,
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
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
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
              height: 35.w,
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
}
