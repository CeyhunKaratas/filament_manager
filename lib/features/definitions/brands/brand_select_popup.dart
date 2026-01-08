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

  Future<void> _confirm() async {
    final name = widget.enteredText.trim().toLowerCase();
    if (name.isEmpty) return;

    final existing = await _repo.getByName(name);
    if (existing != null) {
      Navigator.pop(context, existing);
      return;
    }

    await _repo.add(name);
    final created = await _repo.getByName(name);

    Navigator.pop(context, created);
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
          onPressed: () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        ElevatedButton(
          onPressed: _confirm,
          child: Text(strings.ok),
        ),
      ],
    );
  }
}
