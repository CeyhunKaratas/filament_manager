import 'package:flutter/material.dart';
import '../../core/database/filament_repository.dart';
import '../../core/models/filament.dart';
import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';

import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_repository.dart';
import '../definitions/colors/color_repository.dart';
import '../definitions/colors/color_model.dart';
import '../../core/database/location_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/location.dart';
import '../../core/models/printer.dart';

class InventoryReportPage extends StatefulWidget {
  const InventoryReportPage({super.key});

  @override
  State<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends State<InventoryReportPage> {
  final FilamentRepository _repository = FilamentRepository();
  final BrandRepository _brandRepo = BrandRepository();
  final MaterialRepository _materialRepo = MaterialRepository();
  final ColorRepository _colorRepo = ColorRepository();
  final LocationRepository _locationRepo = LocationRepository();
  final PrinterRepository _printerRepo = PrinterRepository();

  List<Filament> _allFilaments = [];
  List<Filament> _filteredFilaments = [];

  final Map<int, String> _brandNames = {};
  final Map<int, String> _materialNames = {};
  final Map<int, ColorModel> _colors = {};
  final Map<int, Location> _locations = {};
  final Map<int, Printer> _printers = {};

  bool _isLoading = true;
  bool _showFinished = false;

  FilamentStatus? _filterStatus;
  int? _filterBrand;
  int? _filterMaterial;
  int? _filterColor;
  int? _filterLocation;
  String _sortBy = 'id'; // id, brand, material, status, location
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load all data
      final filaments = await _repository.getAllFilaments();
      final brands = await _brandRepo.getAll();
      final materials = await _materialRepo.getAll();
      final colors = await _colorRepo.getAll();
      final locations = await _locationRepo.getAllLocations();
      final printers = await _printerRepo.getAllPrinters();

      // Build lookup maps
      for (final b in brands) {
        _brandNames[b.id] = b.name;
      }
      for (final m in materials) {
        _materialNames[m.id] = m.name;
      }
      for (final c in colors) {
        _colors[c.id] = c;
      }
      for (final l in locations) {
        _locations[l.id] = l;
      }
      for (final p in printers) {
        _printers[p.id!] = p;
      }

      if (mounted) {
        setState(() {
          _allFilaments = filaments;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    _filteredFilaments = _allFilaments.where((f) {
      // Show finished filter
      if (!_showFinished && f.status == FilamentStatus.finished) {
        return false;
      }

      // Status filter
      if (_filterStatus != null && f.status != _filterStatus) {
        return false;
      }

      // Brand filter
      if (_filterBrand != null && f.brandId != _filterBrand) {
        return false;
      }

      // Material filter
      if (_filterMaterial != null && f.materialId != _filterMaterial) {
        return false;
      }

      // Color filter
      if (_filterColor != null && f.colorId != _filterColor) {
        return false;
      }

      // Location filter
      if (_filterLocation != null && f.locationId != _filterLocation) {
        return false;
      }

      return true;
    }).toList();

    _applySorting();
  }

  void _toggleFinished(bool value) {
    setState(() {
      _showFinished = value;
      _applyFilters();
    });
  }

  // Get only used brands/materials/colors/locations
  List<int> get _usedBrandIds =>
      _allFilaments.map((f) => f.brandId).toSet().toList();

  List<int> get _usedMaterialIds =>
      _allFilaments.map((f) => f.materialId).toSet().toList();

  List<int> get _usedColorIds =>
      _allFilaments.map((f) => f.colorId).toSet().toList();

  List<int> get _usedLocationIds =>
      _allFilaments.map((f) => f.locationId).toSet().toList();

  void _applySorting() {
    _filteredFilaments.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'id':
          comparison = a.id.compareTo(b.id);
          break;
        case 'brand':
          final brandA = _brandNames[a.brandId] ?? '';
          final brandB = _brandNames[b.brandId] ?? '';
          comparison = brandA.compareTo(brandB);
          break;
        case 'material':
          final matA = _materialNames[a.materialId] ?? '';
          final matB = _materialNames[b.materialId] ?? '';
          comparison = matA.compareTo(matB);
          break;
        case 'status':
          comparison = a.status.index.compareTo(b.status.index);
          break;
        case 'location':
          final locA = _locations[a.locationId]?.name ?? '';
          final locB = _locations[b.locationId]?.name ?? '';
          comparison = locA.compareTo(locB);
          break;
      }

      return _sortAscending ? comparison : -comparison;
    });
  }

  void _showSortDialog() async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.sortBy),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Spool ID'),
                value: 'id',
                groupValue: _sortBy,
                onChanged: (v) => setDialogState(() => _sortBy = v!),
              ),
              RadioListTile<String>(
                title: Text(strings.brand),
                value: 'brand',
                groupValue: _sortBy,
                onChanged: (v) => setDialogState(() => _sortBy = v!),
              ),
              RadioListTile<String>(
                title: Text(strings.material),
                value: 'material',
                groupValue: _sortBy,
                onChanged: (v) => setDialogState(() => _sortBy = v!),
              ),
              RadioListTile<String>(
                title: Text(strings.status),
                value: 'status',
                groupValue: _sortBy,
                onChanged: (v) => setDialogState(() => _sortBy = v!),
              ),
              RadioListTile<String>(
                title: Text(strings.location),
                value: 'location',
                groupValue: _sortBy,
                onChanged: (v) => setDialogState(() => _sortBy = v!),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(strings.ascending),
                value: _sortAscending,
                onChanged: (v) => setDialogState(() => _sortAscending = v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _applyFilters();
              });
              Navigator.pop(context);
            },
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.filterBy),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status filter
                Text(
                  strings.status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<FilamentStatus?>(
                  isExpanded: true,
                  value: _filterStatus,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allStatuses),
                    ),
                    ...FilamentStatus.values.map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(strings.statusLabel(s)),
                      ),
                    ),
                  ],
                  onChanged: (v) => setDialogState(() => _filterStatus = v),
                ),

                const SizedBox(height: 16),

                // Brand filter
                Text(
                  strings.brand,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: _filterBrand,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allBrands),
                    ),
                    ..._brandNames.entries
                        .where((e) => _usedBrandIds.contains(e.key))
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ),
                        ),
                  ],
                  onChanged: (v) => setDialogState(() => _filterBrand = v),
                ),

                const SizedBox(height: 16),

                // Material filter
                Text(
                  strings.material,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: _filterMaterial,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allMaterials),
                    ),
                    ..._materialNames.entries
                        .where((e) => _usedMaterialIds.contains(e.key))
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ),
                        ),
                  ],
                  onChanged: (v) => setDialogState(() => _filterMaterial = v),
                ),

                const SizedBox(height: 16),

                // Color filter
                Text(
                  strings.color,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: _filterColor,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allColors),
                    ),
                    ..._colors.entries
                        .where((e) => _usedColorIds.contains(e.key))
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value.name),
                          ),
                        ),
                  ],
                  onChanged: (v) => setDialogState(() => _filterColor = v),
                ),

                const SizedBox(height: 16),

                // Location filter
                Text(
                  strings.location,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: _filterLocation,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allLocations),
                    ),
                    ..._locations.entries
                        .where((e) => _usedLocationIds.contains(e.key))
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value.name),
                          ),
                        ),
                  ],
                  onChanged: (v) => setDialogState(() => _filterLocation = v),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterStatus = null;
                _filterBrand = null;
                _filterMaterial = null;
                _filterColor = null;
                _filterLocation = null;
                _applyFilters();
              });
              Navigator.pop(context);
            },
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _applyFilters();
              });
              Navigator.pop(context);
            },
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'reports'),
      appBar: AppBar(
        title: Text(strings.inventoryReport),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Show Finished Toggle
                CheckboxListTile(
                  title: Text(strings.showFinished),
                  value: _showFinished,
                  onChanged: (v) => _toggleFinished(v ?? false),
                ),

                // Summary
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${strings.totalSpools}: ${_filteredFilaments.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_filterStatus != null ||
                          _filterBrand != null ||
                          _filterMaterial != null ||
                          _filterColor != null ||
                          _filterLocation != null)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.filter_alt,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // List
                Expanded(
                  child: _filteredFilaments.isEmpty
                      ? Center(child: Text(strings.noFilaments))
                      : ListView.separated(
                          itemCount: _filteredFilaments.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final filament = _filteredFilaments[index];
                            return _buildFilamentTile(filament, strings);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilamentTile(Filament filament, AppStrings strings) {
    final brandName = _brandNames[filament.brandId] ?? '—';
    final materialName = _materialNames[filament.materialId] ?? '—';
    final color = _colors[filament.colorId];

    String locationText;
    if (filament.printerId != null && filament.slot != null) {
      final printer = _printers[filament.printerId];
      locationText =
          '${printer?.name ?? '?'} - ${strings.slot} ${filament.slot}';
    } else {
      final location = _locations[filament.locationId];
      locationText = location?.name ?? strings.location;
    }

    Color statusColor;
    switch (filament.status) {
      case FilamentStatus.active:
        statusColor = Colors.green;
        break;
      case FilamentStatus.used:
        statusColor = Colors.blue; // EKLE
        break;
      case FilamentStatus.low:
        statusColor = Colors.orange;
        break;
      case FilamentStatus.finished:
        statusColor = Colors.red;
        break;
    }

    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color != null ? Color(color.flutterColor) : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            filament.printerId != null ? Icons.print : Icons.place,
            size: 16,
          ),
        ],
      ),
      title: Text(
        '$brandName / ${materialName.toUpperCase()}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(color?.name ?? '-'),
          Text(
            locationText,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '#${filament.id}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
