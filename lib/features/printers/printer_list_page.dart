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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _printers = await _repository.getAllPrinters();
    setState(() {});
  }

  Future<void> _deletePrinter(Printer printer) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

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
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
  drawer: const AppDrawer(current: 'printers'),
      appBar: AppBar(
        title: Text(strings.printer),
      ),
      body: _printers.isEmpty
          ? Center(
              child: Text(strings.noPrinters),
            )
          : ListView.separated(
              itemCount: _printers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final printer = _printers[index];
                return ListTile(
                  title: Text(printer.name),
                  subtitle:
                      Text('${strings.slot}: ${printer.slotCount}'),
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
