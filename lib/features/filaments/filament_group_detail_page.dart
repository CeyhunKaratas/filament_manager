import 'package:flutter/material.dart';
import '../../core/database/filament_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/printer.dart';
import '../../l10n/app_strings.dart';
import '../../core/models/filamentgroup.dart';
import '../../core/database/location_repository.dart';
import '../../core/models/location.dart';
import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_repository.dart';
import '../definitions/colors/color_repository.dart';
import '../definitions/colors/color_model.dart';
import 'filament_edit_page.dart';
import '../filaments/filament_history_add_page.dart';
import '../../core/database/filament_history_repository.dart';
import '../filaments/filament_history_list_page.dart';
import '../../core/widgets/filament_popup_menu.dart';
import '../../core/services/filament_actions.dart';

class FilamentGroupDetailPage extends StatefulWidget {
  final FilamentGroup group;

  const FilamentGroupDetailPage({super.key, required this.group});

  @override
  State<FilamentGroupDetailPage> createState() =>
      _FilamentGroupDetailPageState();
}

class _FilamentGroupDetailPageState extends State<FilamentGroupDetailPage> {
  final FilamentRepository _repository = FilamentRepository();
  final FilamentHistoryRepository _historyRepository =
      FilamentHistoryRepository();
  final PrinterRepository _printerRepo = PrinterRepository();
  final LocationRepository _locationRepo = LocationRepository();
  final BrandRepository _brandRepo = BrandRepository();
  final MaterialRepository _materialRepo = MaterialRepository();
  final ColorRepository _colorRepo = ColorRepository();

  String? _brandName;
  String? _materialName;
  ColorModel? _colorModel;

  List<Filament> _items = [];
  List<Printer> _printers = [];
  List<Location> _locations = [];

  // Gram data cache
  final Map<int, int?> _latestGrams = {}; // filamentId -> gram

  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _items = List.of(
      widget.group.items,
    ).where((f) => f.status != FilamentStatus.finished).toList();
    _loadPrinters();
    _loadLocations();
    _reloadFromDb();
    _loadDefinitions();
  }

  Future<void> _loadDefinitions() async {
    try {
      final brands = await _brandRepo.getAll();
      final materials = await _materialRepo.getAll();
      final colors = await _colorRepo.getAll();

      final brand = brands.firstWhere(
        (b) => b.id == widget.group.brandId,
        orElse: () => throw Exception('Brand not found'),
      );
      _brandName = brand.name;

      final material = materials.firstWhere(
        (m) => m.id == widget.group.materialId,
        orElse: () => throw Exception('Material not found'),
      );
      _materialName = material.name;

      final color = colors.firstWhere(
        (c) => c.id == widget.group.colorId,
        orElse: () => throw Exception('Color not found'),
      );
      _colorModel = color;

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading definitions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load definitions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reloadFromDb() async {
    try {
      if (widget.group.items.isEmpty) {
        _items = [];
        if (mounted) setState(() {});
        return;
      }

      final first = widget.group.items.first;
      final all = await _repository.getAllFilamentsWithStatus();

      _items = all
          .where(
            (f) =>
                f.brandId == first.brandId &&
                f.materialId == first.materialId &&
                f.colorId == first.colorId &&
                f.status != FilamentStatus.finished,
          )
          .toList();

      // Load gram data for each filament
      for (final item in _items) {
        final latestHistory = await _historyRepository.getLatestHistory(
          item.id,
        );
        _latestGrams[item.id] = latestHistory?.gram;
      }

      if (mounted) {
        if (_items.isEmpty) {
          // Tüm filamentler bitti, geri dön
          Navigator.pop(context, true);
        } else {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('Error reloading filaments: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reload filaments: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadPrinters() async {
    try {
      _printers = await _printerRepo.getAllPrinters();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading printers: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load printers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadLocations() async {
    try {
      _locations = await _locationRepo.getAllLocations();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading locations: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load locations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _changed ? true : false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _brandName == null
                ? strings.spools
                : '$_brandName • ${_materialName!.toUpperCase()} • ${_colorModel!.name}',
          ),
        ),
        body: ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final filament = _items[index];

            return Dismissible(
              key: ValueKey(filament.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                final deleted = await FilamentActions.delete(context, filament);
                if (deleted) {
                  _changed = true;
                  await _reloadFromDb();
                }
                return false;
              },
              child: ListTile(
                onTap: () async {
                  final changed = await FilamentActions.assignToPrinter(
                    context,
                    filament,
                    _printers,
                  );
                  if (changed) {
                    _changed = true;
                    await _reloadFromDb();
                  }
                },
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colorModel != null
                            ? Color(_colorModel!.flutterColor)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Icon(
                      filament.printerId != null
                          ? Icons.print
                          : _statusIcon(filament.status),
                      size: 18,
                    ),
                  ],
                ),
                title: Row(
                  children: [
                    Text('${strings.spool} ${filament.id}'),
                    const SizedBox(width: 8),
                    if (_latestGrams[filament.id] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_latestGrams[filament.id]}g',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filament.printerId != null && filament.slot != null)
                      Text(
                        '${strings.printer}: ${_printerName(filament.printerId!)} • ${strings.slot}: ${filament.slot}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    else
                      Text(
                        '${strings.location}: ${_locationName(filament.locationId)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _statusChip(filament.status, strings),
                    FilamentPopupMenu(
                      filament: filament,
                      showLocationOptions: _locations.length > 1,
                      onAction: (action, fil) async {
                        bool changed = false;

                        switch (action) {
                          case 'save_status':
                            changed = await FilamentActions.saveStatus(
                              context,
                              fil,
                            );
                            break;
                          case 'view_history':
                            await FilamentActions.viewHistory(context, fil);
                            break;
                          case 'edit':
                            changed = await FilamentActions.edit(context, fil);
                            break;
                          case 'delete':
                            changed = await FilamentActions.delete(
                              context,
                              fil,
                            );
                            break;
                          case 'assign':
                            changed = await FilamentActions.assignToPrinter(
                              context,
                              fil,
                              _printers,
                            );
                            break;
                          case 'unassign':
                            changed =
                                await FilamentActions.unassignWithLocation(
                                  context,
                                  fil,
                                  _locations,
                                );
                            break;
                          case 'move_location':
                            changed = await FilamentActions.moveToLocation(
                              context,
                              fil,
                              _locations,
                            );
                            break;
                        }

                        if (changed) {
                          _changed = true;
                          await _reloadFromDb();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _printerName(int printerId) {
    final printer = _printers.firstWhere(
      (p) => p.id == printerId,
      orElse: () => Printer(id: -1, name: '?', slotCount: 0),
    );
    return printer.name;
  }

  String _locationName(int locationId) {
    final location = _locations.firstWhere(
      (l) => l.id == locationId,
      orElse: () => const Location(id: 1, name: 'DEFAULT', isDefault: true),
    );
    return location.name;
  }

  IconData _statusIcon(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return Icons.check_circle;
      case FilamentStatus.used:
        return Icons.inventory;
      case FilamentStatus.low:
        return Icons.warning;
      case FilamentStatus.finished:
        return Icons.cancel;
    }
  }

  Widget _statusChip(FilamentStatus status, AppStrings strings) {
    switch (status) {
      case FilamentStatus.active:
        return Chip(
          label: Text(
            strings.statusActive,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
      case FilamentStatus.used:
        return Chip(
          label: Text(
            strings.statusUsed,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        );
      case FilamentStatus.low:
        return Chip(
          label: Text(
            strings.statusLow,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        );
      case FilamentStatus.finished:
        return Chip(
          label: Text(
            strings.statusFinished,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
    }
  }
}
