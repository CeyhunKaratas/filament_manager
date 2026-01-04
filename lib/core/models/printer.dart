class Printer {
  final int? id;
  final String name;
  final String? brandModel;
  final int slotCount;
  final String? notes;

  Printer({
    this.id,
    required this.name,
    this.brandModel,
    required this.slotCount,
    this.notes,
  });
}
