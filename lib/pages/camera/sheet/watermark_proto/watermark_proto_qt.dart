import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart'; // 引入二维码生成插件
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/filled_input.dart';

/**
 * 提供两个二维码选择，可以两个都选择，也可以只选择一个
 */
class WatermarkProtoQrCode extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkProtoQrCode({super.key, required this.itemMap});

  @override
  State<WatermarkProtoQrCode> createState() => _WatermarkProtoQrCodeState();
}

class _WatermarkProtoQrCodeState extends State<WatermarkProtoQrCode> {
  bool _isQrCode1Selected = false; // 导航二维码是否选中
  bool _isQrCode2Selected = false; // 整改二维码是否选中
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = '2025.03.01 14:28'; // 设置默认时间
  }

  @override
  void dispose() {
    _senderController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    if (_senderController.text.isEmpty) {
      Utils.showToast('请输入发起人');
      return;
    }

    final result = {
      'sender': _senderController.text,
      'date': _dateController.text,
      'qr1': _isQrCode1Selected ? 'https://www.example.com/qr1' : null,
      'qr2': _isQrCode2Selected ? 'https://www.example.com/qr2' : null,
    };
    Get.back(result: result);
  }

  Widget _buildQrCodeItem({
    required bool isSelected,
    required String title,
    required VoidCallback onTap,
    required String qrData,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? Styles.c_0C8CE9.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Styles.c_0C8CE9 : Styles.c_EDEDED,
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            QrImageView(
              data: qrData,
              size: 120.w,
              backgroundColor: Colors.white,
            ),
            8.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Styles.c_0D0D0D,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '请选择二维码类型',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Styles.c_0D0D0D,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, size: 20.w),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 输入区域
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  FilledInput(
                    controller: _senderController,
                    hintText: '发起人',
                  ),
                  8.verticalSpace,
                  FilledInput(
                    controller: _dateController,
                    hintText: '发起日期',
                    readOnly: true,
                  ),
                ],
              ),
            ),
            16.verticalSpace,

            // 二维码选择区域
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQrCodeItem(
                    isSelected: _isQrCode1Selected,
                    title: '导航二维码',
                    onTap: () => setState(
                        () => _isQrCode1Selected = !_isQrCode1Selected),
                    qrData: 'https://www.example.com/qr1',
                  ),
                  _buildQrCodeItem(
                    isSelected: _isQrCode2Selected,
                    title: '整改二维码',
                    onTap: () => setState(
                        () => _isQrCode2Selected = !_isQrCode2Selected),
                    qrData: 'https://www.example.com/qr2',
                  ),
                ],
              ),
            ),
            16.verticalSpace,

            // 底部按钮
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: ElevatedButton(
                onPressed: _onSubmitted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.c_0C8CE9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  '开启二维码',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).padding.bottom.verticalSpace,
          ],
        ),
      );
    });
  }
}
