import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

class WatermarkProtoWeather extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoWeather({super.key, required this.itemMap});

  @override
  State<WatermarkProtoWeather> createState() => _WatermarkProtoWeatherState();
}

class _WatermarkProtoWeatherState extends State<WatermarkProtoWeather> {
  final _locationController = Get.find<LocationController>();
  late PageController _pageController;
  late TextEditingController _editingController;
  String _title = "选择天气格式";
  String _actionText = '下一步';
  int _selectedIndex = 0;
  double _boxHeight = 1.sh * 0.4;

  void _nextStep() {
    if (_pageController.page == 1) {
      _onSubmitted();
      return;
    }
    setState(() {
      _title = "天气";
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
      _title = "选择天气格式";
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
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _listFormatText {
    final weather = _locationController.weather.value;
    final tianqi = '${weather?.weather}';
    final temperature = '${weather?.temperature}℃';
    final winddirection = '${weather?.winddirection}风';
    final windpower = '${weather?.windpower}级';
    final humidity = '${weather?.humidity}%';
    return [
      '$tianqi $temperature',
      temperature,
      tianqi,
      '$tianqi $temperature $winddirection',
      '$tianqi $temperature $winddirection $windpower',
      '$tianqi $temperature $humidity',
      '$tianqi $temperature $winddirection $windpower $humidity',
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
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      child: Column(
        children: [
          FilledInput(
            controller: _editingController,
            maxLines: 3,
          ),
          8.verticalSpace,
          "可手动修改天气".toText..style = Styles.ts_666666_16_medium
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
