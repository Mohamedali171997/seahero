import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../game/ecosystem_game.dart'; // Import EcosystemGame
import '../game/overlays/ecosystem_controls.dart'; // Import Controls
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
    this.level = 1,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;
  final int level;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final FlameGame _game;

  @override
  void initState() {
    super.initState();
    if (widget.level == 2) {
      _game = EcosystemGame(
        preferencesService: widget.preferencesService,
        audioService: widget.audioService,
      );
    } else {
      _game = TurtleHeroGame(
        preferencesService: widget.preferencesService,
        audioService: widget.audioService,
        level: widget.level,
      );
    }
  }

  @override
  void dispose() {
    if (_game is TurtleHeroGame) {
      (_game as TurtleHeroGame).pauseEngine();
      (_game as TurtleHeroGame).audioService.pauseBgm();
    } 
    // EcosystemGame handles simple dispose naturally
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level == 2) {
      return Scaffold(
        body: GameWidget(
          game: _game,
          overlayBuilderMap: {
            EcosystemControls.id: (context, game) => EcosystemControls(game: game as EcosystemGame),
          },
          initialActiveOverlays: const [EcosystemControls.id],
        ),
      );
    }

    final gameWidget = GameWidget<TurtleHeroGame>(
      game: _game as TurtleHeroGame,
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


