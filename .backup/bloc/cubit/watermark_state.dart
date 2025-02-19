part of 'watermark_cubit.dart';

@immutable
sealed class WatermarkState {}

final class WatermarkInitial extends WatermarkState {}

final class WatermarkViewLoaded extends WatermarkState {
  final int? watermarkId;
  final WatermarkView? watermarkView;

  WatermarkViewLoaded(
      {this.watermarkId,
      this.watermarkView});
}
