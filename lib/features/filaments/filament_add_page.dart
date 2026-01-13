import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import '../../core/database/filament_repository.dart';
import '../../core/models/filament.dart';
import '../../l10n/app_strings.dart';
import '../../core/database/location_repository.dart';
import '../../core/models/location.dart';
import '../definitions/colors/color_model.dart';
import '../definitions/colors/color_repository.dart';
import '../definitions/colors/color_select_popup.dart';
import '../definitions/brands/brand_model.dart';
import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_model.dart';
import '../definitions/materials/material_repository.dart';
import '../scan/camera_capture_page.dart';
import '../../core/ocr/ocr_text_extractor.dart';
import '../../core/ocr/ocr_analyzer.dart';
import '../../core/database/filament_history_repository.dart';
import '../../core/models/filament_history.dart';
import 'package:cross_file/cross_file.dart';
import '../scan/single_photo_capture_page.dart';

class FilamentAddPage extends StatefulWidget {
  const FilamentAddPage({super.key});

  @override
  State<FilamentAddPage> createState() => _FilamentAddPageState();
}

class _FilamentAddPageState extends State<FilamentAddPage> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();

  TextEditingController? _brandFieldCtrl;
  TextEditingController? _materialFieldCtrl;
  TextEditingController? _colorFieldCtrl;

  String get _brandText => (_brandFieldCtrl ?? _brandController).text;
  String get _materialText => (_materialFieldCtrl ?? _materialController).text;
  String get _colorText => (_colorFieldCtrl ?? _colorController).text;

  set _brandTextSet(String v) => (_brandFieldCtrl ?? _brandController).text = v;
  set _materialTextSet(String v) =>
      (_materialFieldCtrl ?? _materialController).text = v;
  set _colorTextSet(String v) => (_colorFieldCtrl ?? _colorController).text = v;

  final FilamentRepository _repository = FilamentRepository();
  final LocationRepository _locationRepository = LocationRepository();
  final FilamentHistoryRepository _historyRepository =
      FilamentHistoryRepository();
  final ColorRepository _colorRepository = ColorRepository();
  final BrandRepository _brandRepository = BrandRepository();
  final MaterialRepository _materialRepository = MaterialRepository();

  bool _isSaving = false;

  BrandModel? _selectedBrand;
  List<BrandModel> _allBrands = [];

  MaterialModel? _selectedMaterial;
  List<MaterialModel> _allMaterials = [];

  ColorModel? _selectedColor;
  List<ColorModel> _allColors = [];

  List<Location> _locations = [];
  Location? _selectedLocation;

  List<int> _usedBrandIds = [];
  List<int> _usedMaterialIds = [];
  List<int> _usedColorIds = [];

  String? _filamentPhotoPath;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _loadMaterials();
    _loadColors();
    _loadLocations();
    _loadUsedDefinitions();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _materialController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _loadUsedDefinitions() async {
    try {
      final filaments = await _repository.getAllFilaments();
      _usedBrandIds = filaments.map((f) => f.brandId).toSet().toList();
      _usedMaterialIds = filaments.map((f) => f.materialId).toSet().toList();
      _usedColorIds = filaments.map((f) => f.colorId).toSet().toList();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading used definitions: $e');
    }
  }

  Future<void> _loadBrands() async {
    try {
      _allBrands = await _brandRepository.getAll();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading brands: $e');
    }
  }

  Future<void> _loadMaterials() async {
    try {
      _allMaterials = await _materialRepository.getAll();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading materials: $e');
    }
  }

  Future<void> _loadColors() async {
    try {
      _allColors = await _colorRepository.getAll();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading colors: $e');
    }
  }

  Future<void> _loadLocations() async {
    try {
      _locations = await _locationRepository.getAllLocations();
      if (_locations.isNotEmpty && _selectedLocation == null) {
        _selectedLocation = _locations.first;
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading locations: $e');
    }
  }

  // -----------------------
  // OCR
  // -----------------------
  Future<void> _readFromCameraAndOcr() async {
    try {
      final photos = await Navigator.push<List<XFile>>(
        context,
        MaterialPageRoute(builder: (_) => const CameraCapturePage()),
      );

      if (!mounted || photos == null || photos.isEmpty) return;

      final paths = photos.map((e) => e.path).toList();
      final perImageTexts =
          await OcrTextExtractor.extractNormalizedTextsPerImage(paths);
      final merged = OcrTextExtractor.mergeNonEmpty(perImageTexts);
      if (merged.isEmpty) return;

      final lower = merged.toLowerCase();

      final foundBrands = _allBrands
          .where((b) => lower.contains(b.name))
          .toList();
      if (foundBrands.isNotEmpty) {
        _brandTextSet = foundBrands.first.name;
        await _handleBrandResolve(foundBrands.first.name);
      }

      final foundMaterials = _allMaterials
          .where((m) => lower.contains(m.name))
          .toList();
      if (foundMaterials.isNotEmpty) {
        _materialTextSet = foundMaterials.first.name;
        await _handleMaterialResolve(foundMaterials.first.name);
      }

      final foundColors = OcrAnalyzer.matchKeywords(
        mergedText: merged,
        keywords: _allColors.map((c) => c.name).toList(),
      );
      if (foundColors.isNotEmpty) {
        _colorTextSet = foundColors.first;
        await _handleColorResolve(foundColors.first);
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error in OCR: $e');
    }
  }

  // -----------------------
  // BRAND RESOLVE
  // -----------------------
  Future<void> _handleBrandResolve(String raw) async {
    try {
      final input = raw.trim().toLowerCase();
      if (input.isEmpty) return;

      final match = _allBrands.where((b) => b.name == input).toList();
      if (match.isNotEmpty) {
        setState(() {
          _selectedBrand = match.first;
          _brandTextSet = match.first.name;
        });
        return;
      }

      final created = await showDialog<BrandModel?>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(AppStrings.of(Localizations.localeOf(context)).addBrand),
          content: Text(input),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppStrings.of(Localizations.localeOf(context)).cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _brandRepository.add(input);
                final all = await _brandRepository.getAll();
                final b = all.firstWhere((e) => e.name == input);
                Navigator.pop(dialogContext, b);
              },
              child: Text(AppStrings.of(Localizations.localeOf(context)).ok),
            ),
          ],
        ),
      );

      if (created != null) {
        setState(() {
          _selectedBrand = created;
          _brandTextSet = created.name;
          _allBrands.add(created);
        });
      }
    } catch (e) {
      debugPrint('Error resolving brand: $e');
    }
  }

  // -----------------------
  // MATERIAL RESOLVE
  // -----------------------
  Future<void> _handleMaterialResolve(String raw) async {
    try {
      final input = raw.trim().toLowerCase();
      if (input.isEmpty) return;

      final match = _allMaterials.where((m) => m.name == input).toList();
      if (match.isNotEmpty) {
        setState(() {
          _selectedMaterial = match.first;
          _materialTextSet = match.first.name;
        });
        return;
      }

      final created = await showDialog<MaterialModel?>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            AppStrings.of(Localizations.localeOf(context)).addMaterial,
          ),
          content: Text(input),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppStrings.of(Localizations.localeOf(context)).cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _materialRepository.add(input);
                final all = await _materialRepository.getAll();
                final m = all.firstWhere((e) => e.name == input);
                Navigator.pop(dialogContext, m);
              },
              child: Text(AppStrings.of(Localizations.localeOf(context)).ok),
            ),
          ],
        ),
      );

      if (created != null) {
        setState(() {
          _selectedMaterial = created;
          _materialTextSet = created.name;
          _allMaterials.add(created);
        });
      }
    } catch (e) {
      debugPrint('Error resolving material: $e');
    }
  }

  // -----------------------
  // COLOR RESOLVE
  // -----------------------
  Future<void> _handleColorResolve(String raw) async {
    try {
      final input = raw.trim();
      if (input.isEmpty) return;

      final locale = Localizations.localeOf(context);
      final match = await _colorRepository.findByNameOrTerm(
        input,
        lang: locale.languageCode,
      );

      if (match != null) {
        setState(() {
          _selectedColor = match;
          _colorTextSet = match.name.toLowerCase();
        });
        return;
      }

      final created = await showDialog<ColorModel?>(
        context: context,
        builder: (_) => ColorSelectPopup(enteredText: input),
      );

      if (created != null) {
        setState(() {
          _selectedColor = created;
          _colorTextSet = created.name.toLowerCase();
        });
      }
    } catch (e) {
      debugPrint('Error resolving color: $e');
    }
  }

  List<String> _scannedImagePaths = [];

  Future<void> _scanOCR() async {
    try {
      final photos = await Navigator.push<List<XFile>>(
        context,
        MaterialPageRoute(builder: (_) => const CameraCapturePage()),
      );

      if (photos == null || photos.isEmpty) return;

      final imagePaths = photos.map((p) => p.path).toList();

      setState(() {
        _scannedImagePaths = imagePaths;
      });

      // Extract text
      final normalizedTexts =
          await OcrTextExtractor.extractNormalizedTextsPerImage(imagePaths);
      final mergedText = OcrTextExtractor.mergeNonEmpty(normalizedTexts);

      if (mergedText.isEmpty) return;

      // Get all keywords
      final allBrandNames = _allBrands.map((b) => b.name).toList();
      final allMaterialNames = _allMaterials.map((m) => m.name).toList();
      final allColorNames = _allColors.map((c) => c.name).toList();

      // Match keywords
      final foundBrands = OcrAnalyzer.matchKeywords(
        mergedText: mergedText,
        keywords: allBrandNames,
      );
      final foundMaterials = OcrAnalyzer.matchKeywords(
        mergedText: mergedText,
        keywords: allMaterialNames,
      );
      final foundColors = OcrAnalyzer.matchKeywords(
        mergedText: mergedText,
        keywords: allColorNames,
      );

      // Auto-fill
      setState(() {
        if (foundBrands.isNotEmpty) _brandTextSet = foundBrands.first;
        if (foundMaterials.isNotEmpty) _materialTextSet = foundMaterials.first;
        if (foundColors.isNotEmpty) _colorTextSet = foundColors.first;
      });
    } catch (e) {
      debugPrint('OCR error: $e');
    }
  }

  Future<void> _takeFilamentPhoto() async {
    try {
      final photoPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const SinglePhotoCaptureRage()),
      );

      if (photoPath != null) {
        setState(() {
          _filamentPhotoPath = photoPath;
        });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  // -----------------------
  // SAVE
  // -----------------------
  Future<void> _saveFilament() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedBrand == null && _brandText.isNotEmpty) {
        await _handleBrandResolve(_brandText);
      }
      if (_selectedMaterial == null && _materialText.isNotEmpty) {
        await _handleMaterialResolve(_materialText);
      }
      if (_selectedColor == null && _colorText.isNotEmpty) {
        await _handleColorResolve(_colorText);
      }

      if (_selectedBrand == null ||
          _selectedMaterial == null ||
          _selectedColor == null ||
          _selectedLocation == null) {
        return;
      }

      final filament = Filament(
        id: 0,
        brandId: _selectedBrand!.id,
        materialId: _selectedMaterial!.id,
        colorId: _selectedColor!.id,
        status: FilamentStatus.active,
        locationId: _selectedLocation!.id,
        mainPhotoPath: _filamentPhotoPath,
      );

      final filamentId = await _repository.insertFilament(filament);

      // Create initial history record
      final initialHistory = FilamentHistory(
        filamentId: filamentId,
        gram: 1000, // Default initial gram
        photo: _filamentPhotoPath, // Use main photo if available
        note: 'Initial record',
        createdAt: DateTime.now(),
      );
      await _historyRepository.addHistory(initialHistory);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error saving filament: $e');
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
      appBar: AppBar(title: Text(strings.addFilament)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: Text(strings.scanReadFromCamera),
                  onPressed: _scanOCR,
                ),

                const SizedBox(height: 8),

                // Filament Photo
                if (_filamentPhotoPath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_filamentPhotoPath!),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete),
                    label: Text(strings.removePhoto),
                    onPressed: () => setState(() => _filamentPhotoPath = null),
                  ),
                ] else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: Text(strings.takeFilamentPhoto),
                    onPressed: _takeFilamentPhoto,
                  ),

                const SizedBox(height: 16),

                Autocomplete<BrandModel>(
                  displayStringForOption: (b) => b.name,
                  optionsBuilder: (textEditingValue) {
                    final filtered = _allBrands.where(
                      (b) => _usedBrandIds.contains(b.id),
                    );
                    if (textEditingValue.text.isEmpty) return filtered;
                    return filtered.where(
                      (b) => b.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (b) {
                    _selectedBrand = b;
                    _brandTextSet = b.name;
                  },
                  fieldViewBuilder: (_, ctrl, f, __) {
                    _brandFieldCtrl = ctrl;
                    return Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) _handleBrandResolve(_brandText);
                      },
                      child: TextFormField(
                        controller: ctrl,
                        focusNode: f,
                        decoration: InputDecoration(labelText: strings.brand),
                        validator: (v) =>
                            v == null || v.isEmpty ? strings.required : null,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Autocomplete<MaterialModel>(
                  displayStringForOption: (m) => m.name,
                  optionsBuilder: (textEditingValue) {
                    final filtered = _allMaterials.where(
                      (m) => _usedMaterialIds.contains(m.id),
                    );
                    if (textEditingValue.text.isEmpty) return filtered;
                    return filtered.where(
                      (m) => m.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (m) {
                    _selectedMaterial = m;
                    _materialTextSet = m.name;
                  },
                  fieldViewBuilder: (_, ctrl, f, __) {
                    _materialFieldCtrl = ctrl;
                    return Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) _handleMaterialResolve(_materialText);
                      },
                      child: TextFormField(
                        controller: ctrl,
                        focusNode: f,
                        decoration: InputDecoration(
                          labelText: strings.material,
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? strings.required : null,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Autocomplete<ColorModel>(
                  displayStringForOption: (c) => c.name,
                  optionsBuilder: (textEditingValue) {
                    final filtered = _allColors.where(
                      (c) => _usedColorIds.contains(c.id),
                    );
                    if (textEditingValue.text.isEmpty) return filtered;
                    return filtered.where(
                      (c) => c.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (c) {
                    _selectedColor = c;
                    _colorTextSet = c.name;
                  },
                  fieldViewBuilder: (_, ctrl, f, __) {
                    _colorFieldCtrl = ctrl;
                    return Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) _handleColorResolve(_colorText);
                      },
                      child: TextFormField(
                        controller: ctrl,
                        focusNode: f,
                        decoration: InputDecoration(labelText: strings.color),
                        validator: (v) =>
                            v == null || v.isEmpty ? strings.required : null,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<Location>(
                  initialValue: _selectedLocation,
                  decoration: InputDecoration(labelText: strings.location),
                  items: _locations
                      .map(
                        (l) => DropdownMenuItem<Location>(
                          value: l,
                          child: Text(l.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedLocation = v),
                  validator: (v) => v == null ? strings.required : null,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isSaving ? null : _saveFilament,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
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
