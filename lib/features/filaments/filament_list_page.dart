import 'package:flutter/material.dart';

import '../../core/database/filament_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/filamentgroup.dart';

import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_repository.dart';
import '../definitions/colors/color_repository.dart';
import '../definitions/colors/color_model.dart';

import 'filament_add_page.dart';
import 'filament_group_detail_page.dart';

import '../../l10n/app_strings.dart';
import '../printers/printer_list_page.dart';
import '../../core/widgets/app_drawer.dart';

Icon statusIcon(FilamentStatus status) {
  switch (status) {
    case FilamentStatus.active:
      return const Icon(Icons.play_circle, color: Colors.green);
    case FilamentStatus.used:
      return const Icon(Icons.inventory, color: Colors.blue);
    case FilamentStatus.low:
      return const Icon(Icons.warning, color: Colors.orange);
    case FilamentStatus.finished:
      return const Icon(Icons.stop_circle, color: Colors.red);
  }
}

class FilamentListPage extends StatefulWidget {
  const FilamentListPage({super.key});

  @override
  State<FilamentListPage> createState() => _FilamentListPageState();
}

class _FilamentListPageState extends State<FilamentListPage> {
  final FilamentRepository _repository = FilamentRepository();

  final BrandRepository _brandRepo = BrandRepository();
  final MaterialRepository _materialRepo = MaterialRepository();
  final ColorRepository _colorRepo = ColorRepository();

  late Future<List<Filament>> _filamentsFuture;

  final Map<int, String> _brandNames = {};
  final Map<int, String> _materialNames = {};
  final Map<int, ColorModel> _colors = {};

  @override
  void initState() {
    super.initState();
    _loadDefinitions();
    _loadFilaments();
  }

  @override
  void dispose() {
    // No controllers to dispose in this widget
    super.dispose();
  }

  void _loadFilaments() {
    _filamentsFuture = _repository.getAllFilaments();
  }

  Future<void> _loadDefinitions() async {
    try {
      final brands = await _brandRepo.getAll();
      final materials = await _materialRepo.getAll();
      final colors = await _colorRepo.getAll();

      for (final b in brands) {
        _brandNames[b.id] = b.name;
      }
      for (final m in materials) {
        _materialNames[m.id] = m.name;
      }
      for (final c in colors) {
        _colors[c.id] = c;
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading definitions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load definitions: $e'),
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
      drawer: const AppDrawer(current: 'filaments'),
      appBar: AppBar(
        title: Text(strings.filaments),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrinterListPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Filament>>(
        future: _filamentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${strings.error}: ${snapshot.error}'));
          }

          final filaments = snapshot.data ?? [];

          if (filaments.isEmpty) {
            return Center(child: Text(strings.noFilaments));
          }

          final groups = _groupFilaments(filaments);

          if (groups.isEmpty) {
            return Center(child: Text(strings.noFilaments));
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];

              final brandName = _brandNames[group.brandId] ?? '—';
              final materialName = _materialNames[group.materialId] ?? '—';
              final colorModel = _colors[group.colorId];

              final activeCount = group.items
                  .where((f) => f.status == FilamentStatus.active)
                  .length;
              final lowCount = group.items
                  .where((f) => f.status == FilamentStatus.low)
                  .length;

              return ListTile(
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor: colorModel != null
                      ? Color(colorModel.flutterColor)
                      : Colors.grey,
                ),
                title: Text(
                  '$brandName • ${materialName.toUpperCase()} • '
                  '${colorModel?.name ?? '-'} '
                  '(${activeCount + lowCount})',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    if (activeCount > 0)
                      Text(
                        '$activeCount ${strings.statusActive}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    if (lowCount > 0) ...[
                      const SizedBox(width: 12),
                      Text(
                        '$lowCount ${strings.statusLow}',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ],
                ),
                trailing: activeCount > 0
                    ? statusIcon(FilamentStatus.active)
                    : statusIcon(FilamentStatus.low),
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FilamentGroupDetailPage(group: group),
                    ),
                  );

                  if (changed == true) {
                    setState(() {
                      _filamentsFuture = _repository.getAllFilaments();
                    });
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FilamentAddPage()),
          );

          if (changed == true) {
            await _loadDefinitions(); // ← Definitions'ı yeniden yükle
            setState(() {
              _filamentsFuture = _repository.getAllFilaments();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<FilamentGroup> _groupFilaments(List<Filament> filaments) {
    final Map<String, List<Filament>> grouped = {};

    for (final filament in filaments) {
      if (filament.status == FilamentStatus.finished) {
        continue; // 🔒 finished tamamen dışarıda
      }

      final key =
          '${filament.brandId}_${filament.materialId}_${filament.colorId}';

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(filament);
    }

    return grouped.values.where((items) => items.isNotEmpty).map((items) {
      final first = items.first;

      return FilamentGroup(
        brandId: first.brandId,
        materialId: first.materialId,
        colorId: first.colorId,
        count: items.length,
        items: items,
      );
    }).toList();
  }
}
