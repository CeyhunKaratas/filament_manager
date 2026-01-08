import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/filaments/filament_list_page.dart';
import 'l10n/app_strings.dart';

import 'features/printers/printer_list_page.dart';
import 'features/locations/location_list_page.dart';
import 'features/scan/scan_ocr_page.dart';
import 'features/definitions/definitions_home_screen.dart';
import 'features/settings/settings_page.dart';
import 'features/onboarding/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if onboarding has been completed
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(MyApp(showOnboarding: !hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

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

      initialRoute: showOnboarding ? '/onboarding' : '/filaments',
      routes: {
        '/onboarding': (_) => const OnboardingPage(),
        '/filaments': (_) => const FilamentListPage(),
        '/printers': (_) => const PrinterListPage(),
        '/locations': (_) => const LocationListPage(),
        '/scan': (_) => const ScanOcrPage(),
        '/definitions': (_) => const DefinitionsHomeScreen(),
        '/settings': (_) => const SettingsPage(),
      },
    );
  }
}
