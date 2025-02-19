import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'resource_cubit.dart';
import 'watermark_cubit.dart';

class WatermarkResourceBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, ResourceLoaded state) builder;
  const WatermarkResourceBuilder({super.key, required this.builder});

  @override
  State<WatermarkResourceBuilder> createState() => _WatermarkSourceBuilderState();
}

class _WatermarkSourceBuilderState extends State<WatermarkResourceBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCubit,ResourceState>(
        builder: (context, state) {
      if (state is ResourceInitial) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (state is ResourceLoaded) {
        return widget.builder(context, state);
      }

      return const SizedBox.shrink();
    });
  }
}

