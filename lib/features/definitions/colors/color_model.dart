class ColorModel {
  final int id;
  final String name;
  final bool isDefault;
  final String? colorCode;

  ColorModel({
    required this.id,
    required this.name,
    required this.isDefault,
    this.colorCode,
  });

  factory ColorModel.fromMap(Map<String, dynamic> map) {
    return ColorModel(
      id: map['id'] as int,
      name: map['name'] as String,
      isDefault: (map['is_default'] as int) == 1,
      colorCode: map['color_code'] as String?,
    );
  }

  int get flutterColor {
    if (colorCode == null || colorCode!.isEmpty) {
      return 0xFF9E9E9E; // gri fallback
    }

    final cleaned = colorCode!.replaceAll('#', '').toUpperCase();

    return int.parse('FF$cleaned', radix: 16);
  }
}
