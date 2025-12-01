import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/menu_screen.dart';
import 'services/audio_service.dart';
import 'services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set orientation only on mobile platforms (not web)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  final preferences = PreferencesService();
  await preferences.init();
  final audioService = AudioService(preferencesService: preferences);
  await audioService.preload();

  runApp(SeaHeroApp(
    preferencesService: preferences,
    audioService: audioService,
  ));
}

class SeaHeroApp extends StatelessWidget {
  const SeaHeroApp({
    super.key,
    required this.preferencesService,
    required this.audioService,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00B4D8),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.tajawalTextTheme(),
    );

    return MaterialApp(
      title: 'Turtle Hero',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: MenuScreen(
        preferencesService: preferencesService,
        audioService: audioService,
      ),
    );
  }
}
