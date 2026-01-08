import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import 'brand_repository.dart';

class BrandSelectPopup extends StatefulWidget {
  final String enteredText;

  const BrandSelectPopup({
    super.key,
    required this.enteredText,
  });

  @override
  State<BrandSelectPopup> createState() => _BrandSelectPopupState();
}

class _BrandSelectPopupState extends State<BrandSelectPopup> {
  final BrandRepository _repo = BrandRepository();

  bool _isSaving = false;

  Future<void> _confirm() async {
    final name = widget.enteredText.trim().toLowerCase();
    if (name.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final existing = await _repo.getByName(name);
      if (existing != null) {
        if (mounted) {
          Navigator.pop(context, existing);
        }
        return;
      }

      await _repo.add(name);
      final created = await _repo.getByName(name);

      if (mounted) {
        Navigator.pop(context, created);
      }
    } catch (e) {
      debugPrint('Error confirming brand: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add brand: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
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
      title: Text(strings.addBrand),
      content: Text(
        widget.enteredText.toLowerCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _confirm,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings.ok),
        ),
      ],
    );
  }
}