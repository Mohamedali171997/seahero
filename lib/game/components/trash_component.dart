import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../turtle_hero_game.dart';
import 'turtle_component.dart';

class TrashComponent extends SpriteComponent
    with HasGameRef<TurtleHeroGame>, CollisionCallbacks {
  TrashComponent({
    required this.speed,
  });

  final double speed;
  late final double _rotationSpeed;
  late final double _horizontalDrift; // Slight left/right drift

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(90, 90);
    anchor = Anchor.center;
    
    final options = [
      'entities/trash_bottle.png',
      'entities/trash_bag.png',
      'entities/trash_straw.png',
      'entities/trash_can.png',
    ];
    final path = options[Random().nextInt(options.length)];

    sprite = await gameRef.loadSprite(path);

    _rotationSpeed = (Random().nextDouble() - 0.5) * 1.2;
    _horizontalDrift = (Random().nextDouble() - 0.5) * 30; // Random drift

    add(CircleHitbox()
      ..collisionType = CollisionType.passive
      ..radius = size.x * 0.35);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Fall DOWN with slight horizontal drift
    position += Vector2(_horizontalDrift * dt, speed * dt);
    angle += _rotationSpeed * dt;

    // Remove when off BOTTOM of screen
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
      gameRef.handleTrashHit(this);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

