import 'filament.dart';

class FilamentGroup {
  final int brandId;
  final int materialId;
  final int colorId;

  final int count;
  final List<Filament> items;

  FilamentGroup({
    required this.brandId,
    required this.materialId,
    required this.colorId,
    required this.count,
    required this.items,
  });
}
