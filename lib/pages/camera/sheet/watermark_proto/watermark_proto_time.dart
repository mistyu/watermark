import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

/// 修改水印点击时间的弹出
class WatermarkProtoTime extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoTime({super.key, required this.itemMap});

  @override
  State<WatermarkProtoTime> createState() => _WatermarkProtoTimeState();
}

class _WatermarkProtoTimeState extends State<WatermarkProtoTime> {
  late TextEditingController _textEditingController;
  String get _inputTitleValue => widget.itemMap.data.title ?? '时间';
  String get _hintText => formatDate(DateTime.now(), watermarkTimeFormat);

  MaskTextInputFormatter get dateFormatter => MaskTextInputFormatter(
        mask: '####-##-## ##:##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );

  void _onSubmitted() {
    final value = _textEditingController.text;
    DateTime? datetime = DateTime.now();
    if (Utils.isNotNullEmptyStr(value)) {
      datetime = DateTime.tryParse(value);
    }
    if (datetime == null) {
      ToastUtil.show("填写时间不合法！");
      return;
    }

    final result = formatDate(datetime, watermarkTimeFormat);
    Get.back(result: result);
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("xiaojianjian WatermarkProtoTime build");
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 128.h +
            context.mediaQueryPadding.bottom +
            (isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0),
        width: double.infinity,
        padding: EdgeInsets.only(
            bottom: context.mediaQueryPadding.bottom +
                (isKeyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 0)),
        decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r))),
        child: Column(
          children: [
            TitleBar.back(
              backgroundColor: Styles.c_F6F6F6,
              primary: false,
              title: "时间",
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
                        Flexible(
                          child: FilledInput(
                            initialValue: _inputTitleValue,
                            readOnly: true,
                          ),
                        ),
                        12.horizontalSpace,
                        Flexible(
                          flex: 2,
                          child: FilledInput(
                            controller: _textEditingController,
                            hintText: _hintText,
                            enableInteractiveSelection: false,
                            inputFormatters: [
                              dateFormatter,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
