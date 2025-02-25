import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/library.dart';

class FilledInput extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String?)? onSubmitted;
  final bool? autofocus;
  final bool? enabled;
  final bool? readOnly;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableInteractiveSelection;
  final int? maxLength;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? suffix;
  final ScrollPhysics? scrollPhysics;
  final TextInputAction? textInputAction;

  const FilledInput({
    Key? key,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.autofocus,
    this.enabled,
    this.readOnly,
    this.obscureText,
    this.keyboardType,
    this.initialValue,
    this.inputFormatters,
    this.enableInteractiveSelection,
    this.maxLength,
    this.maxLines,
    this.suffix,
    this.suffixIcon,
    this.scrollPhysics,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius == null
            ? BorderRadius.circular(8.r)
            : BorderRadius.circular(borderRadius!),
        color: Styles.c_F6F6F6,
      ),
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        onSaved: onSubmitted,
        autofocus: autofocus ?? false,
        enabled: enabled ?? true,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        maxLines: maxLines,
        enableInteractiveSelection: enableInteractiveSelection ?? true,
        scrollPhysics: scrollPhysics,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            filled: true,
            fillColor: Styles.c_F6F6F6,
            hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                  color: Styles.c_999999,
                  fontSize: 14.sp,
                ),
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none, // 移除默认边框
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Styles.c_0C8CE9,
                width: 2.w,
              ),
            ),
            suffix: suffix,
            suffixIcon: suffixIcon),
      ),
    );
  }
}
