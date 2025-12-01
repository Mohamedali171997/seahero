import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../game/overlays/game_over_overlay.dart';
import '../game/overlays/hud_overlay.dart';
import '../game/overlays/pause_overlay.dart';
import '../game/turtle_hero_game.dart';
import '../services/audio_service.dart';
import '../services/preferences_service.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.preferencesService,
    required this.audioService,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final TurtleHeroGame _game = TurtleHeroGame(
    preferencesService: widget.preferencesService,
    audioService: widget.audioService,
  );

  @override
  void dispose() {
    _game.pauseEngine();
    _game.audioService.pauseBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameWidget = GameWidget<TurtleHeroGame>(
      game: _game,
      overlayBuilderMap: {
        HudOverlay.id: (context, game) => HudOverlay(game: game),
        PauseOverlay.id: (context, game) => PauseOverlay(game: game),
        GameOverOverlay.id: (context, game) => GameOverOverlay(game: game),
      },
    );

    // On web, wrap in a container that maintains landscape aspect ratio
    if (kIsWeb) {
      return Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Maintain 16:9 aspect ratio on web
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;
              const targetAspectRatio = 16 / 9;
              
              double width = maxWidth;
              double height = maxWidth / targetAspectRatio;
              
              if (height > maxHeight) {
                height = maxHeight;
                width = maxHeight * targetAspectRatio;
              }
              
              return SizedBox(
                width: width,
                height: height,
                child: gameWidget,
              );
            },
          ),
        ),
      );
    }

    // On mobile, use full screen
    return Scaffold(
      body: gameWidget,
    );
  }
}

