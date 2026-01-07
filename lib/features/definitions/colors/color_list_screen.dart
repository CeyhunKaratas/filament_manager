import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as fcp;

import '../../../l10n/app_strings.dart';
import 'color_repository.dart';
import 'color_model.dart';

class ColorListScreen extends StatefulWidget {
  const ColorListScreen({super.key});

  @override
  State<ColorListScreen> createState() => _ColorListScreenState();
}

class _ColorListScreenState extends State<ColorListScreen> {
  final repo = ColorRepository();
  late Future<List<ColorModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = repo.getAll();
  }

  void _reload() {
    setState(() {
      _future = repo.getAll();
    });
  }

  Future<Color?> _pickColor(BuildContext context, Color current) {
    Color temp = current;
    final strings = AppStrings.of(Localizations.localeOf(context));

    return showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.pickColor),
        content: SingleChildScrollView(
          child: fcp.ColorPicker(
            pickerColor: current,
            onColorChanged: (c) => temp = c,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, temp),
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _addColor(BuildContext context) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController();
    Color selectedColor = Colors.grey;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(strings.newColor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: strings.nameLabel),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(backgroundColor: selectedColor),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await _pickColor(context, selectedColor);
                      if (picked != null) {
                        setDialogState(() {
                          selectedColor = picked;
                        });
                      }
                    },
                    child: Text(strings.pickColor),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await repo.add(name, _toHex(selectedColor));
                  _reload();
                }
                Navigator.pop(context);
              },
              child: Text(strings.addNew),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editColor(BuildContext context, ColorModel c) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController(text: c.name);
    Color selectedColor =
        c.colorCode != null ? _fromHex(c.colorCode!) : Colors.grey;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(strings.editColorTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: strings.nameLabel),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(backgroundColor: selectedColor),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await _pickColor(context, selectedColor);
                      if (picked != null) {
                        setDialogState(() {
                          selectedColor = picked;
                        });
                      }
                    },
                    child: Text(strings.changeColor),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await repo.update(
                    c.id,
                    name,
                    _toHex(selectedColor),
                  );
                  _reload();
                }
                Navigator.pop(context);
              },
              child: Text(strings.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(strings.colorsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addColor(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ColorModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final c = items[i];
              return ListTile(
                leading: c.colorCode != null
                    ? CircleAvatar(backgroundColor: _fromHex(c.colorCode!))
                    : const CircleAvatar(child: Icon(Icons.palette)),
                title: Text(c.name),
                trailing: c.isDefault
                    ? const Icon(Icons.lock, size: 18)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editColor(context, c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await repo.delete(c.id);
                              _reload();
                            },
                          ),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  String _toHex(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Color _fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    final value = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(value, radix: 16));
  }
}
