import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../turtle_hero_game.dart';

class TurtleComponent extends SpriteComponent
    with HasGameRef<TurtleHeroGame>, CollisionCallbacks {
  TurtleComponent();

  double _targetY = 0;
  final double _horizontalSpeed = 150.0; // Constant speed moving right

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(140, 110);
    anchor = Anchor.center;
    position = Vector2(200, gameRef.size.y / 2);
    _targetY = position.y;

    sprite = await gameRef.loadSprite('entities/turtle.png');

    add(CircleHitbox()
      ..collisionType = CollisionType.active
      ..radius = size.y * 0.35);
  }

  void moveTo(double y) {
    // Clamp Y position to keep turtle on screen
    _targetY = y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Smooth UP/DOWN movement towards target Y
    final dy = _targetY - position.y;
    position.y += dy * dt * 5;
    
    // Automatic LEFT to RIGHT movement
    position.x += _horizontalSpeed * dt;
    
    // Wrap around when turtle goes off right edge
    if (position.x > gameRef.size.x + size.x) {
      position.x = -size.x;
    }
  }
}

