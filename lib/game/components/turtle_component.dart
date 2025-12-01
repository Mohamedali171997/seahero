import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../turtle_hero_game.dart';

class TurtleComponent extends SpriteComponent
    with HasGameRef<TurtleHeroGame>, CollisionCallbacks {
  TurtleComponent();

  double _targetY = 0; // Where the player wants to move
  double _velocityY = 0; // For smooth damping movement
  double _smoothFactor = 12.0; // Higher = faster smoothing
  double _targetX = 0; // Desired X on screen
  double _velocityX = 0; // Horizontal velocity (for inertia)
  double _accelerationX = 40.0; // Accel strength toward target
  double _frictionX = 6.0; // Friction to slow down horizontal motion

  // Swimming animation
  double _time = 0;
  final double _tiltAmplitude = 0.06;
  final double _tiltFrequency = 6.0;
  final double _scaleAmplitude = 0.02;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2(140, 110);
    anchor = Anchor.center;

    position = Vector2(
      gameRef.size.x / 2,
      gameRef.size.y / 2,
    );

    _targetY = position.y;
    _targetX = position.x;

    sprite = await gameRef.loadSprite('entities/turtle.png');

    add(
      CircleHitbox()
        ..collisionType = CollisionType.active
        ..radius = size.y * 0.35,
    );
  }

  /// Smoothly moves turtle toward target Y
  void moveTo(double y) {
    // Clamp inside screen
    _targetY = y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
  }

  void moveToX(double x) {
    // clamp to visible screen bounds
    _targetX = x.clamp(size.x / 2, gameRef.size.x - size.x / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // --- SMOOTH VERTICAL MOVEMENT (like Hungry Shark Evolution) ---
    double dy = _targetY - position.y;
    _velocityY = dy * _smoothFactor * dt; // smooth interpolation
    position.y += _velocityY;

    // --- SMOOTH HORIZONTAL MOVEMENT WITH INERTIA ---
    final dx = _targetX - position.x;
    _velocityX += dx * _accelerationX * dt; // accelerate toward target
    position.x += _velocityX * dt; // move
    // apply friction
    _velocityX *= max(0.0, 1.0 - _frictionX * dt);

    // --- FAKE CAMERA EFFECT: update world offset in game ---
    // movement of the turtle results in updating the game's world offset.
    // This creates the illusion of camera movement when backgrounds react.
    gameRef.worldOffsetX += _velocityX * dt;

    // --- SWIMMING ANIMATION (illusion of forward movement) ---
    _time += dt;
    angle = sin(_time * _tiltFrequency) * _tiltAmplitude;

    double s = 1.0 + sin(_time * (_tiltFrequency / 1.8)) * _scaleAmplitude;
    scale = Vector2.all(s);
  }
}
