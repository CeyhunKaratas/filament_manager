class FilamentHistory {
  final int? id;
  final int filamentId;
  final int gram;
  final String? photo;
  final String? note;
  final DateTime createdAt;

  FilamentHistory({
    this.id,
    required this.filamentId,
    required this.gram,
    this.photo,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filament_id': filamentId,
      'gram': gram,
      'photo': photo,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FilamentHistory.fromMap(Map<String, dynamic> map) {
    return FilamentHistory(
      id: map['id'] as int?,
      filamentId: map['filament_id'] as int,
      gram: map['gram'] as int,
      photo: map['photo'] as String?,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  FilamentHistory copyWith({
    int? id,
    int? filamentId,
    int? gram,
    String? photo,
    String? note,
    DateTime? createdAt,
  }) {
    return FilamentHistory(
      id: id ?? this.id,
      filamentId: filamentId ?? this.filamentId,
      gram: gram ?? this.gram,
      photo: photo ?? this.photo,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
