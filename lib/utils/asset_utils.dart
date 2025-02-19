extension AssetPath on String {
  String get svg => "assets/svg/$this.svg";
  String get png => "assets/images/$this.png";
  String get jpg => "assets/images/$this.jpg";
  String get jpeg => "assets/images/$this.jpeg";
  String get webp => "assets/webp/$this.webp";
}
