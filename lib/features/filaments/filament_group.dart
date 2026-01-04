import '../../core/models/filament.dart';
import '../../core/models/filament_material.dart';

class FilamentGroup {
  final String brand;
  final FilamentMaterial material;
  final String color;
  final int count;
  final List<Filament> items;

  FilamentGroup({
    required this.brand,
    required this.material,
    required this.color,
    required this.count,
    required this.items,
  });
}
