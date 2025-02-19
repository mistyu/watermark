import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_logic.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

class WatermarkProtoColor extends StatefulWidget {
  const WatermarkProtoColor({super.key});

  @override
  State<WatermarkProtoColor> createState() => _WatermarkProtoColorState();
}

class _WatermarkProtoColorState extends State<WatermarkProtoColor> {
  final logic = Get.find<StyleEditLogic>();
  List<Color> colorHistory = [];
  void changeColorHistory(List<Color> colors) => colorHistory = colors;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 0.5.sh +
            context.mediaQueryPadding.bottom +
            (isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r))),
        child: Obx(() {
          return Column(
            children: [
              TitleBar.back(
                backgroundColor: Styles.c_F6F6F6,
                primary: false,
                title: "调色板",
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.r),
                ),
                border: const Border(
                  bottom: BorderSide(color: Styles.c_EDEDED),
                ),
                right: TextButton(
                    onPressed: logic.onSubmittedColor,
                    child: "保存".toText..style = Styles.ts_0C8CE9_16_medium),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: logic.pickerColor.value,
                    onColorChanged: logic.changeColor,
                    // colorPickerWidth: 200,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: true,
                    labelTypes: const [
                      ColorLabelType.hsl,
                      ColorLabelType.hsv,
                      ColorLabelType.hex,
                      ColorLabelType.rgb
                    ],
                    displayThumbColor: true,
                    paletteType: PaletteType.hueWheel,
                    // pickerAreaBorderRadius: const BorderRadius.only(
                    //     topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                    hexInputBar: true,
                    colorHistory: colorHistory,
                    onHistoryChanged: changeColorHistory,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }
}
