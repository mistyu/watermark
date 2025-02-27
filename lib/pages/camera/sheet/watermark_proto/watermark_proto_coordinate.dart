import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

/**
 * 经纬度
 */
class WatermarkProtoCoordinate extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoCoordinate({super.key, required this.itemMap});

  @override
  State<WatermarkProtoCoordinate> createState() =>
      _WatermarkProtoCoordinateState();
}

class _WatermarkProtoCoordinateState extends State<WatermarkProtoCoordinate> {
  final _locationController = Get.find<LocationController>();
  late PageController _pageController;
  late TextEditingController _editingController;
  String _title = "选择经纬度格式";
  String _actionText = '下一步';
  int _selectedIndex = 0;
  double _boxHeight = 1.sh * 0.4;

  void _nextStep() {
    if (_pageController.page == 1) {
      _onSubmitted();
      return;
    }
    setState(() {
      _title = "经纬度";
      _actionText = "保存";
      _boxHeight = 1.sh * 0.22;
    });
    _editingController.text = _listFormatText[_selectedIndex];
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void _prevStep() {
    setState(() {
      _title = "选择经纬度格式";
      _actionText = "下一步";
      _boxHeight = 1.sh * 0.4;
    });
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void _onSubmitted() {
    final text = _editingController.text;
    Get.back(result: text);
  }

  @override
  void initState() {
    _editingController = TextEditingController();
    _pageController = PageController();
    if (_locationController.locationResult.value == null) {
      Utils.showToast('请先查看是否打开定位权限和打开手机定位服务');
      Get.back();
    }
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  List<String> get _listFormatText {
    // latitude 纬度
    // longitude 经度
    final location = _locationController.locationResult.value;
    final latitude = '${location?.latitude}';
    final longitude = '${location?.longitude}';

    // 将小数格式转换为度分秒格式
    final latDegree = double.parse(latitude).floor();
    final latMinute = ((double.parse(latitude) - latDegree) * 60);
    final latSecond =
        ((double.parse(latitude) - latDegree - (latMinute.floor()) / 60) * 3600)
            .round();

    final lonDegree = double.parse(longitude).floor();
    final lonMinute = ((double.parse(longitude) - lonDegree) * 60);
    final lonSecond =
        ((double.parse(longitude) - lonDegree - (lonMinute.floor()) / 60) *
                3600)
            .round();

    final latDegreeStr = '$latDegree°';
    final lonDegreeStr = '$lonDegree°';
    final latSecondStr = '$latSecond"';
    final lonSecondStr = '$lonSecond"';

    return [
      '${location?.latitude?.toStringAsFixed(6)}°N, ${location?.longitude?.toStringAsFixed(6)}°E',
      '${location?.latitude?.toStringAsFixed(6)}, ${location?.longitude?.toStringAsFixed(6)}',
      "$latDegreeStr${latMinute.toStringAsFixed(6)}', $lonDegreeStr${lonMinute.toStringAsFixed(6)}'",
      "$latDegreeStr${latMinute.toStringAsFixed(2)}'$latSecondStr, $lonDegreeStr${lonMinute.toStringAsFixed(2)}'$lonSecondStr",
      "$latDegreeStr${latMinute.toStringAsFixed(2)}'${latSecondStr}N, $lonDegreeStr${lonMinute.toStringAsFixed(2)}'${lonSecondStr}E",
      "北纬$latDegreeStr${latMinute.floor()}', 东经$lonDegreeStr${lonMinute.floor()}'",
      "北纬$latDegreeStr${latMinute.floor()}'$latSecondStr, 东经$lonDegreeStr${lonMinute.floor()}'$lonSecondStr",
      "$latDegreeStr${latMinute.floor()}'$latSecondStr, $lonDegreeStr${lonMinute.floor()}'$lonSecondStr",
      "$latDegreeStr${latMinute.floor()}'${latSecondStr}N, $lonDegreeStr${lonMinute.floor()}'${lonSecondStr}E",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: _boxHeight +
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
                title: _title,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.r),
                ),
                border: const Border(
                  bottom: BorderSide(color: Styles.c_EDEDED),
                ),
                onTap: () {
                  if (_pageController.page == 1) {
                    _prevStep();
                  } else {
                    Get.back();
                  }
                },
                right: TextButton(
                    onPressed: _nextStep,
                    child: _actionText.toText
                      ..style = Styles.ts_0C8CE9_16_medium),
              ),
              Expanded(
                  child: PageView(
                pageSnapping: false,
                controller: _pageController,
                children: [_buildSelectFormatView(), _buildCustomWeatherView()],
              ))
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomWeatherView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        children: [
          FilledInput(
            controller: _editingController,
            maxLines: 3,
          ),
          "可手动修改经纬度".toText..style = Styles.ts_666666_16_medium
        ],
      ),
    );
  }

  Widget _buildSelectFormatView() {
    return SingleChildScrollView(
        child: Column(
      children: List.generate(_listFormatText.length, (index) {
        return _buildSelectItemView(
            label: _listFormatText[index],
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            });
      }),
    ));
  }

  Widget _buildSelectItemView(
      {required String label, required bool isSelected, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            color: isSelected
                ? Styles.c_0C8CE9.withOpacity(0.05)
                : Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            label.toText
              ..style = isSelected
                  ? Styles.ts_0C8CE9_16_medium
                  : Styles.ts_666666_16_medium,
            Visibility(
                visible: isSelected,
                child: const Icon(Icons.check, color: Styles.c_0C8CE9))
          ],
        ),
      ),
    );
  }
}
