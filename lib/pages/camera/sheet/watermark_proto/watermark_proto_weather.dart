import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/weatherUtil.dart';
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
  late TextEditingController _windDirectionController;
  late TextEditingController _temperatureController;
  String _title = "天气";
  int _selectedWeatherIconIndex = 0; // 默认选中晴天图标
  String _weatherText = "";
  late List<Map<String, dynamic>> _weatherIcons =
      _locationController.weatherIcons;
  String symbol = "℃";

  get showWeatherIcon =>
      widget.itemMap.templateId == 1698317868899 ||
      widget.itemMap.templateId == 1698049354422;

  get templateId => widget.itemMap.templateId;

  void _onSubmitted() {
    final text = _generateWeatherText();
    Get.back(result: text);
  }

  WatermarkDataItemMap _generateWeatherText() {
    // 使用图标路径而不是emoji
    String weatherIcon = _weatherIcons[_selectedWeatherIconIndex]["icon"];

    String windDirection = _windDirectionController.text.trim();
    String temperature = _temperatureController.text.trim();
    String content = "$temperature$symbol $windDirection";
    if (!showWeatherIcon) {
      content = "$windDirection $temperature$symbol";
    }
    widget.itemMap.data.content = content;
    widget.itemMap.data.image = weatherIcon;
    return widget.itemMap;
  }

  void _refreshWeather() {
    Utils.showLoading("获取天气中...");

    // 模拟获取天气数据的延迟
    Future.delayed(const Duration(seconds: 1), () {
      final weather = _locationController.weather.value;
      if (weather != null) {
        _windDirectionController.text = weather.winddirection ?? "西风";
        _temperatureController.text = weather.temperature ?? '28~30';

        // 根据天气类型选择对应的图标
        String weatherType = weather.weather ?? "";
        if (weatherType.contains("晴")) {
          _selectedWeatherIconIndex = 0;
        } else if (weatherType.contains("雪")) {
          _selectedWeatherIconIndex = 1;
        } else if (weatherType.contains("阴")) {
          _selectedWeatherIconIndex = 2;
        } else if (weatherType.contains("雾")) {
          _selectedWeatherIconIndex = 3;
        } else if (weatherType.contains("雨")) {
          _selectedWeatherIconIndex = 4;
        }
      } else {
        _windDirectionController.text = "西风";
        _temperatureController.text = "28~30";
      }

      setState(() {
        _generateWeatherText();
      });

      Utils.dismissLoading();
    });
  }

  @override
  void initState() {
    // 初始化风向和温度
    _windDirectionController = TextEditingController(text: "西风");
    _temperatureController = TextEditingController(text: "28~30");

    // 初始化天气文本 --- 调用api
    if (!showWeatherIcon) {
      _windDirectionController = TextEditingController(text: "多云");
      _temperatureController = TextEditingController(text: "28");
    }
    // _weatherText = _generateWeatherText();

    super.initState();
  }

  @override
  void dispose() {
    _windDirectionController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    symbol = WeatherUtils.getSymbol(templateId);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 480.h +
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
                right: TextButton(
                  onPressed: _onSubmitted,
                  child: Text(
                    "保存",
                    style: Styles.ts_0C8CE9_16_medium,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 风向输入框
                        Text(
                          "风向",
                          style: Styles.ts_333333_14_medium,
                        ),
                        8.verticalSpace,
                        FilledInput(
                          controller: _windDirectionController,
                          hintText: "请输入风向，如：西风",
                          onChanged: (value) {
                            setState(() {
                              _generateWeatherText();
                            });
                          },
                        ),
                        16.verticalSpace,

                        // 温度输入框
                        Text(
                          "温度",
                          style: Styles.ts_333333_14_medium,
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                                child: FilledInput(
                              controller: _temperatureController,
                              hintText: "请输入温度，如：28~30",
                              onChanged: (value) {
                                setState(() {
                                  _generateWeatherText();
                                });
                              },
                            )),
                            Text(
                              symbol,
                              style: Styles.ts_333333_14_medium,
                            )
                          ],
                        ),

                        16.verticalSpace,

                        // 天气图标选择 --- 只有特定的templateId 才有这个选项
                        if (showWeatherIcon)
                          Text(
                            "天气图标",
                            style: Styles.ts_333333_14_medium,
                          ),
                        if (showWeatherIcon) _buildWeatherIconGrid(),

                        // 天气会自动生成提示
                        Text(
                          "天气会自动生成，您可手动修改",
                          style: Styles.ts_666666_14_medium,
                        ),
                        8.verticalSpace,

                        // 重新获取按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _refreshWeather,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.c_0C8CE9,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "重新获取",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        40.verticalSpace, // 底部留白
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherIconGrid() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero, // 移除GridView的默认内边距
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 2.5,
        ),
        itemCount: _weatherIcons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeatherIconIndex = index;
                _generateWeatherText();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedWeatherIconIndex == index
                    ? Styles.c_0C8CE9.withOpacity(0.1)
                    : Styles.c_F6F6F6,
                borderRadius: BorderRadius.circular(8.r),
                border: _selectedWeatherIconIndex == index
                    ? Border.all(color: Styles.c_0C8CE9, width: 1)
                    : null,
              ),
              child: Center(
                child: _weatherIcons[index]["icon"] == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            size: 16.sp,
                            color: Styles.c_666666,
                          ),
                          4.horizontalSpace,
                          Text(
                            "关闭图标",
                            style: Styles.ts_666666_12_medium,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _weatherIcons[index]["icon"],
                            width: 20.w,
                            height: 20.w,
                          ),
                          8.horizontalSpace,
                          Text(
                            _weatherIcons[index]["name"],
                            style: Styles.ts_666666_12_medium,
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
