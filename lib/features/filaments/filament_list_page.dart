import 'package:flutter/material.dart';

import '../../core/database/filament_repository.dart';
import '../../core/models/filament.dart';

import 'filament_add_page.dart';
import 'filament_group.dart';
import 'filament_group_detail_page.dart';

import '../../l10n/app_strings.dart';
import '../printers/printer_list_page.dart';
import '../../core/widgets/app_drawer.dart';


Color filamentColor(String color) {
  switch (color.toLowerCase()) {
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.grey.shade300;
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    default:
      return Colors.brown;
  }
}

Icon statusIcon(FilamentStatus status) {
  switch (status) {
    case FilamentStatus.active:
      return const Icon(Icons.play_circle, color: Colors.green);

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

  late Future<List<Filament>> _filamentsFuture;

  @override
  void initState() {
    super.initState();
    _loadFilaments();
  }

  void _loadFilaments() {
    _filamentsFuture = _repository.getAllFilaments();
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

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];

              return ListTile(
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor: filamentColor(group.color),
                ),
                title: Text(
                  '${group.brand} - ${group.material.name.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${strings.color}: ${group.color}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    statusIcon(group.items.first.status),
                    const SizedBox(height: 4),
                    Text(
                      'x${group.count}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FilamentGroupDetailPage(group: group),
                    ),
                  );

                  if (changed == true) {
                    setState(_loadFilaments);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FilamentAddPage()),
          ).then((_) {
            setState(_loadFilaments);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _statusIcon(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return const Icon(Icons.check_circle, color: Colors.green);
      case FilamentStatus.low:
        return const Icon(Icons.warning, color: Colors.orange);
      case FilamentStatus.finished:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  List<FilamentGroup> _groupFilaments(List<Filament> filaments) {
    final Map<String, List<Filament>> grouped = {};

    for (final filament in filaments) {
      final key =
          '${filament.brand}_${filament.material.name}_${filament.color}';

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(filament);
    }

    return grouped.values.map((items) {
      final first = items.first;

      return FilamentGroup(
        brand: first.brand,
        material: first.material,
        color: first.color,
        count: items.length,
        items: items,
      );
    }).toList();
  }
}
