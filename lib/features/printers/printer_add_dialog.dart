import 'package:flutter/material.dart';

import '../../core/database/printer_repository.dart';
import '../../core/models/printer.dart';
import '../../l10n/app_strings.dart';

class PrinterAddDialog extends StatefulWidget {
  const PrinterAddDialog({super.key});

  @override
  State<PrinterAddDialog> createState() => _PrinterAddDialogState();
}

class _PrinterAddDialogState extends State<PrinterAddDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _slotController = TextEditingController(text: '4');

  final PrinterRepository _repository = PrinterRepository();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final printer = Printer(
    name: _nameController.text.trim(),
    slotCount: int.parse(_slotController.text),
    );


    await _repository.insertPrinter(printer);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return AlertDialog(
      title: Text(strings.printer),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// PRINTER NAME
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: strings.printer,
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? strings.required : null,
            ),

            const SizedBox(height: 12),

            /// SLOT COUNT
            TextFormField(
              controller: _slotController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: strings.slot,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return strings.required;
                final value = int.tryParse(v);
                if (value == null || value <= 0) {
                  return strings.required;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(strings.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(strings.save),
        ),
      ],
    );
  }
}
