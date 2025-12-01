import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/preferences_service.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key, required this.preferencesService});

  final PreferencesService preferencesService;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('أفضل النتائج'),
        backgroundColor: const Color(0xFF003566),
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'أفضل نتيجة مسجلة',
                style: textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                '${preferencesService.bestScore}',
                style: textTheme.displayMedium?.copyWith(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'واصل اللعب لتحسن أرقامك وتساعد السلاحف!',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

