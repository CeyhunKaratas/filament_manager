import '../models/filament.dart';

class StatusCalculator {
  /// Calculate status based on current gram and initial gram
  ///
  /// Rules:
  /// - gram == 0 → FINISHED
  /// - gram <= initial_gram * 0.20 → LOW
  /// - gram < initial_gram → USED
  /// - gram == initial_gram → ACTIVE
  static FilamentStatus calculateStatus({
    required int currentGram,
    required int initialGram,
  }) {
    if (currentGram == 0) {
      return FilamentStatus.finished;
    } else if (currentGram <= (initialGram * 0.20).round()) {
      return FilamentStatus.low;
    } else if (currentGram < initialGram) {
      return FilamentStatus.used;
    } else {
      return FilamentStatus.active;
    }
  }
}
