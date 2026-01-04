import 'package:flutter/material.dart';

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
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Filament Manager', style: TextStyle(fontSize: 20)),
          ),

          _DrawerItem(
            icon: Icons.layers,
            label: 'Filaments',
            selected: current == 'filaments',
            onTap: () => _navigate(context, 'filaments'),
          ),

          _DrawerItem(
            icon: Icons.print,
            label: 'Printers',
            selected: current == 'printers',
            onTap: () => _navigate(context, 'printers'),
          ),

          _DrawerItem(
            icon: Icons.place,
            label: 'Locations',
            selected: current == 'locations',
            onTap: () => _navigate(context, 'locations'),
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
