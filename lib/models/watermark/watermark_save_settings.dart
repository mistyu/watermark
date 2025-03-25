class WatermarkSaveSettings {
  final String name;
  final bool lockTime;
  final bool lockDate;
  final bool lockAddress;
  final bool lockCoordinates;

  WatermarkSaveSettings({
    required this.name,
    this.lockTime = false,
    this.lockDate = false,
    this.lockAddress = false,
    this.lockCoordinates = false,
  });
}
