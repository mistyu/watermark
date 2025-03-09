import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

import '../../../../widgets/title_bar.dart';

class WatermarkProtoShape extends StatefulWidget {
  final List<String> shapeTypeList; // 形状图片的映射名称列表
  final WatermarkDataItemMap itemMap;

  const WatermarkProtoShape({
    super.key,
    required this.shapeTypeList,
    required this.itemMap,
  });

  @override
  State<WatermarkProtoShape> createState() => _WatermarkProtoShapeState();
}

class _WatermarkProtoShapeState extends State<WatermarkProtoShape> {
  String? _selectedShape; // 当前选中的形状
  List<String>? _imgPathList;

  void _onSubmitted() {
    Get.back(result: _selectedShape); // 返回选中的形状
  }

  @override
  void initState() {
    super.initState();
    _imgPathList = widget.itemMap.data?.background?.split(';');

    _selectedShape = _imgPathList?.first;

    if (Utils.isNotNullEmptyStr(widget.itemMap.data?.content)) {
      _selectedShape = widget.itemMap.data?.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h, // 固定高度
      // padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        children: [
          // 标题栏
          TitleBar.back(
            backgroundColor: Styles.c_F6F6F6,
            primary: false,
            title: "选择形状",
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8.r),
            ),
            border: const Border(
              bottom: BorderSide(color: Styles.c_EDEDED),
            ),
            right: TextButton(
              onPressed: () {
                if (_selectedShape != null) {
                  _onSubmitted();
                }
              },
              child: "保存".toText..style = Styles.ts_0C8CE9_16_medium,
            ),
          ),
          SizedBox(height: 10.h),
          // 水平滚动的形状列表
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              height: 100.h, // 限制 ListView 的高度
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // 水平滚动
                itemCount: _imgPathList?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildShapeItem(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeItem(int index) {
    final shapePath = _imgPathList?[index];
    final shapeName = widget.shapeTypeList[index];
    final isSelected = _selectedShape == shapePath; // 判断是否选中

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShape = shapePath; // 更新选中的形状
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: 100.w, // 设置固定宽度
        decoration: BoxDecoration(
          color: isSelected ? Styles.c_0C8CE9.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Styles.c_0C8CE9 : Styles.c_EDEDED,
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 形状图片
            SizedBox(
              height: 60.h, // 限制图片容器的高度
              child: _buildShapeImageItem(shapePath ?? ''),
            ),
            SizedBox(height: 5.h),
            // 形状名称
            Text(
              shapeName,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected
                    ? Styles.c_0481DC // 选中状态
                    : Styles.c_333333,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeImageItem(String shapePath) {
    return FutureBuilder(
      future: WatermarkService.getImagePath(
          widget.itemMap.templateId.toString(),
          fileName: shapePath),
      builder: (context, snapshot) {
        return SizedBox(
          height: 60.h, // 限制图片高度
          width: 60.w, // 限制图片宽度
          child: WatermarkFrameBox(
            watermarkId: widget.itemMap.templateId,
            frame: WatermarkFrame(width: 60.w, height: 60.h),
            imagePath: snapshot.data,
          ),
        );
      },
    );
  }
}
