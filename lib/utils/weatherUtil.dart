class WeatherData {
  final int icon;
  final String temperature;
  final String temperatureWindDirection;

  WeatherData({
    required this.icon,
    required this.temperature,
    required this.temperatureWindDirection,
  });

  @override
  String toString() {
    return 'WeatherData(icon: $icon, temperature: $temperature, temperatureWindDirection: $temperatureWindDirection)';
  }
}

WeatherData parseWeatherString(String input) {
  // 初始化默认值
  String icon = '';
  String temperature = '';
  String temperatureWindDirection = '';

  // 按分号 `;` 分割键值对
  final parts = input.split(';');

  for (final part in parts) {
    // 按冒号 `:` 分割键和值
    final keyValue = part.split(':');
    if (keyValue.length == 2) {
      final key = keyValue[0].trim();
      final value = keyValue[1].trim();

      // 根据 key 设置对应的属性
      switch (key) {
        case 'icon':
          icon = value;
          break;
        case 'temperature':
          temperature = value;
          break;
        case 'temperaturewindDirection':
          temperatureWindDirection = value;
          break;
      }
    }
  }

  return WeatherData(
    icon: int.parse(icon),
    temperature: temperature,
    temperatureWindDirection: temperatureWindDirection,
  );
}

class WeatherUtils {
  static String getWeatherIcon(int icon) {
    switch (icon) {
      case 0:
        return 'assets/weather/0.png'; // 晴天
      case 1:
        return 'assets/weather/1.png'; // 多云
      case 2:
        return 'assets/weather/2.png'; // 阴天
      case 3:
        return 'assets/weather/3.png'; // 小雨
      case 4:
        return 'assets/weather/4.png'; // 中雨
      case 5:
        return 'assets/weather/5.png'; // 大雨
      default:
        return 'assets/weather/default.png'; // 默认图标
    }
  }

  static String getSymbol(int tmeplateId) {
    String symbol = "℃";
    if (!showWeatherIcon(tmeplateId)) {
      symbol = "°";
      if (tmeplateId == 1698049456677) {
        symbol = "℃";
      }
    }
    return symbol;
  }

  static bool showWeatherIcon(int tmeplateId) {
    return tmeplateId == 1698317868899 || tmeplateId == 1698049354422;
  }

  static String defaultWeather(tmeplateId) {
    if (tmeplateId == 1698049456677) {
      return "多云 28℃";
    }
    return "多云 28°";
  }
}
