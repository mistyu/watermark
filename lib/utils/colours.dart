import 'package:flutter/material.dart';

class Colours {
  // main
  static Color kPrimary = const Color(0xFFFFC41D);
  static Color kPrimary2 = const Color(0xFF0481DC);
  static Color kSuccess = const Color(0xFF1ED386);
  static Color kError = const Color(0xFFDE473E);

  static Color kGrey900 = const Color(0xFF333333);
  static Color kGrey800 = const Color(0xFF555555);
  static Color kGrey700 = const Color(0xFF666666);
  static Color kGrey600 = const Color(0xFF999999);
  static Color kGrey500 = const Color(0xFFCCCCCC);
  static Color kGrey400 = const Color(0xFFEDEDED);
  static Color kGrey300 = const Color(0xFFF6F6F6);
  static Color kGrey200 = const Color(0xFFF9F9F9);

  static Color kWhite = const Color(0xFFFFFFFF);
  static Color kBlack = const Color(0xFF0D0D0D);

  static int hexToArgb(String hexColor, num num, {double alpha = 1.0}) {
    hexColor = hexColor.replaceAll('#', '');

    if (hexColor.length == 3) {
      hexColor = hexColor.split('').map((c) => c + c).join();
    }
    if (hexColor.length != 6) {
      throw ArgumentError(
          "Hex color must be 3 or 6 characters long (without #)");
    }

    final alphaInt =
        (alpha * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    return int.parse('0x$alphaInt$hexColor', radix: 16);
  }
}
