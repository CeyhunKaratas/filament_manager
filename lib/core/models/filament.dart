import 'filament_material.dart';

enum FilamentStatus {
  active,
  low,
  finished,
}

class Filament {
  final int id;
  final String brand;
  final FilamentMaterial material;
  final String color;
  final FilamentStatus status;

  /// Filament'in kalıcı lokasyonu (DEFAULT = 1)
  final int locationId;

  /// Yazıcıya atanmışsa dolu olur
  final int? printerId;
  final int? slot;

  Filament({
    required this.id,
    required this.brand,
    required this.material,
    required this.color,
    required this.status,
    required this.locationId,
    this.printerId,
    this.slot,
  });

  Filament copyWith({
    int? id,
    String? brand,
    FilamentMaterial? material,
    String? color,
    FilamentStatus? status,
    int? locationId,
    int? printerId,
    int? slot,
  }) {
    return Filament(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      color: color ?? this.color,
      status: status ?? this.status,

      // location her zaman korunur, bilinçli değiştirilebilir
      locationId: locationId ?? this.locationId,

      // ⚠️ BİLİNÇLİ: null override serbest (unassign için)
      printerId: printerId,
      slot: slot,
    );
  }
}
