import 'package:rxdart/rxdart.dart';

class CameraSubscription {
  late Stream<double>? brightness$;
  late BehaviorSubject<double> _brightnessController;

  CameraSubscription({double currentBrightness = 0.5}) {
    _brightnessController = BehaviorSubject<double>.seeded(currentBrightness);
    brightness$ = _brightnessController.stream;
  }

  /// set brightness correction manually range [0,1] (optionnal)
  setBrightness(double brightness) {
    if (brightness < 0 || brightness > 1) {
      throw "Brightness value must be between 0 and 1";
    }
    // The stream will debounce before actually setting the brightness
    _brightnessController.sink.add(brightness);
  }

  /// Returns the current brightness without stream
  double get brightness => _brightnessController.value;

  void dispose() {
    _brightnessController.close();
  }
}
