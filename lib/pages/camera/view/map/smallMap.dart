import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const SmallMap({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    BMFMapOptions options = BMFMapOptions(
      center: BMFCoordinate(latitude, longitude),
      zoomLevel: 15,
      mapType: BMFMapType.Standard,
      scrollEnabled: false,
      zoomEnabled: false,
      rotateEnabled: false,
      showMapScaleBar: false,
      showZoomControl: false,
    );
    return Container(
      width: 78.w,
      height: 78.h,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: OverflowBox(
          maxWidth: 78.w * 1.5, // 超出 Container 的宽度
          maxHeight: 78.h * 1.5, // 超出 Container 的高度
          alignment: Alignment.center, // 居中显示
          child: ClipRect(
            child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                // 地图创建后的回调
                BMFMarker marker = BMFMarker(
                  position: BMFCoordinate(latitude, longitude), // 标记位置
                  icon: 'assets/images/location_icon.png', // 标记图标
                  title: '我的位置',
                );
                controller.addMarker(marker);
                controller.setCenterCoordinate(
                  BMFCoordinate(latitude, longitude), // 目标位置的经纬度
                  true, // 是否以动画方式移动
                );
              },
              mapOptions: options,
            ),
          ),
        ),
      ),
    );
  }
}
