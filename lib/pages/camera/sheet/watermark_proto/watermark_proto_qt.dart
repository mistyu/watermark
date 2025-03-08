import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart'; // 引入二维码生成插件
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
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
  bool _isQrCode1Selected = true; // 导航二维码是否选中
  bool _isQrCode2Selected = false; // 整改二维码是否选中
  final TextEditingController _senderController = TextEditingController();
  String _selectedDate = ''; // 使用字符串存储选择的日期

  @override
  void initState() {
    super.initState();
    // 设置默认时间
    _selectedDate = '发起日期：${DateTime.now().toString().substring(0, 16)}';
  }

  @override
  void dispose() {
    _senderController.dispose();
    super.dispose();
  }

  // 添加时间选择方法
  Future<void> _showDatePicker() async {
    final result = await WatermarkDialog.showWatermarkProtoTimeChooseDialog(
        itemMap: widget.itemMap);
    print('xiaojianjian result: $result');
    if (result != null) {
      setState(() {
        _selectedDate = '发起日期：$result';
      });
    }
  }

  void _onSubmitted() {
    //最后还是返回一个content类似http中的get请求，type=1&sender=1234567890&sendTime=2025-03-08 17:14:32&qr1=https://www.example.com/qr1&qr2=https://www.example.com/qr2
    /**
     * type: 1 / 2 / 3 1表示导航二维码，2表示整改二维码，3表示两个都选
     */
    if (Utils.isNullEmptyStr(_senderController.text)) {
      _senderController.text = '墨水年华';
    }

    String result =
        'type=1&sender=${_senderController.text}&sendTime=$_selectedDate';
    if (_isQrCode2Selected) {
      result =
          'type=2&sender=${_senderController.text}&sendTime=$_selectedDate';
    }
    if (_isQrCode1Selected && _isQrCode2Selected) {
      result =
          'type=3&sender=${_senderController.text}&sendTime=$_selectedDate';
    }
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
                    icon: Icon(Icons.arrow_downward, size: 20.w),
                    onPressed: () {
                      Get.back();
                    },
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
                    hintText: '发起人：墨水年华',
                  ),
                  8.verticalSpace,
                  // 修改日期选择器
                  GestureDetector(
                    onTap: _showDatePicker,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Styles.c_F6F6F6,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _selectedDate,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Styles.c_0D0D0D,
                        ),
                      ),
                    ),
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
