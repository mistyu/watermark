class NetworkBrand {
  final String name;
  final String domain;
  final String logoUrl;

  NetworkBrand({
    required this.name,
    required this.domain,
    required this.logoUrl,
  });

  factory NetworkBrand.fromJson(Map<String, dynamic> json) {
    return NetworkBrand(
      name: json['name'] ?? '',
      domain: json['domain'] ?? '',
      logoUrl: json['logo_url'] ?? '',
    );
  }

  @override
  String toString() {
    return 'NetworkBrand{name: $name, domain: $domain, logoUrl: $logoUrl}';
  }
}
