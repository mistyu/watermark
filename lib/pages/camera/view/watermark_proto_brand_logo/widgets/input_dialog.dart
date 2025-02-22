import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/library.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final VoidCallback onCancel;
  final Function(String) onConfirm;

  const InputDialog({
    Key? key,
    required this.title,
    required this.hintText,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Styles.c_0D0D0D,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Styles.c_999999,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Styles.c_EDEDED,
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Styles.c_EDEDED,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Styles.c_0C8CE9,
                      width: 1.w,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Styles.c_0D0D0D,
                ),
              ),
            ),
            Divider(height: 1.h, color: Styles.c_EDEDED),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Styles.c_999999,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1.w, color: Styles.c_EDEDED),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty) {
                        Utils.showToast('请输入Logo名称');
                        return;
                      }
                      widget.onConfirm(text);
                    },
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      child: Text(
                        '确定',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Styles.c_0C8CE9,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
