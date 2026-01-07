import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/filaments/filament_list_page.dart';
import 'l10n/app_strings.dart';

import 'features/printers/printer_list_page.dart';
import 'features/locations/location_list_page.dart';
import 'features/scan/scan_ocr_page.dart';
import 'features/definitions/definitions_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      supportedLocales: AppStrings.supportedLocales,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/filaments',
      routes: {
        '/filaments': (_) => const FilamentListPage(),
        '/printers': (_) => const PrinterListPage(),
        '/locations': (_) => const LocationListPage(),
        '/scan': (_) => const ScanOcrPage(),
        '/definitions': (_) => const DefinitionsHomeScreen(),
      },
    );
  }
}
