enum FilamentStatus { active, low, finished }

class Filament {
  final int id;

  final int brandId;
  final int materialId;
  final int colorId;

  final FilamentStatus status;

  /// Filament'in kalıcı lokasyonu (DEFAULT = 1)
  final int locationId;

  /// Yazıcıya atanmışsa dolu olur
  final int? printerId;
  final int? slot;

  /// Ana fotoğraf yolu (opsiyonel)
  final String? mainPhotoPath;

  Filament({
    required this.id,
    required this.brandId,
    required this.materialId,
    required this.colorId,
    required this.status,
    required this.locationId,
    this.printerId,
    this.slot,
    this.mainPhotoPath,
  });

  Filament copyWith({
    int? id,
    int? brandId,
    int? materialId,
    int? colorId,
    FilamentStatus? status,
    int? locationId,
    int? printerId,
    int? slot,
    String? mainPhotoPath,
  }) {
    return Filament(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      materialId: materialId ?? this.materialId,
      colorId: colorId ?? this.colorId,
      status: status ?? this.status,
      locationId: locationId ?? this.locationId,
      printerId: printerId,
      slot: slot,
      mainPhotoPath: mainPhotoPath ?? this.mainPhotoPath,
    );
  }
}
