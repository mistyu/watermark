import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

const bottomTextStyle = TextStyle(fontSize: 10.0, color: Colors.white);

const layerInteractionButtonRadius = 10.0;

final List<TextStyle> customTextStyles = [
  GoogleFonts.roboto(),
  GoogleFonts.averiaLibre(),
  GoogleFonts.lato(),
  GoogleFonts.comicNeue(),
  GoogleFonts.actor(),
  GoogleFonts.odorMeanChey(),
  GoogleFonts.nabla(),
];

const List<PaintModeBottomBarItem> paintModes = [
  PaintModeBottomBarItem(
    mode: PaintModeE.freeStyle,
    icon: Icons.edit,
    label: '自由画',
  ),
  PaintModeBottomBarItem(
    mode: PaintModeE.arrow,
    icon: Icons.arrow_right_alt_outlined,
    label: '箭头',
  ),
  PaintModeBottomBarItem(
    mode: PaintModeE.line,
    icon: Icons.horizontal_rule,
    label: '线条',
  ),
  PaintModeBottomBarItem(
    mode: PaintModeE.rect,
    icon: Icons.crop_free,
    label: '矩形',
  ),
  PaintModeBottomBarItem(
    mode: PaintModeE.circle,
    icon: Icons.lens_outlined,
    label: '圆形',
  ),
  PaintModeBottomBarItem(
    mode: PaintModeE.dashLine,
    icon: Icons.power_input,
    label: '虚线',
  ),
]; 