import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/audio_service.dart';
import '../turtle_hero_game.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  static const id = 'game_over';
  final TurtleHeroGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    );
    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.tealAccent),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'أنقذت السلحفاة!',
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'النتيجة',
              style: textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            Text(
              '${game.score}',
              style: textTheme.displaySmall?.copyWith(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'أفضل نتيجة: ${game.bestScore}',
              style: textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      game.audioService.playSfx(SfxType.click);
                      game.restart();
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('إعادة اللعب'),
                    style: _buttonStyle(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      game.audioService.playSfx(SfxType.click);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('القائمة'),
                    style: _buttonStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

