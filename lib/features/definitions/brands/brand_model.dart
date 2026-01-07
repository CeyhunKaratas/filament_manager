class BrandModel {
  final int id;
  final String name;
  final bool isDefault;

  BrandModel({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'] as int,
      name: map['name'] as String,
      isDefault: (map['is_default'] as int) == 1,
    );
  }
}
