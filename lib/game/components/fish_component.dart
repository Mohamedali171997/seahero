import 'dart:math';

import 'package:flame/components.dart';
// Removed unnecessary imports; extensions and events not needed here
import 'package:flame_svg/flame_svg.dart';

import '../turtle_hero_game.dart';

class FishComponent extends SvgComponent with HasGameRef<TurtleHeroGame> {
  FishComponent({required this.assetPath, Vector2? position, double? speed})
      : super(anchor: Anchor.center, size: Vector2(80, 40)) {
    _startPosition = position;
    _baseSpeed = speed ?? (30 + Random().nextDouble() * 40);
  }

  final String assetPath;
  Vector2? _startPosition;
  late double _baseSpeed;

  double _time = 0.0;
  double _verticalAmplitude = 12.0;
  double _verticalFrequency = 1.8;
  double _headingNoise = 0.0;
  Vector2 _velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await gameRef.loadSvg(assetPath);
    position = _startPosition ?? Vector2(Random().nextDouble() * gameRef.size.x, Random().nextDouble() * gameRef.size.y);
    // Randomize some params so fish look different
    _verticalAmplitude = 6.0 + Random().nextDouble() * 18.0;
    _verticalFrequency = 1.0 + Random().nextDouble() * 1.5;
    _headingNoise = Random().nextDouble() * 2.0 - 1.0;
    // start velocity horizontally either left or right
    final direction = Random().nextBool() ? 1.0 : -1.0;
    _velocity = Vector2(direction * _baseSpeed, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    // Sinusoidal vertical bobbing for swimming
    final bob = sin(_time * _verticalFrequency) * _verticalAmplitude;
    // Horizontal wandering (adds small noise to horizontal cursor-like motion)
    final noise = sin(_time * (0.6 + (_headingNoise.abs() % 1.2))) * (_headingNoise * 12.0);
    // Update velocity with noise
    _velocity.x += noise * dt;
    // Apply slight friction to horizontal speed so it doesn't go infinite
    _velocity.x *= 0.995;
    // Move
    position += _velocity * dt;
    position.y += bob * dt * 10.0; // scale

    // Tweak rotation to follow direction smoothly
    final targetAngle = atan2(_velocity.y, _velocity.x);
    angle = angle + (targetAngle - angle) * (0.1);

    // If fish goes off-screen horizontally, wrap it around
    if (position.x < -size.x) {
      position.x = gameRef.size.x + size.x;
    } else if (position.x > gameRef.size.x + size.x) {
      position.x = -size.x;
    }
    // Clamp vertical position to slightly inside screen bounds
    if (position.y < size.y / 2) position.y = size.y / 2 + 4;
    if (position.y > gameRef.size.y - size.y / 2) position.y = gameRef.size.y - size.y / 2 - 4;
  }
}
