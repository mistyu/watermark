import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

part 'right_bottom_state.dart';

class RightBottomCubit extends Cubit<RightBottomState> {
  RightBottomCubit() : super(RightBottomInitial());

  int? _watermarkId = 26986609252200;
  RightBottomView? _rightBottomView;

  void loadedWatermarkView({int? id, RightBottomView? rightBottomView}) {
    _watermarkId = id;
    _rightBottomView = rightBottomView;
    emit(RightBottomViewLoaded(
        watermarkId: _watermarkId, rightBottomView: _rightBottomView));
  }

  int? get watermarkId => _watermarkId;
  RightBottomView? get rightBottomView => _rightBottomView;
}
