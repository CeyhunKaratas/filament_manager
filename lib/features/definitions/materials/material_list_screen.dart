import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import 'material_repository.dart';
import 'material_model.dart';

class MaterialListScreen extends StatefulWidget {
  const MaterialListScreen({super.key});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  final repo = MaterialRepository();
  late Future<List<MaterialModel>> _future;

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

  Future<void> _addMaterial(BuildContext context) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.newMaterial),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: strings.nameLabel),
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
                await repo.add(name);
                _reload();
              }
              Navigator.pop(context);
            },
            child: Text(strings.addNew),
          ),
        ],
      ),
    );
  }

  Future<void> _editMaterial(BuildContext context, MaterialModel m) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController(text: m.name);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editMaterialTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: strings.nameLabel),
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
                await repo.update(m.id, name);
                _reload();
              }
              Navigator.pop(context);
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(strings.materialsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMaterial(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<MaterialModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final m = items[i];
              return ListTile(
                title: Text(m.name),
                trailing: m.isDefault
                    ? const Icon(Icons.lock, size: 18)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editMaterial(context, m),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await repo.delete(m.id);
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
}
