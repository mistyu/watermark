import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'watermark_cubit.dart';

class WatermarkViewBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, WatermarkViewLoaded state) builder;
  const WatermarkViewBuilder({super.key, required this.builder});

  @override
  State<WatermarkViewBuilder> createState() => _WatermarkViewBuilderState();
}

class _WatermarkViewBuilderState extends State<WatermarkViewBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatermarkCubit,WatermarkState>(
        builder: (context, state) {
          if (state is WatermarkInitial) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is WatermarkViewLoaded) {
            return widget.builder(context, state);
          }

          return const SizedBox.shrink();
        });
  }
}

