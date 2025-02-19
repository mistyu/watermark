import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

class WatermarkProtoAltitude extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoAltitude({super.key, required this.itemMap});

  @override
  State<WatermarkProtoAltitude> createState() => _WatermarkProtoAltitudeState();
}

class _WatermarkProtoAltitudeState extends State<WatermarkProtoAltitude> {
  final locationController = Get.find<LocationController>();
  late TextEditingController _textEditingController;

  void _onSubmitted() {
    final value = _textEditingController.text;

    Get.back(result: '$value米');
  }

  @override
  void initState() {
    _textEditingController = TextEditingController(
        text:
            locationController.locationResult.value?.altitude.toString() ?? '');
    super.initState();
  }

  @override
  void dispose() {
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
                title: "海拔",
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
              Expanded(child: Padding(padding: EdgeInsets.all(16.w),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: FilledInput(
                          initialValue: "海拔",
                          readOnly: true,
                        ),
                      ),
                      12.horizontalSpace,
                      Flexible(
                        flex: 2,
                        child: FilledInput(
                          controller: _textEditingController,
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          suffix: "米".toText..style = Styles.ts_666666_16_medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),))
            ],
          ),
        );
      },
    );
  }
}
