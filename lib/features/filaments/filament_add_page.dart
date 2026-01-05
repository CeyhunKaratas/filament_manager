import 'package:flutter/material.dart';

import '../../core/database/filament_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/filament_material.dart';
import '../../l10n/app_strings.dart';
import '../../core/database/location_repository.dart';
import '../../core/models/location.dart';

class FilamentAddPage extends StatefulWidget {
  const FilamentAddPage({super.key});

  @override
  State<FilamentAddPage> createState() => _FilamentAddPageState();
}

class _FilamentAddPageState extends State<FilamentAddPage> {
  final Map<String, Color> _presetColors = {
    'black': Colors.black,
    'white': Colors.white,
    'gray': Colors.grey,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
    'cyan': Colors.cyan,
    'magenta': Colors.pinkAccent,
    'lime': Colors.lime,
    'teal': Colors.teal,
    'transparent': Colors.transparent,
    'natural': const Color(0xFFD7CFC4),
  };

  // ✅ PRESET BRAND LIST (KANONİK: lowercase)
  final List<String> _presetBrands = const [
    'prusa',
    'esun',
    'sunlu',
    'bambulab',
    'elegoo',
    'creality',
    'anycubic',
    'polymaker',
    'overture',
  ];

  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _colorController = TextEditingController();

  FilamentMaterial _selectedMaterial = FilamentMaterial.pla;
  final FilamentRepository _repository = FilamentRepository();
  final LocationRepository _locationRepository = LocationRepository();

  List<String> _brands = [];
  List<String> _colors = [];

  // 🔹 COLOR STATE (TEK GERÇEK KAYNAK)
  List<String> _availableColors = [];

  // 🔹 BRAND STATE (TEK GERÇEK KAYNAK)
  List<String> _availableBrands = [];

  // 🔹 LOCATION STATE
  List<Location> _locations = [];
  Location? _selectedLocation;

  bool _isCustomBrand = false;
  bool _isCustomColor = false;

  @override
  void initState() {
    super.initState();
    _loadSmartValues();
    _loadLocations();
  }

  Future<void> _loadSmartValues() async {
    _brands = await _repository.getDistinctValues('brand');
    _colors = await _repository.getDistinctValues('color');

    // ✅ PRESET + DB COLOR MERGE (BİR KEZ)
    _availableColors = {..._presetColors.keys, ..._colors}.toList();

    // ✅ PRESET + DB BRAND MERGE (BİR KEZ)
    // DB’den gelen brand’ler geçmişte farklı case ile kaydedilmiş olabilir.
    // Burada sadece dropdown listesi için normalize edip birleştiriyoruz.
    _availableBrands = {
      ..._presetBrands,
      ..._brands.map((b) => b.trim().toLowerCase()),
    }.toList();

    if (mounted) setState(() {});
  }

  Future<void> _loadLocations() async {
    _locations = await _locationRepository.getAllLocations();

    if (_locations.length == 1) {
      _selectedLocation = _locations.first;
    }

    if (mounted) setState(() {});
  }

  Future<void> _saveFilament() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) return;

    final filament = Filament(
      id: 0,
      brand: _brandController.text.trim().toLowerCase(),
      material: _selectedMaterial,
      color: _colorController.text.trim().toLowerCase(),
      status: FilamentStatus.active,
      locationId: _selectedLocation!.id,
    );

    await _repository.insertFilament(filament);

    if (mounted) {
      Navigator.pop(context, true);
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
                /// BRAND
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: strings.brand),
                  items: [
                    ..._availableBrands.map(
                      (v) => DropdownMenuItem(value: v, child: Text(v)),
                    ),
                    DropdownMenuItem(
                      value: '__new__',
                      child: Text(strings.addNew),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _isCustomBrand = (v == '__new__');
                      if (!_isCustomBrand && v != null) {
                        _brandController.text = v.trim().toLowerCase();
                      }
                    });
                  },
                  validator: (_) =>
                      _brandController.text.isEmpty ? strings.required : null,
                ),

                if (_isCustomBrand) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(labelText: strings.newBrand),
                    validator: (v) =>
                        v == null || v.isEmpty ? strings.required : null,
                  ),
                ],

                const SizedBox(height: 12),

                /// MATERIAL
                DropdownButtonFormField<FilamentMaterial>(
                  initialValue: _selectedMaterial,
                  decoration: InputDecoration(labelText: strings.material),
                  items: FilamentMaterial.values.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedMaterial = v!),
                ),

                const SizedBox(height: 12),

                /// COLOR
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: strings.color),
                  items: [
                    ..._availableColors.map(
                      (v) => DropdownMenuItem(value: v, child: _colorItem(v)),
                    ),
                    DropdownMenuItem(
                      value: '__new__',
                      child: Text(strings.addNew),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _isCustomColor = (v == '__new__');
                      if (!_isCustomColor && v != null) {
                        _colorController.text = v.trim().toLowerCase();
                      }
                    });
                  },
                  validator: (_) =>
                      _colorController.text.isEmpty ? strings.required : null,
                ),

                if (_isCustomColor) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(labelText: strings.newColor),
                    validator: (v) =>
                        v == null || v.isEmpty ? strings.required : null,
                  ),
                ],

                /// 🔹 LOCATION
                if (_locations.length > 1) ...[
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
                ],

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _saveFilament,
                  child: Text(strings.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorItem(String value) {
    final c = _presetColors[value];
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: c ?? Colors.transparent,
            border: Border.all(color: Colors.grey),
          ),
        ),
        Text(value),
      ],
    );
  }
}
