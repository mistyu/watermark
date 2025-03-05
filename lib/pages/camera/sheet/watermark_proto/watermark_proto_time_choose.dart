import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:date_format/date_format.dart';

import '../../../../widgets/title_bar.dart';

class DatePickerTimeChoose extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const DatePickerTimeChoose({super.key, required this.itemMap});

  @override
  State<DatePickerTimeChoose> createState() => _DatePickerTimeChooseState();
}

class _DatePickerTimeChooseState extends State<DatePickerTimeChoose> {
  DateTime selectedDate = DateTime.now();

  void _onSubmitted() {
    final result =
        formatDate(selectedDate, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    print("xiaojianjian 选择的时间: $result");
    Get.back(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 400.h + // 增加高度以适应两个选择器
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
              child: Row(
                children: [
                  // 年月日选择器
                  Expanded(
                    flex: 2, // 增加日期选择器的宽度
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          selectedDate = DateTime(
                            newDate.year,
                            newDate.month,
                            newDate.day,
                            selectedDate.hour,
                            selectedDate.minute,
                          );
                        });
                      },
                      use24hFormat: true,
                      itemExtent: 40, // 增加每一项的高度
                    ),
                  ),
                  // 小时分钟选择器
                  Expanded(
                    flex: 1, // 时间选择器的宽度
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            newTime.hour,
                            newTime.minute,
                          );
                        });
                      },
                      use24hFormat: true,
                      minuteInterval: 1,
                      itemExtent: 40, // 增加每一项的高度
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
