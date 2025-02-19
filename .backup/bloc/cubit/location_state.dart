part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationViewLoaded extends LocationState {
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? weather;
  final String? longitude;
  final String? latitude;

  LocationViewLoaded(
      {required this.location, this.weather, this.longitude, this.latitude});
}
