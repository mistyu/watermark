
part of 'right_bottom_cubit.dart';

@immutable
sealed class RightBottomState {}

final class RightBottomInitial extends RightBottomState {}

final class RightBottomViewLoaded extends RightBottomState {
  final int? watermarkId;
 
  final RightBottomView? rightBottomView;

  RightBottomViewLoaded(
      {this.watermarkId,
      this.rightBottomView});
}
