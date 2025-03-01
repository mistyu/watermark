// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

class Styles {
  Styles._();

  static const Color c_7EAB1D = Color(0xFF7EAB1D);
  static const Color c_7FA91F = Color(0xFF7FA91F);
  static const Color c_A8ABB0 = Color(0xFFA8ABB0);
  static const Color c_0C8CE9 = Color(0xFF0C8CE9);
  static const Color c_0481DC = Color(0xFF0481DC);
  static const Color c_1ED386 = Color(0xFF1ED386);
  static const Color c_DE473E = Color(0xFFDE473E);
  static const Color c_F55545 = Color(0xFFF55545);
  static const Color c_CFAC74 = Color(0xFFCFAC74);
  static const Color c_FFFFFF = Color(0xFFFFFFFF);
  static const Color c_F1F1F1 = Color(0xFFF1F1F1);
  static const Color c_0D0D0D = Color(0xFF0D0D0D);
  static const Color c_161616 = Color(0xFF161616);
  static const Color c_1B1B1B = Color(0xFF1B1B1B);
  static const Color c_121212 = Color(0xFF121212);
  static const Color c_222222 = Color(0xFF222222);
  static const Color c_333333 = Color(0xFF333333);
  static const Color c_555555 = Color(0xFF555555);
  static const Color c_666666 = Color(0xFF666666);
  static const Color c_777777 = Color(0xFF777777);
  static const Color c_999999 = Color(0xFF999999);
  static const Color c_CCCCCC = Color(0xFFCCCCCC);
  static const Color c_F3F3F3 = Color(0xFFF3F3F3);
  static const Color c_F6F6F6 = Color(0xFFF6F6F6);
  static const Color c_F9F9F9 = Color(0xFFF9F9F9);
  static const Color c_EDEDED = Color(0xFFEDEDED);
  static const Color c_262626 = Color(0xFF262626);
  static const Color c_E3E3E3 = Color(0xFFE3E3E3);
  static const Color c_E6E6E6 = Color(0xFFE6E6E6);
  static const Color c_FAC576 = Color(0xFFFAC576);
  static const Color c_CA2B1B = Color(0xFFCA2B1B);
  static const Color c_F84938 = Color(0xFFF84938);

  static TextStyle ts_7EAB1D_28_bold =
      TextStyle(color: c_7EAB1D, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_28_medium =
      TextStyle(color: c_7EAB1D, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_28 =
      TextStyle(color: c_7EAB1D, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_24_bold =
      TextStyle(color: c_7EAB1D, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_24_medium =
      TextStyle(color: c_7EAB1D, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_24 =
      TextStyle(color: c_7EAB1D, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_20_bold =
      TextStyle(color: c_7EAB1D, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_20_medium =
      TextStyle(color: c_7EAB1D, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_20 =
      TextStyle(color: c_7EAB1D, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_18_bold =
      TextStyle(color: c_7EAB1D, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_18_medium =
      TextStyle(color: c_7EAB1D, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_18 =
      TextStyle(color: c_7EAB1D, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_16_bold =
      TextStyle(color: c_7EAB1D, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_16_medium =
      TextStyle(color: c_7EAB1D, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_16 =
      TextStyle(color: c_7EAB1D, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_14_bold =
      TextStyle(color: c_7EAB1D, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_14_medium =
      TextStyle(color: c_7EAB1D, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_14 =
      TextStyle(color: c_7EAB1D, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_12_bold =
      TextStyle(color: c_7EAB1D, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_12_medium =
      TextStyle(color: c_7EAB1D, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_12 =
      TextStyle(color: c_7EAB1D, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7EAB1D_10_bold =
      TextStyle(color: c_7EAB1D, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7EAB1D_10_medium =
      TextStyle(color: c_7EAB1D, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7EAB1D_10 =
      TextStyle(color: c_7EAB1D, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_28_bold =
      TextStyle(color: c_7FA91F, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_28_medium =
      TextStyle(color: c_7FA91F, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_28 =
      TextStyle(color: c_7FA91F, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_24_bold =
      TextStyle(color: c_7FA91F, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_24_medium =
      TextStyle(color: c_7FA91F, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_24 =
      TextStyle(color: c_7FA91F, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_20_bold =
      TextStyle(color: c_7FA91F, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_20_medium =
      TextStyle(color: c_7FA91F, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_20 =
      TextStyle(color: c_7FA91F, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_18_bold =
      TextStyle(color: c_7FA91F, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_18_medium =
      TextStyle(color: c_7FA91F, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_18 =
      TextStyle(color: c_7FA91F, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_16_bold =
      TextStyle(color: c_7FA91F, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_16_medium =
      TextStyle(color: c_7FA91F, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_16 =
      TextStyle(color: c_7FA91F, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_14_bold =
      TextStyle(color: c_7FA91F, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_14_medium =
      TextStyle(color: c_7FA91F, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_14 =
      TextStyle(color: c_7FA91F, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_12_bold =
      TextStyle(color: c_7FA91F, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_12_medium =
      TextStyle(color: c_7FA91F, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_12 =
      TextStyle(color: c_7FA91F, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_7FA91F_10_bold =
      TextStyle(color: c_7FA91F, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_7FA91F_10_medium =
      TextStyle(color: c_7FA91F, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_7FA91F_10 =
      TextStyle(color: c_7FA91F, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_28_bold =
      TextStyle(color: c_A8ABB0, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_28_medium =
      TextStyle(color: c_A8ABB0, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_28 =
      TextStyle(color: c_A8ABB0, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_24_bold =
      TextStyle(color: c_A8ABB0, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_24_medium =
      TextStyle(color: c_A8ABB0, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_24 =
      TextStyle(color: c_A8ABB0, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_20_bold =
      TextStyle(color: c_A8ABB0, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_20_medium =
      TextStyle(color: c_A8ABB0, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_20 =
      TextStyle(color: c_A8ABB0, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_18_bold =
      TextStyle(color: c_A8ABB0, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_18_medium =
      TextStyle(color: c_A8ABB0, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_18 =
      TextStyle(color: c_A8ABB0, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_16_bold =
      TextStyle(color: c_A8ABB0, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_16_medium =
      TextStyle(color: c_A8ABB0, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_16 =
      TextStyle(color: c_A8ABB0, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_14_bold =
      TextStyle(color: c_A8ABB0, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_14_medium =
      TextStyle(color: c_A8ABB0, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_14 =
      TextStyle(color: c_A8ABB0, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_12_bold =
      TextStyle(color: c_A8ABB0, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_12_medium =
      TextStyle(color: c_A8ABB0, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_12 =
      TextStyle(color: c_A8ABB0, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_A8ABB0_10_bold =
      TextStyle(color: c_A8ABB0, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_A8ABB0_10_medium =
      TextStyle(color: c_A8ABB0, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_A8ABB0_10 =
      TextStyle(color: c_A8ABB0, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_28_bold =
      TextStyle(color: c_0C8CE9, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_28_medium =
      TextStyle(color: c_0C8CE9, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_28 =
      TextStyle(color: c_0C8CE9, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_24_bold =
      TextStyle(color: c_0C8CE9, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_24_medium =
      TextStyle(color: c_0C8CE9, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_24 =
      TextStyle(color: c_0C8CE9, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_20_bold =
      TextStyle(color: c_0C8CE9, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_20_medium =
      TextStyle(color: c_0C8CE9, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_20 =
      TextStyle(color: c_0C8CE9, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_18_bold =
      TextStyle(color: c_0C8CE9, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_18_medium =
      TextStyle(color: c_0C8CE9, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_18 =
      TextStyle(color: c_0C8CE9, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_16_bold =
      TextStyle(color: c_0C8CE9, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_16_medium =
      TextStyle(color: c_0C8CE9, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_16 =
      TextStyle(color: c_0C8CE9, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_14_bold =
      TextStyle(color: c_0C8CE9, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_14_medium =
      TextStyle(color: c_0C8CE9, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_14 =
      TextStyle(color: c_0C8CE9, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_12_bold =
      TextStyle(color: c_0C8CE9, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_12_medium =
      TextStyle(color: c_0C8CE9, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_12 =
      TextStyle(color: c_0C8CE9, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0C8CE9_10_bold =
      TextStyle(color: c_0C8CE9, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0C8CE9_10_medium =
      TextStyle(color: c_0C8CE9, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0C8CE9_10 =
      TextStyle(color: c_0C8CE9, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_28_bold =
      TextStyle(color: c_0481DC, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_28_medium =
      TextStyle(color: c_0481DC, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_28 =
      TextStyle(color: c_0481DC, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_24_bold =
      TextStyle(color: c_0481DC, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_24_medium =
      TextStyle(color: c_0481DC, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_24 =
      TextStyle(color: c_0481DC, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_20_bold =
      TextStyle(color: c_0481DC, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_20_medium =
      TextStyle(color: c_0481DC, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_20 =
      TextStyle(color: c_0481DC, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_18_bold =
      TextStyle(color: c_0481DC, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_18_medium =
      TextStyle(color: c_0481DC, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_18 =
      TextStyle(color: c_0481DC, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_16_bold =
      TextStyle(color: c_0481DC, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_16_medium =
      TextStyle(color: c_0481DC, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_16 =
      TextStyle(color: c_0481DC, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_14_bold =
      TextStyle(color: c_0481DC, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_14_medium =
      TextStyle(color: c_0481DC, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_14 =
      TextStyle(color: c_0481DC, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_12_bold =
      TextStyle(color: c_0481DC, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_12_medium =
      TextStyle(color: c_0481DC, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_12 =
      TextStyle(color: c_0481DC, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0481DC_10_bold =
      TextStyle(color: c_0481DC, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0481DC_10_medium =
      TextStyle(color: c_0481DC, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0481DC_10 =
      TextStyle(color: c_0481DC, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_28_bold =
      TextStyle(color: c_1ED386, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_28_medium =
      TextStyle(color: c_1ED386, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_28 =
      TextStyle(color: c_1ED386, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_24_bold =
      TextStyle(color: c_1ED386, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_24_medium =
      TextStyle(color: c_1ED386, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_24 =
      TextStyle(color: c_1ED386, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_20_bold =
      TextStyle(color: c_1ED386, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_20_medium =
      TextStyle(color: c_1ED386, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_20 =
      TextStyle(color: c_1ED386, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_18_bold =
      TextStyle(color: c_1ED386, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_18_medium =
      TextStyle(color: c_1ED386, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_18 =
      TextStyle(color: c_1ED386, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_16_bold =
      TextStyle(color: c_1ED386, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_16_medium =
      TextStyle(color: c_1ED386, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_16 =
      TextStyle(color: c_1ED386, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_14_bold =
      TextStyle(color: c_1ED386, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_14_medium =
      TextStyle(color: c_1ED386, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_14 =
      TextStyle(color: c_1ED386, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_12_bold =
      TextStyle(color: c_1ED386, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_12_medium =
      TextStyle(color: c_1ED386, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_12 =
      TextStyle(color: c_1ED386, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1ED386_10_bold =
      TextStyle(color: c_1ED386, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1ED386_10_medium =
      TextStyle(color: c_1ED386, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1ED386_10 =
      TextStyle(color: c_1ED386, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_28_bold =
      TextStyle(color: c_DE473E, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_28_medium =
      TextStyle(color: c_DE473E, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_28 =
      TextStyle(color: c_DE473E, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_24_bold =
      TextStyle(color: c_DE473E, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_24_medium =
      TextStyle(color: c_DE473E, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_24 =
      TextStyle(color: c_DE473E, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_20_bold =
      TextStyle(color: c_DE473E, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_20_medium =
      TextStyle(color: c_DE473E, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_20 =
      TextStyle(color: c_DE473E, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_18_bold =
      TextStyle(color: c_DE473E, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_18_medium =
      TextStyle(color: c_DE473E, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_18 =
      TextStyle(color: c_DE473E, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_16_bold =
      TextStyle(color: c_DE473E, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_16_medium =
      TextStyle(color: c_DE473E, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_16 =
      TextStyle(color: c_DE473E, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_14_bold =
      TextStyle(color: c_DE473E, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_14_medium =
      TextStyle(color: c_DE473E, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_14 =
      TextStyle(color: c_DE473E, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_12_bold =
      TextStyle(color: c_DE473E, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_12_medium =
      TextStyle(color: c_DE473E, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_12 =
      TextStyle(color: c_DE473E, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_DE473E_10_bold =
      TextStyle(color: c_DE473E, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_DE473E_10_medium =
      TextStyle(color: c_DE473E, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_DE473E_10 =
      TextStyle(color: c_DE473E, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_28_bold =
      TextStyle(color: c_F55545, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_28_medium =
      TextStyle(color: c_F55545, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_28 =
      TextStyle(color: c_F55545, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_24_bold =
      TextStyle(color: c_F55545, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_24_medium =
      TextStyle(color: c_F55545, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_24 =
      TextStyle(color: c_F55545, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_20_bold =
      TextStyle(color: c_F55545, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_20_medium =
      TextStyle(color: c_F55545, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_20 =
      TextStyle(color: c_F55545, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_18_bold =
      TextStyle(color: c_F55545, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_18_medium =
      TextStyle(color: c_F55545, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_18 =
      TextStyle(color: c_F55545, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_16_bold =
      TextStyle(color: c_F55545, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_16_medium =
      TextStyle(color: c_F55545, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_16 =
      TextStyle(color: c_F55545, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_14_bold =
      TextStyle(color: c_F55545, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_14_medium =
      TextStyle(color: c_F55545, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_14 =
      TextStyle(color: c_F55545, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_12_bold =
      TextStyle(color: c_F55545, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_12_medium =
      TextStyle(color: c_F55545, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_12 =
      TextStyle(color: c_F55545, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F55545_10_bold =
      TextStyle(color: c_F55545, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F55545_10_medium =
      TextStyle(color: c_F55545, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F55545_10 =
      TextStyle(color: c_F55545, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_28_bold =
      TextStyle(color: c_CFAC74, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_28_medium =
      TextStyle(color: c_CFAC74, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_28 =
      TextStyle(color: c_CFAC74, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_24_bold =
      TextStyle(color: c_CFAC74, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_24_medium =
      TextStyle(color: c_CFAC74, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_24 =
      TextStyle(color: c_CFAC74, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_20_bold =
      TextStyle(color: c_CFAC74, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_20_medium =
      TextStyle(color: c_CFAC74, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_20 =
      TextStyle(color: c_CFAC74, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_18_bold =
      TextStyle(color: c_CFAC74, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_18_medium =
      TextStyle(color: c_CFAC74, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_18 =
      TextStyle(color: c_CFAC74, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_16_bold =
      TextStyle(color: c_CFAC74, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_16_medium =
      TextStyle(color: c_CFAC74, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_16 =
      TextStyle(color: c_CFAC74, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_14_bold =
      TextStyle(color: c_CFAC74, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_14_medium =
      TextStyle(color: c_CFAC74, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_14 =
      TextStyle(color: c_CFAC74, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_12_bold =
      TextStyle(color: c_CFAC74, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_12_medium =
      TextStyle(color: c_CFAC74, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_12 =
      TextStyle(color: c_CFAC74, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CFAC74_10_bold =
      TextStyle(color: c_CFAC74, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CFAC74_10_medium =
      TextStyle(color: c_CFAC74, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CFAC74_10 =
      TextStyle(color: c_CFAC74, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_28_bold =
      TextStyle(color: c_FFFFFF, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_28_medium =
      TextStyle(color: c_FFFFFF, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_28 =
      TextStyle(color: c_FFFFFF, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_24_bold =
      TextStyle(color: c_FFFFFF, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_24_medium =
      TextStyle(color: c_FFFFFF, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_24 =
      TextStyle(color: c_FFFFFF, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_20_bold =
      TextStyle(color: c_FFFFFF, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_20_medium =
      TextStyle(color: c_FFFFFF, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_20 =
      TextStyle(color: c_FFFFFF, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_18_bold =
      TextStyle(color: c_FFFFFF, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_18_medium =
      TextStyle(color: c_FFFFFF, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_18 =
      TextStyle(color: c_FFFFFF, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_16_bold =
      TextStyle(color: c_FFFFFF, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_16_medium =
      TextStyle(color: c_FFFFFF, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_16 =
      TextStyle(color: c_FFFFFF, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_14_bold =
      TextStyle(color: c_FFFFFF, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_14_medium =
      TextStyle(color: c_FFFFFF, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_14 =
      TextStyle(color: c_FFFFFF, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_12_bold =
      TextStyle(color: c_FFFFFF, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_12_medium =
      TextStyle(color: c_FFFFFF, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_12 =
      TextStyle(color: c_FFFFFF, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FFFFFF_10_bold =
      TextStyle(color: c_FFFFFF, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FFFFFF_10_medium =
      TextStyle(color: c_FFFFFF, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FFFFFF_10 =
      TextStyle(color: c_FFFFFF, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_28_bold =
      TextStyle(color: c_F1F1F1, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_28_medium =
      TextStyle(color: c_F1F1F1, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_28 =
      TextStyle(color: c_F1F1F1, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_24_bold =
      TextStyle(color: c_F1F1F1, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_24_medium =
      TextStyle(color: c_F1F1F1, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_24 =
      TextStyle(color: c_F1F1F1, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_20_bold =
      TextStyle(color: c_F1F1F1, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_20_medium =
      TextStyle(color: c_F1F1F1, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_20 =
      TextStyle(color: c_F1F1F1, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_18_bold =
      TextStyle(color: c_F1F1F1, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_18_medium =
      TextStyle(color: c_F1F1F1, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_18 =
      TextStyle(color: c_F1F1F1, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_16_bold =
      TextStyle(color: c_F1F1F1, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_16_medium =
      TextStyle(color: c_F1F1F1, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_16 =
      TextStyle(color: c_F1F1F1, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_14_bold =
      TextStyle(color: c_F1F1F1, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_14_medium =
      TextStyle(color: c_F1F1F1, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_14 =
      TextStyle(color: c_F1F1F1, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_12_bold =
      TextStyle(color: c_F1F1F1, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_12_medium =
      TextStyle(color: c_F1F1F1, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_12 =
      TextStyle(color: c_F1F1F1, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F1F1F1_10_bold =
      TextStyle(color: c_F1F1F1, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F1F1F1_10_medium =
      TextStyle(color: c_F1F1F1, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F1F1F1_10 =
      TextStyle(color: c_F1F1F1, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_28_bold =
      TextStyle(color: c_0D0D0D, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_28_medium =
      TextStyle(color: c_0D0D0D, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_28 =
      TextStyle(color: c_0D0D0D, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_24_bold =
      TextStyle(color: c_0D0D0D, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_24_medium =
      TextStyle(color: c_0D0D0D, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_24 =
      TextStyle(color: c_0D0D0D, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_20_bold =
      TextStyle(color: c_0D0D0D, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_20_medium =
      TextStyle(color: c_0D0D0D, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_20 =
      TextStyle(color: c_0D0D0D, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_18_bold =
      TextStyle(color: c_0D0D0D, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_18_medium =
      TextStyle(color: c_0D0D0D, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_18 =
      TextStyle(color: c_0D0D0D, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_16_bold =
      TextStyle(color: c_0D0D0D, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_16_medium =
      TextStyle(color: c_0D0D0D, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_16 =
      TextStyle(color: c_0D0D0D, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_14_bold =
      TextStyle(color: c_0D0D0D, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_14_medium =
      TextStyle(color: c_0D0D0D, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_14 =
      TextStyle(color: c_0D0D0D, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_12_bold =
      TextStyle(color: c_0D0D0D, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_12_medium =
      TextStyle(color: c_0D0D0D, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_12 =
      TextStyle(color: c_0D0D0D, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_0D0D0D_10_bold =
      TextStyle(color: c_0D0D0D, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_0D0D0D_10_medium =
      TextStyle(color: c_0D0D0D, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_0D0D0D_10 =
      TextStyle(color: c_0D0D0D, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_28_bold =
      TextStyle(color: c_161616, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_28_medium =
      TextStyle(color: c_161616, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_28 =
      TextStyle(color: c_161616, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_24_bold =
      TextStyle(color: c_161616, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_24_medium =
      TextStyle(color: c_161616, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_24 =
      TextStyle(color: c_161616, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_20_bold =
      TextStyle(color: c_161616, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_20_medium =
      TextStyle(color: c_161616, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_20 =
      TextStyle(color: c_161616, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_18_bold =
      TextStyle(color: c_161616, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_18_medium =
      TextStyle(color: c_161616, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_18 =
      TextStyle(color: c_161616, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_16_bold =
      TextStyle(color: c_161616, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_16_medium =
      TextStyle(color: c_161616, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_16 =
      TextStyle(color: c_161616, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_14_bold =
      TextStyle(color: c_161616, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_14_medium =
      TextStyle(color: c_161616, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_14 =
      TextStyle(color: c_161616, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_12_bold =
      TextStyle(color: c_161616, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_12_medium =
      TextStyle(color: c_161616, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_12 =
      TextStyle(color: c_161616, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_161616_10_bold =
      TextStyle(color: c_161616, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_161616_10_medium =
      TextStyle(color: c_161616, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_161616_10 =
      TextStyle(color: c_161616, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_28_bold =
      TextStyle(color: c_1B1B1B, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_28_medium =
      TextStyle(color: c_1B1B1B, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_28 =
      TextStyle(color: c_1B1B1B, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_24_bold =
      TextStyle(color: c_1B1B1B, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_24_medium =
      TextStyle(color: c_1B1B1B, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_24 =
      TextStyle(color: c_1B1B1B, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_20_bold =
      TextStyle(color: c_1B1B1B, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_20_medium =
      TextStyle(color: c_1B1B1B, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_20 =
      TextStyle(color: c_1B1B1B, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_18_bold =
      TextStyle(color: c_1B1B1B, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_18_medium =
      TextStyle(color: c_1B1B1B, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_18 =
      TextStyle(color: c_1B1B1B, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_16_bold =
      TextStyle(color: c_1B1B1B, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_16_medium =
      TextStyle(color: c_1B1B1B, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_16 =
      TextStyle(color: c_1B1B1B, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_14_bold =
      TextStyle(color: c_1B1B1B, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_14_medium =
      TextStyle(color: c_1B1B1B, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_14 =
      TextStyle(color: c_1B1B1B, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_12_bold =
      TextStyle(color: c_1B1B1B, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_12_medium =
      TextStyle(color: c_1B1B1B, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_12 =
      TextStyle(color: c_1B1B1B, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_1B1B1B_10_bold =
      TextStyle(color: c_1B1B1B, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_1B1B1B_10_medium =
      TextStyle(color: c_1B1B1B, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_1B1B1B_10 =
      TextStyle(color: c_1B1B1B, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_28_bold =
      TextStyle(color: c_121212, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_28_medium =
      TextStyle(color: c_121212, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_28 =
      TextStyle(color: c_121212, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_24_bold =
      TextStyle(color: c_121212, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_24_medium =
      TextStyle(color: c_121212, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_24 =
      TextStyle(color: c_121212, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_20_bold =
      TextStyle(color: c_121212, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_20_medium =
      TextStyle(color: c_121212, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_20 =
      TextStyle(color: c_121212, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_18_bold =
      TextStyle(color: c_121212, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_18_medium =
      TextStyle(color: c_121212, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_18 =
      TextStyle(color: c_121212, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_16_bold =
      TextStyle(color: c_121212, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_16_medium =
      TextStyle(color: c_121212, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_16 =
      TextStyle(color: c_121212, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_14_bold =
      TextStyle(color: c_121212, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_14_medium =
      TextStyle(color: c_121212, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_14 =
      TextStyle(color: c_121212, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_12_bold =
      TextStyle(color: c_121212, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_12_medium =
      TextStyle(color: c_121212, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_12 =
      TextStyle(color: c_121212, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_121212_10_bold =
      TextStyle(color: c_121212, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_121212_10_medium =
      TextStyle(color: c_121212, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_121212_10 =
      TextStyle(color: c_121212, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_28_bold =
      TextStyle(color: c_222222, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_28_medium =
      TextStyle(color: c_222222, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_28 =
      TextStyle(color: c_222222, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_24_bold =
      TextStyle(color: c_222222, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_24_medium =
      TextStyle(color: c_222222, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_24 =
      TextStyle(color: c_222222, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_20_bold =
      TextStyle(color: c_222222, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_20_medium =
      TextStyle(color: c_222222, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_20 =
      TextStyle(color: c_222222, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_18_bold =
      TextStyle(color: c_222222, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_18_medium =
      TextStyle(color: c_222222, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_18 =
      TextStyle(color: c_222222, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_16_bold =
      TextStyle(color: c_222222, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_16_medium =
      TextStyle(color: c_222222, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_16 =
      TextStyle(color: c_222222, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_14_bold =
      TextStyle(color: c_222222, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_14_medium =
      TextStyle(color: c_222222, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_14 =
      TextStyle(color: c_222222, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_12_bold =
      TextStyle(color: c_222222, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_12_medium =
      TextStyle(color: c_222222, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_12 =
      TextStyle(color: c_222222, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_222222_10_bold =
      TextStyle(color: c_222222, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_222222_10_medium =
      TextStyle(color: c_222222, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_222222_10 =
      TextStyle(color: c_222222, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_28_bold =
      TextStyle(color: c_333333, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_28_medium =
      TextStyle(color: c_333333, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_28 =
      TextStyle(color: c_333333, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_24_bold =
      TextStyle(color: c_333333, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_24_medium =
      TextStyle(color: c_333333, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_24 =
      TextStyle(color: c_333333, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_20_bold =
      TextStyle(color: c_333333, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_20_medium =
      TextStyle(color: c_333333, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_20 =
      TextStyle(color: c_333333, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_18_bold =
      TextStyle(color: c_333333, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_18_medium =
      TextStyle(color: c_333333, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_18 =
      TextStyle(color: c_333333, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_16_bold =
      TextStyle(color: c_333333, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_16_medium =
      TextStyle(color: c_333333, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_16 =
      TextStyle(color: c_333333, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_14_bold =
      TextStyle(color: c_333333, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_14_medium =
      TextStyle(color: c_333333, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_14 =
      TextStyle(color: c_333333, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_12_bold =
      TextStyle(color: c_333333, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_12_medium =
      TextStyle(color: c_333333, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_12 =
      TextStyle(color: c_333333, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_333333_10_bold =
      TextStyle(color: c_333333, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_333333_10_medium =
      TextStyle(color: c_333333, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_333333_10 =
      TextStyle(color: c_333333, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_28_bold =
      TextStyle(color: c_555555, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_28_medium =
      TextStyle(color: c_555555, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_28 =
      TextStyle(color: c_555555, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_24_bold =
      TextStyle(color: c_555555, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_24_medium =
      TextStyle(color: c_555555, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_24 =
      TextStyle(color: c_555555, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_20_bold =
      TextStyle(color: c_555555, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_20_medium =
      TextStyle(color: c_555555, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_20 =
      TextStyle(color: c_555555, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_18_bold =
      TextStyle(color: c_555555, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_18_medium =
      TextStyle(color: c_555555, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_18 =
      TextStyle(color: c_555555, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_16_bold =
      TextStyle(color: c_555555, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_16_medium =
      TextStyle(color: c_555555, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_16 =
      TextStyle(color: c_555555, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_14_bold =
      TextStyle(color: c_555555, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_14_medium =
      TextStyle(color: c_555555, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_14 =
      TextStyle(color: c_555555, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_12_bold =
      TextStyle(color: c_555555, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_12_medium =
      TextStyle(color: c_555555, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_12 =
      TextStyle(color: c_555555, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_555555_10_bold =
      TextStyle(color: c_555555, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_555555_10_medium =
      TextStyle(color: c_555555, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_555555_10 =
      TextStyle(color: c_555555, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_28_bold =
      TextStyle(color: c_666666, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_28_medium =
      TextStyle(color: c_666666, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_28 =
      TextStyle(color: c_666666, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_24_bold =
      TextStyle(color: c_666666, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_24_medium =
      TextStyle(color: c_666666, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_24 =
      TextStyle(color: c_666666, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_20_bold =
      TextStyle(color: c_666666, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_20_medium =
      TextStyle(color: c_666666, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_20 =
      TextStyle(color: c_666666, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_18_bold =
      TextStyle(color: c_666666, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_18_medium =
      TextStyle(color: c_666666, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_18 =
      TextStyle(color: c_666666, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_16_bold =
      TextStyle(color: c_666666, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_16_medium =
      TextStyle(color: c_666666, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_16 =
      TextStyle(color: c_666666, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_14_bold =
      TextStyle(color: c_666666, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_14_medium =
      TextStyle(color: c_666666, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_14 =
      TextStyle(color: c_666666, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_12_bold =
      TextStyle(color: c_666666, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_12_medium =
      TextStyle(color: c_666666, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_12 =
      TextStyle(color: c_666666, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_666666_10_bold =
      TextStyle(color: c_666666, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_666666_10_medium =
      TextStyle(color: c_666666, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_666666_10 =
      TextStyle(color: c_666666, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_28_bold =
      TextStyle(color: c_777777, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_28_medium =
      TextStyle(color: c_777777, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_28 =
      TextStyle(color: c_777777, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_24_bold =
      TextStyle(color: c_777777, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_24_medium =
      TextStyle(color: c_777777, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_24 =
      TextStyle(color: c_777777, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_20_bold =
      TextStyle(color: c_777777, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_20_medium =
      TextStyle(color: c_777777, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_20 =
      TextStyle(color: c_777777, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_18_bold =
      TextStyle(color: c_777777, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_18_medium =
      TextStyle(color: c_777777, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_18 =
      TextStyle(color: c_777777, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_16_bold =
      TextStyle(color: c_777777, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_16_medium =
      TextStyle(color: c_777777, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_16 =
      TextStyle(color: c_777777, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_14_bold =
      TextStyle(color: c_777777, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_14_medium =
      TextStyle(color: c_777777, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_14 =
      TextStyle(color: c_777777, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_12_bold =
      TextStyle(color: c_777777, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_12_medium =
      TextStyle(color: c_777777, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_12 =
      TextStyle(color: c_777777, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_777777_10_bold =
      TextStyle(color: c_777777, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_777777_10_medium =
      TextStyle(color: c_777777, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_777777_10 =
      TextStyle(color: c_777777, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_28_bold =
      TextStyle(color: c_999999, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_28_medium =
      TextStyle(color: c_999999, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_28 =
      TextStyle(color: c_999999, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_24_bold =
      TextStyle(color: c_999999, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_24_medium =
      TextStyle(color: c_999999, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_24 =
      TextStyle(color: c_999999, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_20_bold =
      TextStyle(color: c_999999, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_20_medium =
      TextStyle(color: c_999999, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_20 =
      TextStyle(color: c_999999, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_18_bold =
      TextStyle(color: c_999999, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_18_medium =
      TextStyle(color: c_999999, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_18 =
      TextStyle(color: c_999999, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_16_bold =
      TextStyle(color: c_999999, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_16_medium =
      TextStyle(color: c_999999, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_16 =
      TextStyle(color: c_999999, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_14_bold =
      TextStyle(color: c_999999, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_14_medium =
      TextStyle(color: c_999999, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_14 =
      TextStyle(color: c_999999, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_12_bold =
      TextStyle(color: c_999999, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_12_medium =
      TextStyle(color: c_999999, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_12 =
      TextStyle(color: c_999999, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_999999_10_bold =
      TextStyle(color: c_999999, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_999999_10_medium =
      TextStyle(color: c_999999, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_999999_10 =
      TextStyle(color: c_999999, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_28_bold =
      TextStyle(color: c_CCCCCC, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_28_medium =
      TextStyle(color: c_CCCCCC, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_28 =
      TextStyle(color: c_CCCCCC, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_24_bold =
      TextStyle(color: c_CCCCCC, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_24_medium =
      TextStyle(color: c_CCCCCC, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_24 =
      TextStyle(color: c_CCCCCC, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_20_bold =
      TextStyle(color: c_CCCCCC, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_20_medium =
      TextStyle(color: c_CCCCCC, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_20 =
      TextStyle(color: c_CCCCCC, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_18_bold =
      TextStyle(color: c_CCCCCC, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_18_medium =
      TextStyle(color: c_CCCCCC, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_18 =
      TextStyle(color: c_CCCCCC, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_16_bold =
      TextStyle(color: c_CCCCCC, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_16_medium =
      TextStyle(color: c_CCCCCC, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_16 =
      TextStyle(color: c_CCCCCC, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_14_bold =
      TextStyle(color: c_CCCCCC, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_14_medium =
      TextStyle(color: c_CCCCCC, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_14 =
      TextStyle(color: c_CCCCCC, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_12_bold =
      TextStyle(color: c_CCCCCC, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_12_medium =
      TextStyle(color: c_CCCCCC, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_12 =
      TextStyle(color: c_CCCCCC, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CCCCCC_10_bold =
      TextStyle(color: c_CCCCCC, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CCCCCC_10_medium =
      TextStyle(color: c_CCCCCC, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CCCCCC_10 =
      TextStyle(color: c_CCCCCC, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_28_bold =
      TextStyle(color: c_F3F3F3, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_28_medium =
      TextStyle(color: c_F3F3F3, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_28 =
      TextStyle(color: c_F3F3F3, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_24_bold =
      TextStyle(color: c_F3F3F3, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_24_medium =
      TextStyle(color: c_F3F3F3, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_24 =
      TextStyle(color: c_F3F3F3, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_20_bold =
      TextStyle(color: c_F3F3F3, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_20_medium =
      TextStyle(color: c_F3F3F3, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_20 =
      TextStyle(color: c_F3F3F3, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_18_bold =
      TextStyle(color: c_F3F3F3, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_18_medium =
      TextStyle(color: c_F3F3F3, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_18 =
      TextStyle(color: c_F3F3F3, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_16_bold =
      TextStyle(color: c_F3F3F3, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_16_medium =
      TextStyle(color: c_F3F3F3, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_16 =
      TextStyle(color: c_F3F3F3, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_14_bold =
      TextStyle(color: c_F3F3F3, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_14_medium =
      TextStyle(color: c_F3F3F3, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_14 =
      TextStyle(color: c_F3F3F3, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_12_bold =
      TextStyle(color: c_F3F3F3, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_12_medium =
      TextStyle(color: c_F3F3F3, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_12 =
      TextStyle(color: c_F3F3F3, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F3F3F3_10_bold =
      TextStyle(color: c_F3F3F3, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F3F3F3_10_medium =
      TextStyle(color: c_F3F3F3, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F3F3F3_10 =
      TextStyle(color: c_F3F3F3, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_28_bold =
      TextStyle(color: c_F6F6F6, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_28_medium =
      TextStyle(color: c_F6F6F6, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_28 =
      TextStyle(color: c_F6F6F6, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_24_bold =
      TextStyle(color: c_F6F6F6, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_24_medium =
      TextStyle(color: c_F6F6F6, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_24 =
      TextStyle(color: c_F6F6F6, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_20_bold =
      TextStyle(color: c_F6F6F6, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_20_medium =
      TextStyle(color: c_F6F6F6, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_20 =
      TextStyle(color: c_F6F6F6, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_18_bold =
      TextStyle(color: c_F6F6F6, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_18_medium =
      TextStyle(color: c_F6F6F6, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_18 =
      TextStyle(color: c_F6F6F6, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_16_bold =
      TextStyle(color: c_F6F6F6, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_16_medium =
      TextStyle(color: c_F6F6F6, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_16 =
      TextStyle(color: c_F6F6F6, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_14_bold =
      TextStyle(color: c_F6F6F6, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_14_medium =
      TextStyle(color: c_F6F6F6, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_14 =
      TextStyle(color: c_F6F6F6, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_12_bold =
      TextStyle(color: c_F6F6F6, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_12_medium =
      TextStyle(color: c_F6F6F6, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_12 =
      TextStyle(color: c_F6F6F6, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F6F6F6_10_bold =
      TextStyle(color: c_F6F6F6, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F6F6F6_10_medium =
      TextStyle(color: c_F6F6F6, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F6F6F6_10 =
      TextStyle(color: c_F6F6F6, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_28_bold =
      TextStyle(color: c_F9F9F9, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_28_medium =
      TextStyle(color: c_F9F9F9, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_28 =
      TextStyle(color: c_F9F9F9, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_24_bold =
      TextStyle(color: c_F9F9F9, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_24_medium =
      TextStyle(color: c_F9F9F9, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_24 =
      TextStyle(color: c_F9F9F9, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_20_bold =
      TextStyle(color: c_F9F9F9, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_20_medium =
      TextStyle(color: c_F9F9F9, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_20 =
      TextStyle(color: c_F9F9F9, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_18_bold =
      TextStyle(color: c_F9F9F9, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_18_medium =
      TextStyle(color: c_F9F9F9, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_18 =
      TextStyle(color: c_F9F9F9, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_16_bold =
      TextStyle(color: c_F9F9F9, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_16_medium =
      TextStyle(color: c_F9F9F9, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_16 =
      TextStyle(color: c_F9F9F9, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_14_bold =
      TextStyle(color: c_F9F9F9, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_14_medium =
      TextStyle(color: c_F9F9F9, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_14 =
      TextStyle(color: c_F9F9F9, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_12_bold =
      TextStyle(color: c_F9F9F9, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_12_medium =
      TextStyle(color: c_F9F9F9, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_12 =
      TextStyle(color: c_F9F9F9, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F9F9F9_10_bold =
      TextStyle(color: c_F9F9F9, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F9F9F9_10_medium =
      TextStyle(color: c_F9F9F9, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F9F9F9_10 =
      TextStyle(color: c_F9F9F9, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_28_bold =
      TextStyle(color: c_EDEDED, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_28_medium =
      TextStyle(color: c_EDEDED, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_28 =
      TextStyle(color: c_EDEDED, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_24_bold =
      TextStyle(color: c_EDEDED, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_24_medium =
      TextStyle(color: c_EDEDED, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_24 =
      TextStyle(color: c_EDEDED, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_20_bold =
      TextStyle(color: c_EDEDED, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_20_medium =
      TextStyle(color: c_EDEDED, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_20 =
      TextStyle(color: c_EDEDED, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_18_bold =
      TextStyle(color: c_EDEDED, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_18_medium =
      TextStyle(color: c_EDEDED, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_18 =
      TextStyle(color: c_EDEDED, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_16_bold =
      TextStyle(color: c_EDEDED, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_16_medium =
      TextStyle(color: c_EDEDED, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_16 =
      TextStyle(color: c_EDEDED, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_14_bold =
      TextStyle(color: c_EDEDED, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_14_medium =
      TextStyle(color: c_EDEDED, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_14 =
      TextStyle(color: c_EDEDED, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_12_bold =
      TextStyle(color: c_EDEDED, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_12_medium =
      TextStyle(color: c_EDEDED, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_12 =
      TextStyle(color: c_EDEDED, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_EDEDED_10_bold =
      TextStyle(color: c_EDEDED, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_EDEDED_10_medium =
      TextStyle(color: c_EDEDED, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_EDEDED_10 =
      TextStyle(color: c_EDEDED, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_28_bold =
      TextStyle(color: c_262626, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_28_medium =
      TextStyle(color: c_262626, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_28 =
      TextStyle(color: c_262626, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_24_bold =
      TextStyle(color: c_262626, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_24_medium =
      TextStyle(color: c_262626, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_24 =
      TextStyle(color: c_262626, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_20_bold =
      TextStyle(color: c_262626, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_20_medium =
      TextStyle(color: c_262626, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_20 =
      TextStyle(color: c_262626, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_18_bold =
      TextStyle(color: c_262626, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_18_medium =
      TextStyle(color: c_262626, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_18 =
      TextStyle(color: c_262626, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_16_bold =
      TextStyle(color: c_262626, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_16_medium =
      TextStyle(color: c_262626, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_16 =
      TextStyle(color: c_262626, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_14_bold =
      TextStyle(color: c_262626, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_14_medium =
      TextStyle(color: c_262626, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_14 =
      TextStyle(color: c_262626, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_12_bold =
      TextStyle(color: c_262626, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_12_medium =
      TextStyle(color: c_262626, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_12 =
      TextStyle(color: c_262626, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_262626_10_bold =
      TextStyle(color: c_262626, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_262626_10_medium =
      TextStyle(color: c_262626, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_262626_10 =
      TextStyle(color: c_262626, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_28_bold =
      TextStyle(color: c_E3E3E3, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_28_medium =
      TextStyle(color: c_E3E3E3, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_28 =
      TextStyle(color: c_E3E3E3, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_24_bold =
      TextStyle(color: c_E3E3E3, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_24_medium =
      TextStyle(color: c_E3E3E3, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_24 =
      TextStyle(color: c_E3E3E3, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_20_bold =
      TextStyle(color: c_E3E3E3, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_20_medium =
      TextStyle(color: c_E3E3E3, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_20 =
      TextStyle(color: c_E3E3E3, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_18_bold =
      TextStyle(color: c_E3E3E3, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_18_medium =
      TextStyle(color: c_E3E3E3, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_18 =
      TextStyle(color: c_E3E3E3, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_16_bold =
      TextStyle(color: c_E3E3E3, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_16_medium =
      TextStyle(color: c_E3E3E3, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_16 =
      TextStyle(color: c_E3E3E3, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_14_bold =
      TextStyle(color: c_E3E3E3, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_14_medium =
      TextStyle(color: c_E3E3E3, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_14 =
      TextStyle(color: c_E3E3E3, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_12_bold =
      TextStyle(color: c_E3E3E3, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_12_medium =
      TextStyle(color: c_E3E3E3, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_12 =
      TextStyle(color: c_E3E3E3, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E3E3E3_10_bold =
      TextStyle(color: c_E3E3E3, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E3E3E3_10_medium =
      TextStyle(color: c_E3E3E3, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E3E3E3_10 =
      TextStyle(color: c_E3E3E3, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_28_bold =
      TextStyle(color: c_E6E6E6, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_28_medium =
      TextStyle(color: c_E6E6E6, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_28 =
      TextStyle(color: c_E6E6E6, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_24_bold =
      TextStyle(color: c_E6E6E6, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_24_medium =
      TextStyle(color: c_E6E6E6, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_24 =
      TextStyle(color: c_E6E6E6, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_20_bold =
      TextStyle(color: c_E6E6E6, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_20_medium =
      TextStyle(color: c_E6E6E6, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_20 =
      TextStyle(color: c_E6E6E6, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_18_bold =
      TextStyle(color: c_E6E6E6, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_18_medium =
      TextStyle(color: c_E6E6E6, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_18 =
      TextStyle(color: c_E6E6E6, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_16_bold =
      TextStyle(color: c_E6E6E6, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_16_medium =
      TextStyle(color: c_E6E6E6, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_16 =
      TextStyle(color: c_E6E6E6, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_14_bold =
      TextStyle(color: c_E6E6E6, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_14_medium =
      TextStyle(color: c_E6E6E6, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_14 =
      TextStyle(color: c_E6E6E6, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_12_bold =
      TextStyle(color: c_E6E6E6, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_12_medium =
      TextStyle(color: c_E6E6E6, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_12 =
      TextStyle(color: c_E6E6E6, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_E6E6E6_10_bold =
      TextStyle(color: c_E6E6E6, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_E6E6E6_10_medium =
      TextStyle(color: c_E6E6E6, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_E6E6E6_10 =
      TextStyle(color: c_E6E6E6, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_28_bold =
      TextStyle(color: c_FAC576, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_28_medium =
      TextStyle(color: c_FAC576, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_28 =
      TextStyle(color: c_FAC576, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_24_bold =
      TextStyle(color: c_FAC576, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_24_medium =
      TextStyle(color: c_FAC576, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_24 =
      TextStyle(color: c_FAC576, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_20_bold =
      TextStyle(color: c_FAC576, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_20_medium =
      TextStyle(color: c_FAC576, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_20 =
      TextStyle(color: c_FAC576, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_18_bold =
      TextStyle(color: c_FAC576, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_18_medium =
      TextStyle(color: c_FAC576, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_18 =
      TextStyle(color: c_FAC576, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_16_bold =
      TextStyle(color: c_FAC576, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_16_medium =
      TextStyle(color: c_FAC576, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_16 =
      TextStyle(color: c_FAC576, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_14_bold =
      TextStyle(color: c_FAC576, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_14_medium =
      TextStyle(color: c_FAC576, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_14 =
      TextStyle(color: c_FAC576, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_12_bold =
      TextStyle(color: c_FAC576, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_12_medium =
      TextStyle(color: c_FAC576, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_12 =
      TextStyle(color: c_FAC576, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_FAC576_10_bold =
      TextStyle(color: c_FAC576, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_FAC576_10_medium =
      TextStyle(color: c_FAC576, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_FAC576_10 =
      TextStyle(color: c_FAC576, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_28_bold =
      TextStyle(color: c_CA2B1B, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_28_medium =
      TextStyle(color: c_CA2B1B, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_28 =
      TextStyle(color: c_CA2B1B, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_24_bold =
      TextStyle(color: c_CA2B1B, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_24_medium =
      TextStyle(color: c_CA2B1B, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_24 =
      TextStyle(color: c_CA2B1B, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_20_bold =
      TextStyle(color: c_CA2B1B, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_20_medium =
      TextStyle(color: c_CA2B1B, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_20 =
      TextStyle(color: c_CA2B1B, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_18_bold =
      TextStyle(color: c_CA2B1B, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_18_medium =
      TextStyle(color: c_CA2B1B, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_18 =
      TextStyle(color: c_CA2B1B, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_16_bold =
      TextStyle(color: c_CA2B1B, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_16_medium =
      TextStyle(color: c_CA2B1B, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_16 =
      TextStyle(color: c_CA2B1B, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_14_bold =
      TextStyle(color: c_CA2B1B, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_14_medium =
      TextStyle(color: c_CA2B1B, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_14 =
      TextStyle(color: c_CA2B1B, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_12_bold =
      TextStyle(color: c_CA2B1B, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_12_medium =
      TextStyle(color: c_CA2B1B, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_12 =
      TextStyle(color: c_CA2B1B, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_CA2B1B_10_bold =
      TextStyle(color: c_CA2B1B, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_CA2B1B_10_medium =
      TextStyle(color: c_CA2B1B, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_CA2B1B_10 =
      TextStyle(color: c_CA2B1B, fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_28_bold =
      TextStyle(color: c_F84938, fontSize: 28.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_28_medium =
      TextStyle(color: c_F84938, fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_28 =
      TextStyle(color: c_F84938, fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_24_bold =
      TextStyle(color: c_F84938, fontSize: 24.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_24_medium =
      TextStyle(color: c_F84938, fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_24 =
      TextStyle(color: c_F84938, fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_20_bold =
      TextStyle(color: c_F84938, fontSize: 20.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_20_medium =
      TextStyle(color: c_F84938, fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_20 =
      TextStyle(color: c_F84938, fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_18_bold =
      TextStyle(color: c_F84938, fontSize: 18.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_18_medium =
      TextStyle(color: c_F84938, fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_18 =
      TextStyle(color: c_F84938, fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_16_bold =
      TextStyle(color: c_F84938, fontSize: 16.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_16_medium =
      TextStyle(color: c_F84938, fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_16 =
      TextStyle(color: c_F84938, fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_14_bold =
      TextStyle(color: c_F84938, fontSize: 14.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_14_medium =
      TextStyle(color: c_F84938, fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_14 =
      TextStyle(color: c_F84938, fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_12_bold =
      TextStyle(color: c_F84938, fontSize: 12.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_12_medium =
      TextStyle(color: c_F84938, fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_12 =
      TextStyle(color: c_F84938, fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle ts_F84938_10_bold =
      TextStyle(color: c_F84938, fontSize: 10.sp, fontWeight: FontWeight.bold);
  static TextStyle ts_F84938_10_medium =
      TextStyle(color: c_F84938, fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle ts_F84938_10 =
      TextStyle(color: c_F84938, fontSize: 10.sp, fontWeight: FontWeight.w400);

  static SwitchThemeData switchTheme = SwitchThemeData(
    // 开关滑块颜色
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Styles.c_FFFFFF; // 选中时的滑块颜色
      }
      return Styles.c_999999; // 未选中时的滑块颜色
    }),
    // 轨道颜色
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Styles.c_0C8CE9; // 选中时的轨道颜色
      }
      return Styles.c_EDEDED; // 未选中时的轨道颜色
    }),
    // 轨道边框颜色
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      return Colors.transparent; // 轨道边框颜色
    }),
    // 轨道大小
    trackOutlineWidth: WidgetStateProperty.all(0),
    // 开关整体大小
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static const fontFamily = 'PingFangSC';

  static ThemeData lightTheme = ThemeData(
    fontFamily: fontFamily,
    // fontFamilyFallback: const ['HarmonyOS_Sans','PingFangSC'],
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.light(primary: Styles.c_0C8CE9),
    switchTheme: switchTheme,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: fontFamily,
    // fontFamilyFallback: const ['HarmonyOS_Sans','PingFangSC'],
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(primary: Styles.c_0481DC),
    switchTheme: switchTheme,
  );
  // 纯黑色
  static WatermarkBackgroundColor blackTextColor =
      WatermarkBackgroundColor(color: '#000000', alpha: 1);
  // 纯白色
  static WatermarkBackgroundColor whiteTextColor =
      WatermarkBackgroundColor(color: '#ffffff', alpha: 1);
  // 扳手工程记录类似黑色的字体颜色
  static WatermarkBackgroundColor likeBlackTextColor =
      WatermarkBackgroundColor(color: '#3c3b4a', alpha: 1);
}
