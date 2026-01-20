enum HistoryType {
  gramUpdate,
  assignedToPrinter,
  unassignedFromPrinter,
  locationChanged,
  slotChanged,
}

class FilamentHistory {
  final int? id;
  final int filamentId;
  final DateTime createdAt;

  // Type of history record
  final HistoryType type;

  // Gram tracking (optional for movement-only records)
  final int? gram;
  final String? photo;
  final String? note;

  // Movement tracking (optional for gram-only records)
  final int? oldLocationId;
  final int? newLocationId;
  final int? oldPrinterId;
  final int? newPrinterId;
  final int? oldSlot;
  final int? newSlot;

  FilamentHistory({
    this.id,
    required this.filamentId,
    required this.createdAt,
    this.type = HistoryType.gramUpdate,
    this.gram,
    this.photo,
    this.note,
    this.oldLocationId,
    this.newLocationId,
    this.oldPrinterId,
    this.newPrinterId,
    this.oldSlot,
    this.newSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filament_id': filamentId,
      'created_at': createdAt.toIso8601String(),
      'type': type.name,
      'gram': gram,
      'photo': photo,
      'note': note,
      'old_location_id': oldLocationId,
      'new_location_id': newLocationId,
      'old_printer_id': oldPrinterId,
      'new_printer_id': newPrinterId,
      'old_slot': oldSlot,
      'new_slot': newSlot,
    };
  }

  factory FilamentHistory.fromMap(Map<String, dynamic> map) {
    return FilamentHistory(
      id: map['id'] as int?,
      filamentId: map['filament_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      type: _parseHistoryType(map['type'] as String?),
      gram: map['gram'] as int?,
      photo: map['photo'] as String?,
      note: map['note'] as String?,
      oldLocationId: map['old_location_id'] as int?,
      newLocationId: map['new_location_id'] as int?,
      oldPrinterId: map['old_printer_id'] as int?,
      newPrinterId: map['new_printer_id'] as int?,
      oldSlot: map['old_slot'] as int?,
      newSlot: map['new_slot'] as int?,
    );
  }

  static HistoryType _parseHistoryType(String? typeString) {
    if (typeString == null) return HistoryType.gramUpdate;

    try {
      return HistoryType.values.firstWhere(
        (e) => e.name == typeString,
        orElse: () => HistoryType.gramUpdate,
      );
    } catch (e) {
      return HistoryType.gramUpdate;
    }
  }

  FilamentHistory copyWith({
    int? id,
    int? filamentId,
    DateTime? createdAt,
    HistoryType? type,
    int? gram,
    String? photo,
    String? note,
    int? oldLocationId,
    int? newLocationId,
    int? oldPrinterId,
    int? newPrinterId,
    int? oldSlot,
    int? newSlot,
  }) {
    return FilamentHistory(
      id: id ?? this.id,
      filamentId: filamentId ?? this.filamentId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      gram: gram ?? this.gram,
      photo: photo ?? this.photo,
      note: note ?? this.note,
      oldLocationId: oldLocationId ?? this.oldLocationId,
      newLocationId: newLocationId ?? this.newLocationId,
      oldPrinterId: oldPrinterId ?? this.oldPrinterId,
      newPrinterId: newPrinterId ?? this.newPrinterId,
      oldSlot: oldSlot ?? this.oldSlot,
      newSlot: newSlot ?? this.newSlot,
    );
  }
}
