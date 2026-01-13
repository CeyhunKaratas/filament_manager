import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../../core/database/filament_history_repository.dart';
import '../../core/models/filament_history.dart';
import '../../core/models/filament.dart';
import '../../l10n/app_strings.dart';
import '../scan/single_photo_capture_page.dart';
import 'package:cross_file/cross_file.dart';

class FilamentHistoryAddPage extends StatefulWidget {
  final Filament filament;
  final int? lastGram;

  const FilamentHistoryAddPage({
    super.key,
    required this.filament,
    this.lastGram,
  });

  @override
  State<FilamentHistoryAddPage> createState() => _FilamentHistoryAddPageState();
}

class _FilamentHistoryAddPageState extends State<FilamentHistoryAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _gramController = TextEditingController();
  final _noteController = TextEditingController();

  final FilamentHistoryRepository _historyRepo = FilamentHistoryRepository();

  bool _isSaving = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _gramController.text = (widget.lastGram ?? 1000).toString();
  }

  @override
  void dispose() {
    _gramController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final photoPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const SinglePhotoCaptureRage()),
      );

      if (photoPath != null) {
        setState(() {
          _photoPath = photoPath;
        });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Future<void> _saveHistory() async {
    if (!_formKey.currentState!.validate()) return;

    final gram = int.parse(_gramController.text);

    if (gram == 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          final strings = AppStrings.of(Localizations.localeOf(context));
          return AlertDialog(
            title: Text(strings.confirmFinished),
            content: Text(strings.confirmFinishedMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(strings.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(strings.markAsFinished),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final history = FilamentHistory(
        filamentId: widget.filament.id,
        gram: gram,
        photo: _photoPath,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _historyRepo.addHistory(history);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving history: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(strings.saveStatus)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.currentStatus,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${strings.lastRecordedGram}: ${widget.lastGram ?? 1000}g',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _gramController,
                  decoration: InputDecoration(
                    labelText: '${strings.gram} (g)',
                    border: const OutlineInputBorder(),
                    helperText: strings.enterCurrentGram,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return strings.required;
                    }
                    final gram = int.tryParse(value);
                    if (gram == null || gram < 0) {
                      return strings.invalidGram;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Photo section
                if (_photoPath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_photoPath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.delete),
                        label: Text(strings.removePhoto),
                        onPressed: () {
                          setState(() {
                            _photoPath = null;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: Text(strings.retakePhoto),
                        onPressed: _takePhoto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: Text(strings.takePhoto),
                    onPressed: _takePhoto,
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: '${strings.note} (${strings.optional})',
                    border: const OutlineInputBorder(),
                    hintText: strings.addNoteHint,
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isSaving ? null : _saveHistory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(strings.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
