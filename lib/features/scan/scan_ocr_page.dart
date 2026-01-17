import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/ocr/ocr_analyzer.dart';
import '../../core/ocr/ocr_result.dart';
import '../../core/ocr/ocr_text_extractor.dart';
import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';
import 'camera_capture_page.dart';

import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_repository.dart';
import '../definitions/colors/color_repository.dart';

enum ScanPhase { idle, processingOcr, resultReady }

class ScanOcrPage extends StatefulWidget {
  const ScanOcrPage({super.key});

  @override
  State<ScanOcrPage> createState() => _ScanOcrPageState();
}

class _ScanOcrPageState extends State<ScanOcrPage> {
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

    try {
      final paths = _capturedImages.map((e) => e.path).toList();

      final perImageTexts =
          await OcrTextExtractor.extractNormalizedTextsPerImage(paths);

      final perImageQuality = <OcrQuality>[];
      for (final t in perImageTexts) {
        perImageQuality.add(OcrAnalyzer.evaluateOcrQuality(t));
      }

      final merged = OcrTextExtractor.mergeNonEmpty(perImageTexts);

      final brandRepo = BrandRepository();
      final materialRepo = MaterialRepository();
      final colorRepo = ColorRepository();

      final brands = await brandRepo.getAll();
      final materials = await materialRepo.getAll();
      final colors = await colorRepo.getAll();

      final foundBrands = OcrAnalyzer.matchKeywords(
        mergedText: merged,
        keywords: brands.map((e) => e.name).toList(),
      );

      final foundMaterials = OcrAnalyzer.matchKeywords(
        mergedText: merged,
        keywords: materials.map((e) => e.name).toList(),
      );

      final foundColors = OcrAnalyzer.matchKeywords(
        mergedText: merged,
        keywords: colors.map((e) => e.name).toList(),
      );

      setState(() {
        _ocrTextsPerImage.addAll(perImageTexts);
        _ocrQualityPerImage.addAll(perImageQuality);

        _mergedOcrText = merged;

        _foundBrands.addAll(foundBrands);
        _foundMaterials.addAll(foundMaterials);
        _foundColors.addAll(foundColors);

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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(s.scanProcessing),
            ],
          ),
        );

      case ScanPhase.resultReady:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],

              _buildKeywordSection(context, s),
              const SizedBox(height: 24),

              Text(
                s.scanMergedOcrTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(
                _mergedOcrText.isEmpty ? s.scanOcrRawTextEmpty : _mergedOcrText,
              ),
              const SizedBox(height: 24),

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
                            'foto ${i + 1} – ${_qualityLabel(_ocrQualityPerImage[i])}',
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

  Widget _buildKeywordSection(BuildContext context, AppStrings s) {
    Widget chips(List<String> items) {
      if (items.isEmpty) {
        return Text(s.scanOcrAnalysisEmpty);
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
          s.scanOcrAnalysisTitle,
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
