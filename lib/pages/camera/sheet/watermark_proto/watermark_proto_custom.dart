import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

class WatermarkProtoCustom1 extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoCustom1({super.key, required this.itemMap});

  @override
  State<WatermarkProtoCustom1> createState() => _WatermarkProtoCustom1State();
}

class _WatermarkProtoCustom1State extends State<WatermarkProtoCustom1> {
  final locationController = Get.find<LocationController>();
  late TextEditingController _textEditingController;
  late TextEditingController _titleEditingController;
  late String protoTitle;

  void _onSubmitted() {
    final value = _textEditingController.text;
    Get.back(result: value);
  }

  @override
  void initState() {
    protoTitle = widget.itemMap.title ?? '自定义';
    String itemContent = widget.itemMap.data.content ?? '';
    _titleEditingController = TextEditingController(text: protoTitle);
    _textEditingController = TextEditingController(text: itemContent);
    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 128.h +
              context.mediaQueryPadding.bottom +
              (isKeyboardVisible
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0),
          width: double.infinity,
          padding: EdgeInsets.only(
              bottom: context.mediaQueryPadding.bottom +
                  (isKeyboardVisible
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0)),
          decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r))),
          child: Column(
            children: [
              TitleBar.back(
                backgroundColor: Styles.c_F6F6F6,
                primary: false,
                title: protoTitle,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.r),
                ),
                border: const Border(
                  bottom: BorderSide(color: Styles.c_EDEDED),
                ),
                right: TextButton(
                    onPressed: _onSubmitted,
                    child: "保存".toText..style = Styles.ts_0C8CE9_16_medium),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        //字段名
                        Flexible(
                          child: FilledInput(
                            controller: _titleEditingController,
                            enableInteractiveSelection: false,
                            readOnly: widget.itemMap.data.isEditTitle == false,
                            maxLines: 1,
                            scrollPhysics: const ClampingScrollPhysics(),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        12.horizontalSpace,
                        //输入框
                        Flexible(
                          flex: 2,
                          child: FilledInput(
                            controller: _textEditingController,
                            enableInteractiveSelection: false,
                            maxLines: 1,
                            scrollPhysics: const ClampingScrollPhysics(),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
    );
  }
}
