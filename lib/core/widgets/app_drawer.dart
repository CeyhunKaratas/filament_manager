import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';

class AppDrawer extends StatelessWidget {
  final String current;

  const AppDrawer({super.key, required this.current});

  void _navigate(BuildContext context, String target) {
    // Önce drawer'ı kapat
    Navigator.pop(context);

    // Drawer kapanma animasyonundan sonra route değiştir
    if (current != target) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/$target');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(strings.appTitle, style: const TextStyle(fontSize: 20)),
          ),

          _DrawerItem(
            icon: Icons.layers,
            label: strings.filaments,
            selected: current == 'filaments',
            onTap: () => _navigate(context, 'filaments'),
          ),

          _DrawerItem(
            icon: Icons.print,
            label: strings.printers,
            selected: current == 'printers',
            onTap: () => _navigate(context, 'printers'),
          ),

          _DrawerItem(
            icon: Icons.place,
            label: strings.locations,
            selected: current == 'locations',
            onTap: () => _navigate(context, 'locations'),
          ),

          _DrawerItem(
            icon: Icons.qr_code_scanner,
            label: strings.scanOcr,
            selected: current == 'scan',
            onTap: () => _navigate(context, 'scan'),
          ),

          // --------------------
          // DEFINITIONS
          // --------------------
          const Divider(),

          _DrawerItem(
            icon: Icons.tune,
            label: strings.definitions,
            selected: current == 'definitions',
            onTap: () => _navigate(context, 'definitions'),
          ),

          // --------------------
          // REPORTS
          // --------------------
          _DrawerItem(
            icon: Icons.assessment,
            label: strings.reports,
            selected: current == 'reports',
            onTap: () => _navigate(context, 'reports'),
          ),

          // --------------------
          // SETTINGS
          // --------------------
          const Divider(),

          _DrawerItem(
            icon: Icons.settings,
            label: strings.settings,
            selected: current == 'settings',
            onTap: () => _navigate(context, 'settings'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}
