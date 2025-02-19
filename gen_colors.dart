import 'dart:io';

void main() {
  final colors = [
    {'name': 'c_7EAB1D', 'value': '0xFF7EAB1D'},
    {'name': 'c_7FA91F', 'value': '0xFF7FA91F'},
    {'name': 'c_A8ABB0', 'value': '0xFFA8ABB0'},
    {'name': 'c_0C8CE9', 'value': '0xFF0C8CE9'},
    {'name': 'c_0481DC', 'value': '0xFF0481DC'},
    {'name': 'c_1ED386', 'value': '0xFF1ED386'},
    {'name': 'c_DE473E', 'value': '0xFFDE473E'},
    {'name': 'c_F55545', 'value': '0xFFF55545'},
    {'name': 'c_CFAC74', 'value': '0xFFCFAC74'},
    {'name': 'c_FFFFFF', 'value': '0xFFFFFFFF'},
    {'name': 'c_F1F1F1', 'value': '0xFFF1F1F1'},
    {'name': 'c_0D0D0D', 'value': '0xFF0D0D0D'},
    {'name': 'c_161616', 'value': '0xFF161616'},
    {'name': 'c_1B1B1B', 'value': '0xFF1B1B1B'},
    {'name': 'c_121212', 'value': '0xFF121212'},
    {'name': 'c_222222', 'value': '0xFF222222'},
    {'name': 'c_333333', 'value': '0xFF333333'},
    {'name': 'c_555555', 'value': '0xFF555555'},
    {'name': 'c_666666', 'value': '0xFF666666'},
    {'name': 'c_777777', 'value': '0xFF777777'},
    {'name': 'c_999999', 'value': '0xFF999999'},
    {'name': 'c_CCCCCC', 'value': '0xFFCCCCCC'},
    {'name': 'c_F3F3F3', 'value': '0xFFF3F3F3'},
    {'name': 'c_F6F6F6', 'value': '0xFFF6F6F6'},
    {'name': 'c_F9F9F9', 'value': '0xFFF9F9F9'},
    {'name': 'c_EDEDED', 'value': '0xFFEDEDED'},
    {'name': 'c_262626', 'value': '0xFF262626'},
    {'name': 'c_E3E3E3', 'value': '0xFFE3E3E3'},
    {'name': 'c_E6E6E6', 'value': '0xFFE6E6E6'},
    {'name': 'c_FAC576', 'value': '0xFFFAC576'},
    {'name': 'c_CA2B1B', 'value': '0xFFCA2B1B'},
    {'name': 'c_F84938', 'value': '0xFFF84938'},
  ];

  final fontSizes = [28, 24, 20, 18, 16, 14, 12, 10];
  final fontWeights = [
    {'name': 'bold', 'value': 'FontWeight.bold'},
    {'name': 'medium', 'value': 'FontWeight.w500'},
    {'name': '', 'value': 'FontWeight.w400'},
  ];

  final buffer = StringBuffer();

  buffer.writeln('import \'package:flutter/material.dart\';');
  buffer.writeln();
  buffer.writeln('class MyColors {');

  for (var color in colors) {
    buffer.writeln(
        '  static const Color ${color['name']} = Color(${color['value']});');
  }

  buffer.writeln('}');
  buffer.writeln();
  buffer.writeln('class TextStyles {');

  for (var color in colors) {
    for (var size in fontSizes) {
      for (var weight in fontWeights) {
        final styleName = weight['name']!.isEmpty
            ? 'ts_${color['name']?.substring(2)}_$size'
            : 'ts_${color['name']?.substring(2)}_${size}_${weight['name']}';
        buffer.writeln(
            '  static TextStyle $styleName = TextStyle(color: MyColors.${color['name']}, fontSize: $size.sp, fontWeight: ${weight['value']});');
      }
    }
  }

  buffer.writeln('}');

  final outputFile = File('./generated_text_styles.dart');
  outputFile.writeAsStringSync(buffer.toString());
}
