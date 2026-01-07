import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import 'brands/brand_list_screen.dart';
import 'colors/color_list_screen.dart';
import 'materials/material_list_screen.dart';
import '../../core/widgets/app_drawer.dart';

class DefinitionsHomeScreen extends StatelessWidget {
  const DefinitionsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(strings.definitionsTitle)),
      drawer: const AppDrawer(current: 'definitions'),
      body: ListView(
        children: [
          _DefinitionTile(
            icon: Icons.palette,
            title: strings.colorsTitle,
            subtitle: strings.manageColorsSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ColorListScreen()),
              );
            },
          ),
          _DefinitionTile(
            icon: Icons.business,
            title: strings.brandsTitle,
            subtitle: strings.manageBrandsSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BrandListScreen()),
              );
            },
          ),
          _DefinitionTile(
            icon: Icons.category,
            title: strings.materialsTitle,
            subtitle: strings.manageMaterialsSubtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaterialListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DefinitionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DefinitionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
