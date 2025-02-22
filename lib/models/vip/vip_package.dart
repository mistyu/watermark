class VipPackage {
  final int id;
  final String packageName;
  final String packageType;
  final double price;
  final int durationDays;
  final String status;
  double originalPrice;

  VipPackage({
    this.id = 0,
    this.packageName = '',
    this.packageType = '0',
    this.price = 0.0,
    this.durationDays = 0,
    this.status = '0',
    this.originalPrice = 0.0,
  });

  factory VipPackage.fromJson(Map<String, dynamic> json) {
    return VipPackage(
      id: json['id'] ?? 0,
      packageName: json['packageName']?.toString() ?? '',
      packageType: json['packageType']?.toString() ?? '0',
      price: (json['price'] ?? 0.0).toDouble(),
      durationDays: json['durationDays'] ?? 0,
      status: json['status']?.toString() ?? '0',
      originalPrice: (json['originalPrice'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'VipPackage{id: $id, packageName: $packageName, packageType: $packageType, '
        'price: $price, durationDays: $durationDays, status: $status}';
  }
}
