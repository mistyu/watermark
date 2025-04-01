import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class RyWatermarkLocationBoxNew extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RyWatermarkLocationBoxNew({
    super.key,
    required this.watermarkData,
    required this.resource,
  });

  int get watermarkId => resource.id ?? 0;

  String getAddressText(String? fullAddress) {
    // 检查自定义内容
    if (Utils.isNotNullEmptyStr(watermarkData.content)) {
      return watermarkData.content!;
    }

    // 检查地址是否有效
    if (Utils.isNotNullEmptyStr(fullAddress) &&
        !fullAddress!.contains("null")) {
      return fullAddress;
    }

    // 默认返回
    return '中国地址位置定位中';
  }

  @override
  Widget build(BuildContext context) {
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;
    // print(
    //     "xiaojianjian RyWatermarkLocationBoxNew watermarkData.content ${watermarkData.content}");
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];

    final signLine = watermarkData.signLine;

    return GetBuilder<LocationController>(builder: (logic) {
      return Stack(
          // alignment: Alignment.centerLeft,
          children: [
            WatermarkFrameBox(
              frame: dataFrame,
              style: dataStyle,
              signLine: signLine,
              watermarkData: watermarkData,
              watermarkId: watermarkId,
              child: FutureBuilder<String>(
                  future: logic.getDetailAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("xiaojianjian snapshot.data: ${snapshot.data}");
                      String addressText =
                          logic.getFormatAddress(watermarkId) ?? '';
                      addressText = getAddressText(addressText);
                      print("xiaojianjian addressText: $addressText");
                      watermarkData.content = addressText;

                      String textContent = watermarkData.title ?? '';
                      textContent += "：";
                      if (watermarkId == 1698049556633) {
                        textContent = "";
                      }
                      textContent += watermarkData.content ?? '';
                      return WatermarkFontBox(
                        text: textContent,
                        textStyle: dataStyle,
                        isSingleLine: watermarkId == 1698049556633,
                        font: font,
                        isBold: watermarkId == 16982153599582,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
            ),
          ]);
    });
  }
}
