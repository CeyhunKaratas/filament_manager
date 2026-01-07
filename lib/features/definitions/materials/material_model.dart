class MaterialModel {
  final int id;
  final String name;
  final bool isDefault;

  MaterialModel({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['id'] as int,
      name: map['name'] as String,
      isDefault: (map['is_default'] as int) == 1,
    );
  }
}
