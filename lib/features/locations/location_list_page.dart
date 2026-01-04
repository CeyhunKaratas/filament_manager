import 'package:flutter/material.dart';

import '../../core/database/location_repository.dart';
import '../../core/models/location.dart';
import '../../l10n/app_strings.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/database/filament_repository.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({super.key});

  @override
  State<LocationListPage> createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  final LocationRepository _repository = LocationRepository();
  final FilamentRepository _filamentRepository = FilamentRepository();

  late Future<List<Location>> _locationsFuture;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() {
    _locationsFuture = _repository.getAllLocations();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'locations'),
      appBar: AppBar(title: Text(strings.locations)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLocationDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Location>>(
        future: _locationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${strings.error}: ${snapshot.error}'));
          }

          final locations = snapshot.data ?? [];

          if (locations.isEmpty) {
            return Center(child: Text(strings.noLocations));
          }

          return ListView.separated(
            itemCount: locations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final location = locations[index];

              return ListTile(
                leading: Icon(location.isDefault ? Icons.lock : Icons.place),
                title: Text(location.name),
                subtitle: location.isDefault
                    ? Text(strings.defaultLocation)
                    : null,
                onLongPress: location.isDefault
                    ? null
                    : () => _confirmDeleteLocation(location),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddLocationDialog() {
    final controller = TextEditingController();
    final strings = AppStrings.of(Localizations.localeOf(context));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.addLocation),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: strings.locationName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                await _repository.insertLocation(
                  Location(id: 0, name: name, isDefault: false),
                );

                setState(() {
                  _loadLocations();
                });

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(strings.add),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteLocation(Location location) async {
  final strings = AppStrings.of(Localizations.localeOf(context));

  final filamentCount =
      await _filamentRepository.countFilamentsByLocation(location.id);

  if (filamentCount > 0) {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.error),
        content: Text(strings.locationNotEmpty),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.ok),
          ),
        ],
      ),
    );
    return;
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(strings.delete),
      content: Text(location.name),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            strings.delete,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  await _repository.deleteLocation(location.id);

  setState(() {
    _loadLocations();
  });
}

}
