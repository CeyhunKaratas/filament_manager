import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrTextExtractor {
  static Future<List<String>> extractNormalizedTextsPerImage(
    List<String> imagePaths,
  ) async {
    if (imagePaths.isEmpty) return [];

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final texts = <String>[];

    try {
      for (final path in imagePaths) {
        final file = File(path);
        if (!file.existsSync()) {
          texts.add('');
          continue;
        }

        final inputImage = InputImage.fromFilePath(path);
        final result = await recognizer.processImage(inputImage);

        texts.add(_normalizeOcrText(result.text));
      }
    } finally {
      recognizer.close();
    }

    return texts;
  }

  static String mergeNonEmpty(List<String> normalizedTexts) {
    final buffer = StringBuffer();

    for (final t in normalizedTexts) {
      if (t.trim().isEmpty) continue;
      buffer.writeln(t);
    }

    return buffer.toString().trim();
  }

  static String _normalizeOcrText(String raw) {
    if (raw.trim().isEmpty) return '';

    final lines = raw
        .toLowerCase()
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toSet();

    return lines.join('\n');
  }
}
