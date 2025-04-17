class Address {
  final int id;
  final String label;
  final String name;
  final String phone;
  final String addressMap;
  final String province;
  final String city;
  final String district;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.addressMap,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['address_label'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone_number'] ?? '',
      addressMap: json['address_map'] ?? '',
      province: json['province_name'] ?? '',
      city: json['district_name'] ?? '',
      district: json['sub_district_name'] ?? '',
      postalCode: json['postal_code'] ?? '',
      isDefault: json['is_default'] == 1,
    );
  }
}
