import 'package:flutter/material.dart';
import 'package:filament_manager/core/models/printer.dart';
import 'package:filament_manager/core/models/filament.dart';
import 'package:filament_manager/core/database/filament_repository.dart';
import 'package:filament_manager/l10n/app_strings.dart';

class PrinterDetailPage extends StatefulWidget {
  final Printer printer;

  const PrinterDetailPage({super.key, required this.printer});

  @override
  State<PrinterDetailPage> createState() => _PrinterDetailPageState();
}

class _PrinterDetailPageState extends State<PrinterDetailPage> {
  final FilamentRepository _filamentRepository = FilamentRepository();

  List<Filament> _filaments = [];

  @override
  void initState() {
    super.initState();
    _loadFilaments();
  }

  Future<void> _loadFilaments() async {
    final result = await _filamentRepository.getFilamentsByPrinter(
      widget.printer.id!,
    );

    setState(() {
      _filaments = result;
    });
  }

  Color _statusColor(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return Colors.green;
      case FilamentStatus.low:
        return Colors.orange;
      case FilamentStatus.finished:
        return Colors.red;
    }
  }

  Color _filamentColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(widget.printer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.printer,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_filaments.isEmpty) ...[
              const SizedBox(height: 4),
              Text(
                strings.noFilaments,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 8),
            Text(widget.printer.name),
            const SizedBox(height: 16),
            Text('${strings.slot}: ${widget.printer.slotCount}'),
            const SizedBox(height: 24),
            Text(strings.slot, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.printer.slotCount,
                itemBuilder: (context, index) {
                  final slotNumber = index + 1;

                  Filament? filamentForSlot;
                  for (final f in _filaments) {
                    if (f.slot == slotNumber) {
                      filamentForSlot = f;
                      break;
                    }
                  }

                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // STATUS DOT
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: filamentForSlot == null
                                ? Colors.transparent
                                : _statusColor(filamentForSlot.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // FILAMENT COLOR SQUARE
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: filamentForSlot == null
                                ? Colors.transparent
                                : _filamentColor(filamentForSlot.color),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // SLOT NUMBER
                        Text(
                          '#$slotNumber',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    title: filamentForSlot == null
                        ? Text(strings.empty)
                        : Text(
                            '${filamentForSlot.brand} • ${filamentForSlot.color}',
                          ),
                    subtitle: filamentForSlot == null
                        ? null
                        : Text(filamentForSlot.material.name),
                  );
                },
              ),
            ),
            Row(
              children: [
                _LegendItem(color: Colors.green, label: strings.statusActive),
                const SizedBox(width: 12),
                _LegendItem(color: Colors.orange, label: strings.statusLow),
                const SizedBox(width: 12),
                _LegendItem(color: Colors.red, label: strings.statusFinished),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
