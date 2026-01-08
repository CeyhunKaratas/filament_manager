import 'package:flutter/material.dart';

import '../../core/database/printer_repository.dart';
import '../../core/models/printer.dart';
import '../../l10n/app_strings.dart';

import 'printer_add_dialog.dart';
import 'printer_detail_page.dart';
import '../../core/widgets/app_drawer.dart';

class PrinterListPage extends StatefulWidget {
  const PrinterListPage({super.key});

  @override
  State<PrinterListPage> createState() => _PrinterListPageState();
}

class _PrinterListPageState extends State<PrinterListPage> {
  final PrinterRepository _repository = PrinterRepository();

  List<Printer> _printers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _printers = await _repository.getAllPrinters();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading printers: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load printers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deletePrinter(Printer printer) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    try {
      // Check if printer has assigned filaments
      final filamentCount = await _repository.getAssignedFilamentCount(
        printer.id!,
      );

      if (filamentCount > 0) {
        // Printer has filaments - show warning and options
        final action = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(strings.delete),
            content: Text(
              'This printer has $filamentCount assigned filament(s). '
              'What would you like to do?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'unassign'),
                child: const Text('Move to storage & delete'),
              ),
            ],
          ),
        );

        if (action != 'unassign') return;

        // Unassign filaments and delete printer
        await _repository.deletePrinter(printer.id!, unassignFilaments: true);
      } else {
        // No filaments - simple confirmation
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(strings.delete),
            content: Text(printer.name),
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

        await _repository.deletePrinter(printer.id!);
      }

      await _load();
    } catch (e) {
      debugPrint('Error deleting printer: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete printer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'printers'),
      appBar: AppBar(title: Text(strings.printer)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _printers.isEmpty
          ? Center(child: Text(strings.noPrinters))
          : ListView.separated(
              itemCount: _printers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final printer = _printers[index];
                return ListTile(
                  title: Text(printer.name),
                  subtitle: Text('${strings.slot}: ${printer.slotCount}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PrinterDetailPage(printer: printer),
                      ),
                    );
                  },
                  onLongPress: () => _deletePrinter(printer),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await showDialog<bool>(
            context: context,
            builder: (_) => const PrinterAddDialog(),
          );

          if (added == true) {
            _load();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
