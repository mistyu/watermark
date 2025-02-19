import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/camera/custom_water_mark_panel.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Map<String, dynamic>? _locationResult = {};
  Map<String, dynamic>? _weather = {};
  String? _latitude = '';
  String? _longitude = '';

  void loadedLocation(
      {Map<String, dynamic>? location,
      Map<String, dynamic>? weather,
      String? latitude,
      String? longitude}) {
    _locationResult = location;
    _weather = weather;
    _longitude = longitude;
    _latitude = latitude;
    emit(LocationViewLoaded(
        location: _locationResult,
        weather: _weather,
        longitude: _longitude,
        latitude: _latitude));
  }

  Map<String, dynamic>? get locationResult => _locationResult;
  Map<String, dynamic>? get weather => _weather;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
}
