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

class FilamentGroupDetailPage extends StatefulWidget {
  final FilamentGroup group;

  const FilamentGroupDetailPage({super.key, required this.group});

  @override
  State<FilamentGroupDetailPage> createState() =>
      _FilamentGroupDetailPageState();
}

class _FilamentGroupDetailPageState extends State<FilamentGroupDetailPage> {
  final FilamentRepository _repository = FilamentRepository();
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
      final all = await _repository.getAllFilaments();

      _items = all
          .where(
            (f) =>
                f.brandId == first.brandId &&
                f.materialId == first.materialId &&
                f.colorId == first.colorId &&
                f.status != FilamentStatus.finished,
          )
          .toList();

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

  Future<void> _deleteFilament(Filament filament) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.deleteSpoolTitle),
        content: Text(strings.deleteSpoolConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              strings.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _repository.deleteFilament(filament.id);
      _changed = true;

      // Reload and check if list is now empty
      await _reloadFromDb();

      // _reloadFromDb handles navigation if list is empty
    } catch (e) {
      debugPrint('Error deleting filament: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete filament: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// SLOT ATAMA
  void _assignSlot(Filament filament) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (_printers.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(strings.printer),
          content: Text(strings.noPrinters),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.ok),
            ),
          ],
        ),
      );
      return;
    }

    Printer selectedPrinter = _printers.first;
    int selectedSlot = 1;

    if (filament.printerId != null) {
      final found = _printers.where((p) => p.id == filament.printerId).toList();
      if (found.isNotEmpty) selectedPrinter = found.first;
    }

    if (filament.slot != null) selectedSlot = filament.slot!;

    List<int> slotsFor(Printer p) => List.generate(p.slotCount, (i) => i + 1);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(strings.assignSpool),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Printer>(
                initialValue: selectedPrinter,
                items: _printers
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (v) {
                  setDialogState(() {
                    selectedPrinter = v!;
                    selectedSlot = 1;
                  });
                },
                decoration: InputDecoration(labelText: strings.printer),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                key: ValueKey(selectedPrinter.id),
                initialValue: selectedSlot,
                items: slotsFor(selectedPrinter)
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text('${strings.slot} $s'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setDialogState(() {
                    selectedSlot = v!;
                  });
                },
                decoration: InputDecoration(labelText: strings.slot),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _repository.assignFilament(
                    filament.id,
                    selectedPrinter.id!,
                    selectedSlot,
                  );
                } on SlotOccupiedException {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(strings.slotOccupiedTitle),
                      content: Text(strings.slotOccupiedMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(strings.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(strings.continueLabel),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await _repository.assignFilament(
                      filament.id,
                      selectedPrinter.id!,
                      selectedSlot,
                      force: true,
                    );
                  } else {
                    return;
                  }
                } catch (e) {
                  debugPrint('Error assigning filament: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to assign filament: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }

                if (!mounted) return;
                Navigator.pop(context);
                await _reloadFromDb();
              },
              child: Text(strings.assign),
            ),
          ],
        ),
      ),
    );
  }

  /// STATUS DEĞİŞTİR
  Future<void> _changeStatus(Filament filament) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    final selected = await showModalBottomSheet<FilamentStatus>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: FilamentStatus.values.map((status) {
            return ListTile(
              title: Text(strings.statusLabel(status)),
              leading: Icon(_statusIcon(status)),
              onTap: () => Navigator.pop(context, status),
            );
          }).toList(),
        ),
      ),
    );

    if (selected == null || selected == filament.status) return;

    try {
      await _repository.updateFilament(filament.copyWith(status: selected));
      _changed = true;
      await _reloadFromDb();
    } catch (e) {
      debugPrint('Error changing status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change status: $e'),
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
                await _deleteFilament(filament);
                return false;
              },
              child: ListTile(
                onTap: () => _assignSlot(filament),
                onLongPress: () => _changeStatus(filament),
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
                title: Text('${strings.spool} ${filament.id}'),
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
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        try {
                          if (value == 'edit') {
                            await _editFilament(filament);
                            return;
                          }

                          if (value == 'delete') {
                            await _deleteFilament(filament);
                            return;
                          }

                          if (value == 'assign') {
                            _assignSlot(filament);
                            return;
                          }

                          if (value.startsWith('status_')) {
                            final statusName = value.replaceFirst(
                              'status_',
                              '',
                            );
                            final newStatus = FilamentStatus.values.firstWhere(
                              (e) => e.name == statusName,
                            );
                            if (newStatus != filament.status) {
                              await _repository.updateFilament(
                                filament.copyWith(status: newStatus),
                              );
                              _changed = true;
                              await _reloadFromDb();
                            }
                            return;
                          }

                          if (value == 'unassign') {
                            await _handleUnassignWithLocation(filament);
                            return;
                          }

                          if (value == 'move_location') {
                            await _handleMoveToLocation(filament);
                            return;
                          }
                        } catch (e) {
                          debugPrint('Error in menu action: $e');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Operation failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(strings.edit),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            strings.delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'assign',
                          child: Text(
                            filament.printerId == null
                                ? strings.assign
                                : strings.changeSlot,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'status_active',
                          child: Text(strings.statusActive),
                        ),
                        PopupMenuItem<String>(
                          value: 'status_low',
                          child: Text(strings.statusLow),
                        ),
                        PopupMenuItem<String>(
                          value: 'status_finished',
                          child: Text(strings.statusFinished),
                        ),
                        const PopupMenuDivider(),
                        if (filament.printerId == null && _locations.length > 1)
                          PopupMenuItem<String>(
                            value: 'move_location',
                            child: Text(strings.moveToLocation),
                          ),
                        if (filament.printerId != null)
                          PopupMenuItem<String>(
                            value: 'unassign',
                            child: Text(strings.unassign),
                          ),
                      ],
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

  Future<void> _handleUnassignWithLocation(Filament filament) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (_locations.isEmpty) return;

    Location targetLocation;

    if (_locations.length == 1) {
      targetLocation = _locations.first;
    } else {
      final selected = await showDialog<Location>(
        context: context,
        builder: (_) => SimpleDialog(
          title: Text(strings.selectLocation),
          children: _locations
              .map(
                (l) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, l),
                  child: Text(l.name),
                ),
              )
              .toList(),
        ),
      );

      if (selected == null) return;
      targetLocation = selected;
    }

    try {
      await _repository.unassignFilamentToLocation(
        filamentId: filament.id,
        locationId: targetLocation.id,
      );

      _changed = true;
      await _reloadFromDb();
    } catch (e) {
      debugPrint('Error unassigning filament: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unassign filament: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleMoveToLocation(Filament filament) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (_locations.length <= 1) return;

    final selected = await showDialog<Location>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(strings.selectLocation),
        children: _locations
            .where((l) => l.id != filament.locationId)
            .map(
              (l) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, l),
                child: Text(l.name),
              ),
            )
            .toList(),
      ),
    );

    if (selected == null) return;

    try {
      await _repository.updateFilament(
        filament.copyWith(locationId: selected.id),
      );

      _changed = true;
      await _reloadFromDb();
    } catch (e) {
      debugPrint('Error moving to location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to move to location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editFilament(Filament filament) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FilamentEditPage(filament: filament)),
    );

    if (result == true) {
      _changed = true;
      await _reloadFromDb();
    }
  }
}
