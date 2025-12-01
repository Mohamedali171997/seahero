import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/audio_service.dart';
import '../turtle_hero_game.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.game});

  static const id = 'pause';
  final TurtleHeroGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    );
    return Center(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'متوقف مؤقتًا',
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildButton(
              context,
              label: 'متابعة',
              onTap: () {
                game.audioService.playSfx(SfxType.click);
                game.resumeGame();
              },
            ),
            _buildButton(
              context,
              label: 'إعادة البدء',
              onTap: () {
                game.audioService.playSfx(SfxType.click);
                game.restart();
              },
            ),
            _buildButton(
              context,
              label: 'خروج إلى القائمة',
              onTap: () {
                game.audioService.playSfx(SfxType.click);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

