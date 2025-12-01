import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import 'components/background_parallax.dart';
import 'components/jellyfish_component.dart';
import 'components/trash_component.dart';
import 'components/turtle_component.dart';
import 'managers/spawn_manager.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/hud_overlay.dart';
import 'overlays/pause_overlay.dart';

class TurtleHeroGame extends FlameGame
    with HasCollisionDetection, PanDetector, TapDetector {
  TurtleHeroGame({
    required this.preferencesService,
    required this.audioService,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;

  late TurtleComponent turtle;
  late SpawnManager spawnManager;

  int score = 0;
  int lives = 3;
  int bestScore = 0;
  bool _isManuallyPaused = false;
  bool _isGameOver = false;

  final ValueNotifier<String> factNotifier = ValueNotifier<String>('');
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier<int>(3);
  final List<String> _facts = [
    'السلاحف البحرية تخلط بين الأكياس البلاستيكية وقناديل البحر.',
    'التلوث الضوئي يربك صغار السلاحف عند خروجها من الأعشاش.',
    'شبكات الصيد المهجورة تحبس آلاف السلاحف كل عام.',
    'إعادة التدوير تساعد في حماية المحيطات من النفايات.',
    'كل قطعة بلاستيك تلتقطها من الشاطئ قد تنقذ حياة كائن بحري.',
  ];
  Timer? _factTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addAll([
      BackgroundParallax(),
      turtle = TurtleComponent(),
      spawnManager = SpawnManager(),
    ]);

    bestScore = preferencesService.bestScore;
    factNotifier.value = _facts.first;
    _factTimer = Timer(6, onTick: _rotateFacts, repeat: true)..start();

    overlays.add(HudOverlay.id);
    audioService.playBgm();
  }

  void _rotateFacts() {
    final next = Random().nextInt(_facts.length);
    factNotifier.value = _facts[next];
  }

  @override
  void update(double dt) {
    super.update(dt);
    _factTimer?.update(dt);
  }

  void handleCollect(JellyfishComponent jellyfish) {
    jellyfish.removeFromParent();
    score += 10;
    scoreNotifier.value = score;
    audioService.playSfx(SfxType.collect);
    if (score > bestScore) {
      bestScore = score;
      unawaited(preferencesService.saveBestScore(score));
    }
  }

  void handleTrashHit(TrashComponent trash) {
    trash.removeFromParent();
    if (_isGameOver) return;
    lives -= 1;
    livesNotifier.value = lives;
    audioService.playSfx(SfxType.hit);
    if (lives <= 0) {
      _triggerGameOver();
    }
  }

  void _triggerGameOver() {
    if (_isGameOver) return;
    _isGameOver = true;
    pauseEngine();
    audioService.pauseBgm();
    bestScore = score > bestScore ? score : bestScore;
    unawaited(preferencesService.saveBestScore(score));
    overlays.remove(HudOverlay.id);
    overlays.add(GameOverOverlay.id);
  }

  void restart() {
    overlays.remove(GameOverOverlay.id);
    overlays.add(HudOverlay.id);
    resumeEngine();
    _isGameOver = false;
    _isManuallyPaused = false;
    score = 0;
    scoreNotifier.value = 0;
    lives = 3;
    livesNotifier.value = 3;
    bestScore = preferencesService.bestScore;
    final trash = children.whereType<TrashComponent>().toList();
    for (final t in trash) {
      t.removeFromParent();
    }
    final jellyfish = children.whereType<JellyfishComponent>().toList();
    for (final j in jellyfish) {
      j.removeFromParent();
    }
    spawnManager.reset();
    turtle.position = Vector2(200, size.y / 2);
    audioService.resumeBgm();
  }

  void togglePause() {
    if (_isGameOver) return;
    if (_isManuallyPaused) {
      resumeGame();
    } else {
      pauseGame();
    }
  }

  void pauseGame() {
    if (_isManuallyPaused) return;
    _isManuallyPaused = true;
    pauseEngine();
    overlays.add(PauseOverlay.id);
    audioService.pauseBgm();
  }

  void resumeGame() {
    if (!_isManuallyPaused) return;
    _isManuallyPaused = false;
    overlays.remove(PauseOverlay.id);
    resumeEngine();
    audioService.resumeBgm();
  }


  @override
  void onPanStart(DragStartInfo info) {
    if (!_isManuallyPaused && !_isGameOver) {
      final y = info.raw.localPosition.dy;
      turtle.moveTo(y);
    }
    // no return value; handler is void
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!_isManuallyPaused && !_isGameOver) {
      final y = info.raw.localPosition.dy;
      turtle.moveTo(y);
    }
    // no return value; handler is void
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!_isManuallyPaused && !_isGameOver) {
      final y = info.raw.localPosition.dy;
      turtle.moveTo(y);
    }
    // no-op return; Flame's mixins expect void for these callbacks
  }

  @override
  void onRemove() {
    factNotifier.dispose();
    scoreNotifier.dispose();
    livesNotifier.dispose();
    _factTimer?.stop();
    super.onRemove();
  }
}

