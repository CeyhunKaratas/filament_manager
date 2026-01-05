import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';

class ScanOcrPage extends StatefulWidget {
  const ScanOcrPage({super.key});

  @override
  State<ScanOcrPage> createState() => _ScanOcrPageState();
}

class _ScanOcrPageState extends State<ScanOcrPage> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  XFile? _image;
  String _rawText = '';
  bool _isRunning = false;
  String? _error;

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _takePhotoAndRunOcr() async {
    setState(() {
      _error = null;
      _isRunning = true;
      _rawText = '';
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
      );

      if (!mounted) return;

      if (picked == null) {
        setState(() {
          _isRunning = false;
        });
        return;
      }

      final inputImage = InputImage.fromFilePath(picked.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      if (!mounted) return;

      setState(() {
        _image = picked;
        _rawText = recognizedText.text;
        _isRunning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isRunning = false;
        _error: e.toString();
      });
    }
  }

  List<String> _extractKeywordHits(String text) {
    final normalized = text.toLowerCase();

    const candidates = <String>[
      // Materials
      'pla',
      'petg',
      'abs',
      'asa',
      'tpu',
      'nylon',
      'pa',
      'pc',
      // Common brands
      'bambu',
      'bambulab',
      'prusa',
      'prusament',
      'esun',
      'sunlu',
      'polymaker',
      'overture',
      'hatchbox',
      'colorfabb',
      'anycubic',
      'creality',
      // Misc
      '1.75',
      '2.85',
      'mm',
      'kg',
      'g',
      '°c',
      'c',
      'nozzle',
      'bed'
    ];

    final hits = <String>[];
    final seen = <String>{};
    for (final c in candidates) {
      if (normalized.contains(c)) {
        if (!seen.contains(c)) {
          seen.add(c);
          hits.add(c);
        }
      }
    }

    return hits;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(Localizations.localeOf(context));
    final keywordHits =
        _rawText.isEmpty ? <String>[] : _extractKeywordHits(_rawText);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.scanOcrTitle),
      ),
      drawer: const AppDrawer(current: 'scan'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? null : _takePhotoAndRunOcr,
                icon: const Icon(Icons.camera_alt),
                label: Text(s.scanOcrTakePhoto),
              ),
              if (_isRunning) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  '${s.error}: $_error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (_image != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                s.scanOcrRawTextTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  _rawText.isEmpty ? s.scanOcrRawTextEmpty : _rawText,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.scanOcrAnalysisTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (keywordHits.isEmpty)
                Text(s.scanOcrAnalysisEmpty)
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final hit in keywordHits) Chip(label: Text(hit)),
                  ],
                ),
              const SizedBox(height: 24),
              Text(
                s.scanOcrNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
