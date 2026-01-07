import 'ocr_result.dart';

class OcrAnalyzer {
  static OcrQuality evaluateOcrQuality(String text) {
    if (text.trim().isEmpty) return OcrQuality.none;

    final wordCount = text
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .length;
    if (wordCount < 3) return OcrQuality.weak;

    return OcrQuality.good;
  }

  static List<String> matchKeywords({
    required String mergedText,
    required List<String> keywords,
  }) {
    final text = mergedText.toLowerCase();

    final found = <String>{};
    for (final k in keywords) {
      final kw = k.trim().toLowerCase();
      if (kw.isEmpty) continue;

      if (_containsWord(text, kw)) {
        found.add(k); // orijinal haliyle döndür
      }
    }

    final list = found.toList();
    list.sort();
    return list;
  }

  static bool _containsWord(String haystack, String keyword) {
    final pattern = RegExp(
      r'(^|[^a-z0-9])' + RegExp.escape(keyword) + r'([^a-z0-9]|$)',
    );
    return pattern.hasMatch(haystack);
  }
}
