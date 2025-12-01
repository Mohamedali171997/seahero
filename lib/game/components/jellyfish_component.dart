import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../turtle_hero_game.dart';
import 'turtle_component.dart';

class JellyfishComponent extends SpriteComponent
    with HasGameRef<TurtleHeroGame>, CollisionCallbacks {
  JellyfishComponent()
      : _horizontalDrift = Random().nextDouble() * 40 - 20,
        _rotationTarget = Random().nextDouble() * 0.2;

  final double _horizontalDrift;
  final double _rotationTarget;

  @override
Future<void> onLoad() async {
  await super.onLoad();
  size = Vector2(90, 100);
  anchor = Anchor.center;
  
  // FIX: Remove 'assets/' prefix - Flame adds it automatically
  sprite = await gameRef.loadSprite('entities/jellyfish.png');

  add(CircleHitbox()
    ..collisionType = CollisionType.passive
    ..radius = size.x * 0.35);
}

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(_horizontalDrift * dt, 70 * dt);
    angle = sin(position.y / 50) * _rotationTarget;
    if (position.y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is TurtleComponent) {
      gameRef.handleCollect(this);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

