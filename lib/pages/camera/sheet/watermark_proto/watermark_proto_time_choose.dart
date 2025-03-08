import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/custom_cupertino_localizations.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/title_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DatePickerTimeChoose extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const DatePickerTimeChoose({super.key, required this.itemMap});

  @override
  State<DatePickerTimeChoose> createState() => _DatePickerTimeChooseState();
}

class _DatePickerTimeChooseState extends State<DatePickerTimeChoose> {
  late DateTime selectedDate;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    yearController = FixedExtentScrollController(
        initialItem: selectedDate.year - 2000); // 2000年开始
    monthController =
        FixedExtentScrollController(initialItem: selectedDate.month - 1);
    dayController =
        FixedExtentScrollController(initialItem: selectedDate.day - 1);
    hourController =
        FixedExtentScrollController(initialItem: selectedDate.hour);
    minuteController =
        FixedExtentScrollController(initialItem: selectedDate.minute);
    secondController =
        FixedExtentScrollController(initialItem: selectedDate.second);
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    final result =
        formatDate(selectedDate, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    Get.back(result: result);
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required Function(int) onSelectedItemChanged,
    required int flex,
  }) {
    return Expanded(
      flex: flex,
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 32.h,
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map((item) {
          return Center(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 16.sp,
                color: Styles.c_0D0D0D,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        height: 400.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Column(
          children: [
            TitleBar.back(
              backgroundColor: Colors.white,
              primary: false,
              title: "选择时间",
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
              ),
              border: const Border(
                bottom: BorderSide(color: Styles.c_EDEDED),
              ),
              right: TextButton(
                onPressed: _onSubmitted,
                child: Text(
                  "确定",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Styles.c_0C8CE9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // 年份选择器
                  _buildPicker(
                    controller: yearController,
                    items: List.generate(
                        100, (index) => '${(2000 + index).toString()}年'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          2000 + index,
                          selectedDate.month,
                          selectedDate.day,
                          selectedDate.hour,
                          selectedDate.minute,
                          selectedDate.second,
                        );
                      });
                    },
                    flex: 2,
                  ),
                  // 月份选择器
                  _buildPicker(
                    controller: monthController,
                    items: List.generate(
                        12,
                        (index) =>
                            '${(index + 1).toString().padLeft(2, '0')}月'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          index + 1,
                          selectedDate.day,
                          selectedDate.hour,
                          selectedDate.minute,
                          selectedDate.second,
                        );
                      });
                    },
                    flex: 2,
                  ),
                  // 日期选择器
                  _buildPicker(
                    controller: dayController,
                    items: List.generate(
                        31,
                        (index) =>
                            '${(index + 1).toString().padLeft(2, '0')}日'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          index + 1,
                          selectedDate.hour,
                          selectedDate.minute,
                          selectedDate.second,
                        );
                      });
                    },
                    flex: 2,
                  ),
                  // 小时选择器
                  _buildPicker(
                    controller: hourController,
                    items: List.generate(
                        24, (index) => '${index.toString().padLeft(2, '0')}时'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          index,
                          selectedDate.minute,
                          selectedDate.second,
                        );
                      });
                    },
                    flex: 2,
                  ),
                  // 分钟选择器
                  _buildPicker(
                    controller: minuteController,
                    items: List.generate(
                        60, (index) => '${index.toString().padLeft(2, '0')}分'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedDate.hour,
                          index,
                          selectedDate.second,
                        );
                      });
                    },
                    flex: 2,
                  ),
                  // 秒数选择器
                  _buildPicker(
                    controller: secondController,
                    items: List.generate(
                        60, (index) => '${index.toString().padLeft(2, '0')}秒'),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedDate.hour,
                          selectedDate.minute,
                          index,
                        );
                      });
                    },
                    flex: 2,
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
