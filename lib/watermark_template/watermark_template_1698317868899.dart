import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class WatermarkTemplate1698317868899 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate1698317868899({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;

  // 获取各类型数据
  WatermarkData? _getDataByType(String type) {
    return watermarkView.data?.firstWhereOrNull((data) => data.type == type);
  }

  Widget _buildWatermarkItem(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取所有需要显示的数据
    final phoneData = _getDataByType('YWatermarkGeneralPhone');
    final coordinateData = _getDataByType('YWatermarkGeneralLongitude'); //精度维度
    final latitudeData = _getDataByType('YWatermarkGeneralLatitude');
    final locationData = _getDataByType('YWatermarkGeneralLocation'); //地址
    final timeData = _getDataByType('YWatermarkGeneralTime'); //时间
    final altitudeData = _getDataByType('YWatermarkGeneralAltitude'); //海拔
    final weatherData = _getDataByType('YWatermarkGeneralWeather'); //天气
    final imeiData = _getDataByType('YWatermarkGeneralIMEI');
    final markData = _getDataByType('YWatermarkGeneralMark');
    final classifyData = _getDataByType('YWatermarkGeneralClassify');
    //自定义是可以多行，用户设置tittle + content就可以
    final customData = _getDataByType('YWatermarkGeneralCustom');

    for (var data in watermarkView?.data ?? []) {
      print(
          "xiaojianjian  真实数据${data.title} ${data.content} ${data.type} ${data.isHidden} ${data.frame}");
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (phoneData != null)
            _buildWatermarkItem(
                '${phoneData.title}: ', phoneData.content ?? ''),
          if (coordinateData != null)
            _buildWatermarkItem('${coordinateData.title}: ',
                coordinateData.content?.split(',')[0] ?? ''),
          if (coordinateData != null)
            _buildWatermarkItem('${coordinateData.title}: ',
                coordinateData.content?.split(',')[1] ?? ''),
          if (locationData != null)
            _buildWatermarkItem(
                '${locationData.title}: ', locationData.content ?? ''),
          if (timeData != null)
            _buildWatermarkItem('${timeData.title}: ', timeData.content ?? ''),
          if (altitudeData != null)
            _buildWatermarkItem(
                '${altitudeData.title}: ', '${altitudeData.content}米'),
          if (weatherData != null)
            _buildWatermarkItem(
                '${weatherData.title}: ', weatherData.content ?? ''),
          if (imeiData != null)
            _buildWatermarkItem('${imeiData.title}: ', imeiData.content ?? ''),
          if (markData != null)
            _buildWatermarkItem('${markData.title}: ', markData.content ?? ''),
          if (classifyData != null)
            _buildWatermarkItem(
                '${classifyData.title}: ', classifyData.content ?? ''),
          if (customData != null)
            _buildWatermarkItem(
                '${customData.title}: ', customData.content ?? ''),
        ]
            .map((widget) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: widget,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildWatermarkBox(WatermarkData? data, Widget child) {
    return Visibility(
      visible: !(data?.isHidden == true),
      child: WatermarkFrameBox(
        watermarkId: watermarkId,
        frame: data?.frame,
        style: data?.style,
        watermarkData: data,
        child: child,
      ),
    );
  }
}
