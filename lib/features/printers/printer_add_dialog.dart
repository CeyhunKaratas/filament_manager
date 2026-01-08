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

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final printer = Printer(
        name: _nameController.text.trim(),
        slotCount: int.parse(_slotController.text),
      );

      await _repository.insertPrinter(printer);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving printer: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save printer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
              decoration: InputDecoration(labelText: strings.printer),
              validator: (v) =>
                  v == null || v.isEmpty ? strings.required : null,
            ),

            const SizedBox(height: 12),

            /// SLOT COUNT
            TextFormField(
              controller: _slotController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: strings.slot),
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
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: Text(strings.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings.save),
        ),
      ],
    );
  }
}
