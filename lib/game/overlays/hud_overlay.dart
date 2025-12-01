import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/audio_service.dart';
import '../turtle_hero_game.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});

  static const id = 'hud';
  final TurtleHeroGame game;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    );
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Score', style: textTheme.bodyMedium),
                ValueListenableBuilder<int>(
                  valueListenable: game.scoreNotifier,
                  builder: (context, score, _) => Text(
                    '$score',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 8,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    game.audioService.playSfx(SfxType.click);
                    game.togglePause();
                  },
                  icon: const Icon(Icons.pause_circle_filled),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.white70),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: game.factNotifier,
                      builder: (context, fact, _) => Text(
                        fact,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 90,
            child: ValueListenableBuilder<int>(
              valueListenable: game.livesNotifier,
              builder: (context, lives, _) => Row(
                children: List.generate(
                  lives,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.favorite, color: Colors.pinkAccent),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

