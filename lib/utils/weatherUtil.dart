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
