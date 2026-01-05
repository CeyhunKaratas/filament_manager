import 'package:flutter/material.dart';

import '../../core/database/filament_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/printer.dart';
import '../../l10n/app_strings.dart';
import 'filament_group.dart';

import '../../core/database/location_repository.dart';
import '../../core/models/location.dart';

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

  late List<Filament> _items;
  List<Printer> _printers = [];
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _items = [];
    _loadPrinters();
    _loadLocations();
    _loadFilaments();
  }

  Future<void> _loadFilaments() async {
    final all = await _repository.getAllFilaments();

    _items = all
        .where(
          (f) =>
              f.brand == widget.group.brand &&
              f.material == widget.group.material &&
              f.color == widget.group.color,
        )
        .toList();

    if (mounted) setState(() {});
  }

  Future<void> _loadPrinters() async {
    _printers = await _printerRepo.getAllPrinters();
    if (mounted) setState(() {});
  }

  Future<void> _loadLocations() async {
    _locations = await _locationRepo.getAllLocations();
    if (mounted) setState(() {});
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

    await _repository.deleteFilament(filament.id);

    setState(() {
      _items.removeWhere((f) => f.id == filament.id);
    });

    if (_items.isEmpty && mounted) {
      Navigator.pop(context, true);
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

    // ✅ Eğer daha önce atanmışsa
    if (filament.printerId != null) {
      final found = _printers.where((p) => p.id == filament.printerId).toList();

      if (found.isNotEmpty) {
        selectedPrinter = found.first;
      }
    }

    if (filament.slot != null) {
      selectedSlot = filament.slot!;
    }

    List<int> slotsFor(Printer p) => List.generate(p.slotCount, (i) => i + 1);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                selectedPrinter = v!;
                selectedSlot = 1;
              },
              decoration: InputDecoration(labelText: strings.printer),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: selectedSlot,
              items: slotsFor(selectedPrinter)
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text('${strings.slot} $s'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => selectedSlot = v!,
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
                  builder: (context) {
                    return AlertDialog(
                      title: Text(strings.slotOccupiedTitle),
                      content: Text(strings.slotOccupiedMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(strings.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(strings.continueLabel),
                        ),
                      ],
                    );
                  },
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
              }

              await _loadFilaments(); // DB’den yeniden yükle (single source of truth)
              Navigator.pop(context);
            },
            child: Text(strings.assign),
          ),
        ],
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

    final updated = filament.copyWith(
      status: selected,
      printerId: filament.printerId,
      slot: filament.slot,
    );

    await _repository.updateFilament(updated);

    setState(() {
      final index = _items.indexWhere((f) => f.id == filament.id);
      _items[index] = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.group.brand} - ${widget.group.material.name.toUpperCase()}',
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
              leading: Icon(
                filament.printerId != null
                    ? Icons.print
                    : _statusIcon(filament.status),
                color: filament.printerId != null ? Colors.blue : null,
              ),
              title: Text('${strings.spool} ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${strings.color}: ${filament.color}'),
                  if (filament.printerId != null && filament.slot != null)
                    Text(
                      '${strings.printer}: ${_printerName(filament.printerId!)} • ${strings.slot}: ${filament.slot}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    Text(
                      '${strings.location}: ${_locationName(filament.locationId)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusChip(filament.status, strings),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      // 🔹 ASSIGN / RE-ASSIGN (MENÜDEN)
                      if (value == 'assign') {
                        _assignSlot(filament);
                        return;
                      }

                      // 🔹 STATUS DEĞİŞTİRME
                      if (value.startsWith('status_')) {
                        final statusName = value.replaceFirst('status_', '');
                        final newStatus = FilamentStatus.values.firstWhere(
                          (e) => e.name == statusName,
                        );

                        if (newStatus != filament.status) {
                          final updated = filament.copyWith(
                            status: newStatus,
                            printerId: filament.printerId,
                            slot: filament.slot,
                          );
                          await _repository.updateFilament(updated);

                          setState(() {
                            final i = _items.indexWhere(
                              (f) => f.id == filament.id,
                            );
                            _items[i] = updated;
                          });
                        }
                        return;
                      }

                      // 🔹 UNASSIGN
                      // 🔹 UNASSIGN
                      if (value == 'unassign') {
                        await _handleUnassignWithLocation(filament);
                      }
                      // 🔹 MOVE TO LOCATION
                      if (value == 'move_location') {
                        await _handleMoveToLocation(filament);
                      }
                    },
                    itemBuilder: (_) => [
                      // 🔹 ASSIGN / CHANGE SLOT
                      PopupMenuItem<String>(
                        value: 'assign',
                        child: Text(
                          filament.printerId == null
                              ? strings.assign
                              : strings.changeSlot,
                        ),
                      ),

                      const PopupMenuDivider(),

                      // 🔹 STATUS
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

                      // 🔹 MOVE LOCATION (sadece printer’a bağlı DEĞİLSE ve 1’den fazla location varsa)
                      if (filament.printerId == null && _locations.length > 1)
                        PopupMenuItem<String>(
                          value: 'move_location',
                          child: Text(strings.moveToLocation),
                        ),

                      // 🔹 UNASSIGN
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

    // Tek location varsa otomatik
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

    // 🔒 TEK DB OPERASYONU
    await _repository.unassignFilamentToLocation(
      filamentId: filament.id,
      locationId: targetLocation.id,
    );

    await _loadFilaments();
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

    final updated = filament.copyWith(locationId: selected.id);

    await _repository.updateFilament(updated);

    await _loadFilaments();
  }
}
