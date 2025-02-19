import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

part 'watermark_state.dart';

class WatermarkCubit extends Cubit<WatermarkState> {
  WatermarkCubit() : super(WatermarkInitial());

  int _watermarkId = 1698049557635;
  WatermarkView? _watermarkView;

  void loadedWatermarkView(int id, {WatermarkView? watermarkView}) {
    _watermarkView = watermarkView;
    _watermarkId = id;
    emit(WatermarkViewLoaded(
        watermarkView: _watermarkView, watermarkId: _watermarkId));
  }

  int get watermarkId => _watermarkId;
  WatermarkView? get watermarkView => _watermarkView;
}
