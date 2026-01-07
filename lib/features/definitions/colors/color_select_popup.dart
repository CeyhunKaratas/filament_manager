import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import 'color_model.dart';
import 'color_repository.dart';
import 'color_term_repository.dart';

class ColorSelectPopup extends StatefulWidget {
  final String enteredText;

  const ColorSelectPopup({
    super.key,
    required this.enteredText,
  });

  @override
  State<ColorSelectPopup> createState() => _ColorSelectPopupState();
}

class _ColorSelectPopupState extends State<ColorSelectPopup> {
  final _colorRepo = ColorRepository();
  final _termRepo = ColorTermRepository();

  bool _isNewColor = true; // default CHECKED
  Color _picked = Colors.grey;

  List<ColorModel> _allColors = [];
  ColorModel? _selectedExisting;

  // Basit palette (external package yok)
  final List<Color> _palette = const [
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.teal,
    Colors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  Future<void> _loadColors() async {
    _allColors = await _colorRepo.getAll();
    if (mounted) setState(() {});
  }

  String _toHex(Color c) {
    // ColorListScreen ile aynı format: '#RRGGBB'
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Future<void> _confirm() async {
    final input = widget.enteredText.trim();
    if (input.isEmpty) return;

    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;

    if (_isNewColor) {
      // güvenlik: yine de var mı kontrol
      final existing = await _colorRepo.getByName(input);
      if (existing != null) {
        if (mounted) Navigator.pop(context, existing);
        return;
      }

      await _colorRepo.add(input.toLowerCase(), _toHex(_picked));
      final created = await _colorRepo.getByName(input);

      if (mounted) Navigator.pop(context, created);
      return;
    }

    // alias flow
    if (_selectedExisting == null) return;

    await _termRepo.addTerm(
      colorId: _selectedExisting!.id,
      term: input.toLowerCase(),
      lang: lang,
    );

    if (mounted) Navigator.pop(context, _selectedExisting);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return AlertDialog(
      title: Text(strings.colorsTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcının yazdığı metin (salt)
            Text(
              widget.enteredText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // "Bu yeni bir renk" => mevcut key: newColor
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _isNewColor,
              onChanged: (v) => setState(() {
                _isNewColor = v ?? true;
                if (_isNewColor) _selectedExisting = null;
              }),
              title: Text(strings.newColor),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            if (_isNewColor) ...[
              const SizedBox(height: 8),
              Text(strings.pickColor),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _palette.map((c) {
                  final selected = c.value == _picked.value;
                  return InkWell(
                    onTap: () => setState(() => _picked = c),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: c,
                        border: Border.all(
                          color: selected ? Colors.black : Colors.black12,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<ColorModel>(
                value: _selectedExisting,
                decoration: InputDecoration(labelText: strings.color),
                items: _allColors
                    .map(
                      (c) => DropdownMenuItem<ColorModel>(
                        value: c,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedExisting = v),
              ),
            ],
          ],
        ),
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
