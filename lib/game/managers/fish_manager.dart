import 'dart:math';

import 'package:flame/components.dart';

import '../components/fish_component.dart';
import '../turtle_hero_game.dart';

class FishManager extends Component with HasGameRef<TurtleHeroGame> {
  FishManager({this.spawnInterval = 3.5}) {
    _rand = Random();
  }

  final double spawnInterval;
  late final Random _rand;
  double _time = 0.0;

  // Flame loads assets relative to the asset directory, so omit the initial "assets/" prefix
  final List<String> fishAssets = [
    'images/fishSVG/fish_blue.svg',
    'images/fishSVG/fish_green.svg',
    'images/fishSVG/fish_orange.svg',
    'images/fishSVG/fish_pink.svg',
    'images/fishSVG/fish_red.svg',
    'images/fishSVG/fish_brown.svg',
  ];

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_time >= spawnInterval) {
      _time = 0;
      _spawnFish();
    }
  }

  void _spawnFish() {
    final side = _rand.nextBool();
    final y = _rand.nextDouble() * (gameRef.size.y - 80) + 40;
    final asset = fishAssets[_rand.nextInt(fishAssets.length)];
    final pos = Vector2(side ? -40 : gameRef.size.x + 40, y);
    final baseSpeed = 20 + _rand.nextDouble() * 40;
    final fish = FishComponent(assetPath: asset, position: pos, speed: baseSpeed);
    gameRef.add(fish);
  }
}
