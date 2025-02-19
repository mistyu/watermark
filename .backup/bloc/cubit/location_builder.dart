import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_cubit.dart';

class LocationViewBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, LocationViewLoaded state) builder;
  const LocationViewBuilder({super.key, required this.builder});

  @override
  State<LocationViewBuilder> createState() => _LocationViewBuilderState();
}

class _LocationViewBuilderState extends State<LocationViewBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
      if (state is LocationViewLoaded) {
        return widget.builder(context, state);
      }

      return const Text("中国地址位置定位中",style: TextStyle(color: Colors.white),);
    });
  }
}
