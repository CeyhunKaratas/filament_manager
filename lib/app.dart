import 'package:flutter/material.dart';
import 'features/filaments/filament_list_page.dart';

class FilamentApp extends StatelessWidget {
  const FilamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Filament Management',
      debugShowCheckedModeBanner: false,
      home: const FilamentListPage(),
    );
  }
}
