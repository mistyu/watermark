import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'right_bottom_cubit.dart';

class RightBottomViewBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, RightBottomViewLoaded state)
      builder;
  const RightBottomViewBuilder({super.key, required this.builder});

  @override
  State<RightBottomViewBuilder> createState() => _RightBottomViewBuilderState();
}

class _RightBottomViewBuilderState extends State<RightBottomViewBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RightBottomCubit, RightBottomState>(
        builder: (context, state) {
      if (state is RightBottomInitial) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (state is RightBottomViewLoaded) {
        return widget.builder(context, state);
      }

      return const SizedBox.shrink();
    });
  }
}
