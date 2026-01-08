import 'package:flutter/material.dart';

import '../../core/database/filament_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/printer.dart';
import '../../l10n/app_strings.dart';

class FilamentAssignmentScreen extends StatefulWidget {
  const FilamentAssignmentScreen({super.key});

  @override
  State<FilamentAssignmentScreen> createState() =>
      _FilamentAssignmentScreenState();
}

class _FilamentAssignmentScreenState extends State<FilamentAssignmentScreen> {
  final FilamentRepository _filamentRepo = FilamentRepository();
  final PrinterRepository _printerRepo = PrinterRepository();

  List<Filament> filaments = [];
  List<Printer> printers = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    filaments = await _filamentRepo.getAllFilaments();
    printers = await _printerRepo.getAllPrinters();
    setState(() {});
  }

  void _assignDialog(Filament filament) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (printers.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(strings.printer),
          content: Text(strings.noFilaments),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
          ],
        ),
      );
      return;
    }

    Printer selectedPrinter = printers.first;
    int selectedSlot = 1;

    List<int> slotsFor(Printer p) => List.generate(p.slotCount, (i) => i + 1);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.assignSpool),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// PRINTER
            DropdownButtonFormField<Printer>(
              initialValue: selectedPrinter,
              items: printers
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  selectedPrinter = v!;
                  selectedSlot = 1;
                });
              },
              decoration: InputDecoration(labelText: strings.printer),
            ),

            const SizedBox(height: 12),

            /// SLOT
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
              final occupied = await _filamentRepo.isSlotOccupied(
                printerId: selectedPrinter.id!,
                slot: selectedSlot,
                excludeFilamentId: filament.id,
              );

              if (occupied) {
                if (!context.mounted) return;

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(strings.error),
                    content: Text(strings.slotAlreadyUsed),
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

              await _filamentRepo.assignFilament(
                filament.id,
                selectedPrinter.id!,
                selectedSlot,
              );

              Navigator.pop(context);
              _load();
            },
            child: Text(strings.assign),
          ),
        ],
      ),
    );
  }

  Widget _assignmentInfo(Filament f) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (f.printerId == null) {
      return Text(
        strings.unassigned,
        style: const TextStyle(color: Colors.grey),
      );
    }

    final printer = printers.firstWhere(
      (p) => p.id == f.printerId,
      orElse: () => Printer(id: null, name: '—', slotCount: 0),
    );

    return Text(
      '${printer.name} • ${strings.slot} ${f.slot}',
      style: const TextStyle(color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(strings.assignTitle)),
      body: ListView.builder(
        itemCount: filaments.length,
        itemBuilder: (_, i) {
          final f = filaments[i];
          return Card(
            child: ListTile(
              title: Text('${f.brand} • ${f.material.name.toUpperCase()}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(f.color), _assignmentInfo(f)],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'assign') {
                    _assignDialog(f);
                  } else if (v == 'unassign') {
                    await _filamentRepo.unassignFilament(f.id);
                    _load();
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'assign', child: Text(strings.assign)),
                  PopupMenuItem(
                    value: 'unassign',
                    child: Text(strings.unassign),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
