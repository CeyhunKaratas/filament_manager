import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import 'brand_repository.dart';
import 'brand_model.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  final repo = BrandRepository();
  late Future<List<BrandModel>> _future;

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

  Future<void> _addBrand(BuildContext context) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.newBrand),
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

  Future<void> _editBrand(BuildContext context, BrandModel b) async {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final controller = TextEditingController(text: b.name);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editBrandTitle),
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
                await repo.update(b.id, name);
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
      appBar: AppBar(title: Text(strings.brandsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBrand(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<BrandModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final b = items[i];
              return ListTile(
                title: Text(b.name),
                trailing: b.isDefault
                    ? const Icon(Icons.lock, size: 18)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editBrand(context, b),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await repo.delete(b.id);
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
