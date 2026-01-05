import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';
import 'camera_capture_page.dart';

enum ScanPhase { idle, processingOcr, resultReady }

enum OcrQuality { none, weak, good }

class ScanOcrPage extends StatefulWidget {
  const ScanOcrPage({super.key});

  @override
  State<ScanOcrPage> createState() => _ScanOcrPageState();
}

class _ScanOcrPageState extends State<ScanOcrPage> {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  ScanPhase _phase = ScanPhase.idle;

  final List<XFile> _capturedImages = [];
  final List<String> _ocrTextsPerImage = [];
  final List<OcrQuality> _ocrQualityPerImage = [];

  String _mergedOcrText = '';
  String? _error;

  // --- Keyword Analysis State (TEST ONLY) ---
  final List<String> _foundBrands = [];
  final List<String> _foundMaterials = [];
  final List<String> _foundColors = [];

  // Basit demo listeleri (istersen genişletiriz)
  static const List<String> _brandKeywords = [
    'anycubic',
    'creality',
    'bambu',
    'bambulab',
    'prusa',
    'elegoo',
    'sunlu',
    'esun',
    'polymaker',
  ];

  static const List<String> _materialKeywords = [
    'pla',
    'petg',
    'abs',
    'asa',
    'tpu',
    'nylon',
    'pa',
    'pc',
    'pva',
  ];

  static const List<String> _colorKeywords = [
    'yellow',
    'red',
    'blue',
    'green',
    'black',
    'white',
    'grey',
    'gray',
    'orange',
    'purple',
    'pink',
    'brown',
    'silver',
    'gold',
    'transparent',
    'clear',
  ];

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // ---------- CAMERA ----------

  Future<void> _readFromCamera() async {
    final photos = await Navigator.push<List<XFile>>(
      context,
      MaterialPageRoute(builder: (_) => const CameraCapturePage()),
    );

    if (!mounted || photos == null || photos.isEmpty) return;

    _capturedImages
      ..clear()
      ..addAll(photos);

    await _processOcr();
  }

  // ---------- OCR ----------

  Future<void> _processOcr() async {
    if (_capturedImages.isEmpty) return;

    setState(() {
      _phase = ScanPhase.processingOcr;

      _ocrTextsPerImage.clear();
      _ocrQualityPerImage.clear();
      _mergedOcrText = '';
      _error = null;

      _foundBrands.clear();
      _foundMaterials.clear();
      _foundColors.clear();
    });

    final buffer = StringBuffer();

    try {
      for (final image in _capturedImages) {
        final inputImage = InputImage.fromFilePath(image.path);
        final result = await _textRecognizer.processImage(inputImage);

        final normalized = _normalizeOcrText(result.text);
        final quality = _evaluateOcrQuality(normalized);

        _ocrTextsPerImage.add(normalized);
        _ocrQualityPerImage.add(quality);

        if (normalized.isNotEmpty) {
          buffer.writeln(normalized);
        }
      }

      final merged = buffer.toString().trim();
      final analysis = _analyzeKeywords(merged);

      setState(() {
        _mergedOcrText = merged;

        _foundBrands.addAll(analysis.foundBrands);
        _foundMaterials.addAll(analysis.foundMaterials);
        _foundColors.addAll(analysis.foundColors);

        _phase = ScanPhase.resultReady;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _phase = ScanPhase.idle;
      });
    }
  }

  void _resetSession() {
    setState(() {
      _phase = ScanPhase.idle;

      _capturedImages.clear();
      _ocrTextsPerImage.clear();
      _ocrQualityPerImage.clear();

      _mergedOcrText = '';
      _error = null;

      _foundBrands.clear();
      _foundMaterials.clear();
      _foundColors.clear();
    });
  }

  // ---------- HELPERS ----------

  String _normalizeOcrText(String raw) {
    if (raw.trim().isEmpty) return '';

    final lines = raw
        .toLowerCase()
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toSet();

    return lines.join('\n');
  }

  OcrQuality _evaluateOcrQuality(String text) {
    if (text.trim().isEmpty) return OcrQuality.none;

    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount < 3) return OcrQuality.weak;

    return OcrQuality.good;
  }

  String _qualityLabel(OcrQuality q) {
    switch (q) {
      case OcrQuality.none:
        return '❌ metin yok';
      case OcrQuality.weak:
        return '⚠️ zayıf';
      case OcrQuality.good:
        return '✅ iyi';
    }
  }

  _KeywordAnalysisResult _analyzeKeywords(String mergedText) {
    final text = mergedText.toLowerCase();

    final brands = _brandKeywords.where((k) => _containsWord(text, k)).toSet();
    final materials = _materialKeywords
        .where((k) => _containsWord(text, k))
        .toSet();
    final colors = _colorKeywords.where((k) => _containsWord(text, k)).toSet();

    return _KeywordAnalysisResult(
      foundBrands: brands.toList()..sort(),
      foundMaterials: materials.toList()..sort(),
      foundColors: colors.toList()..sort(),
    );
  }

  bool _containsWord(String haystack, String keyword) {
    // basit word boundary: harf/sayı dışı karakterlerle sınırlandır
    final pattern = RegExp(
      r'(^|[^a-z0-9])' + RegExp.escape(keyword) + r'([^a-z0-9]|$)',
    );
    return pattern.hasMatch(haystack);
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(s.scanOcrTitle)),
      drawer: const AppDrawer(current: 'scan'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(context, s),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    switch (_phase) {
      case ScanPhase.idle:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _readFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: Text(s.scanReadFromCamera),
            ),
            const SizedBox(height: 12),
            Text(
              s.scanCaptureInstruction,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );

      case ScanPhase.processingOcr:
        return const Center(child: CircularProgressIndicator());

      case ScanPhase.resultReady:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],

              // --- KEYWORD ANALYSIS (TEST) ---
              _buildKeywordSection(context),

              const SizedBox(height: 24),

              // --- MERGED OCR ---
              Text(
                s.scanMergedOcrTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(
                _mergedOcrText.isEmpty ? s.scanOcrRawTextEmpty : _mergedOcrText,
              ),

              const SizedBox(height: 24),

              // --- PER PHOTO OCR ---
              Text(
                s.scanPerPhotoOcrTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              for (int i = 0; i < _capturedImages.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(
                      File(_capturedImages[i].path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'foto ${i + 1} — ${_qualityLabel(_ocrQualityPerImage[i])}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            _ocrTextsPerImage[i].isEmpty
                                ? '(ocr metni yok)'
                                : _ocrTextsPerImage[i],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
              ],

              ElevatedButton(
                onPressed: _resetSession,
                child: Text(s.scanStartNewSession),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildKeywordSection(BuildContext context) {
    Widget chips(List<String> items) {
      if (items.isEmpty) {
        return const Text('—');
      }
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((e) => Chip(label: Text(e))).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'basit analiz (test)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        Text('brand'),
        chips(_foundBrands),
        const SizedBox(height: 12),

        Text('material'),
        chips(_foundMaterials),
        const SizedBox(height: 12),

        Text('color'),
        chips(_foundColors),
      ],
    );
  }
}

class _KeywordAnalysisResult {
  final List<String> foundBrands;
  final List<String> foundMaterials;
  final List<String> foundColors;

  _KeywordAnalysisResult({
    required this.foundBrands,
    required this.foundMaterials,
    required this.foundColors,
  });
}
