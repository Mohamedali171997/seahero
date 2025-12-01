
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import '../turtle_hero_game.dart';

class BackgroundParallax extends ParallaxComponent {
  BackgroundParallax()
      : super(
          priority: -1,
        );

 @override
Future<void> onLoad() async {
      parallax = await game.loadParallax(
      [
        ParallaxImageData('backgrounds/layer1.png'),
        ParallaxImageData('backgrounds/layer2.png'),
        ParallaxImageData('backgrounds/layer3.png'),
      ],
      baseVelocity: Vector2(-20, 0), // base scroll LEFT to simulate forward movement
      velocityMultiplierDelta: Vector2(1.5, 0),
      fill: LayerFill.height,
    );
}

  double _lastWorldOffset = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    if (parallax == null) return;
    final worldOffset = (game as TurtleHeroGame).worldOffsetX;
    final delta = worldOffset - _lastWorldOffset;
    final speed = dt > 0 ? (delta / dt) : 0.0;
    // Add player-induced scroll on top of base velocity; negative because world offset positive means turtle moved right, so background moves left.
    parallax!.baseVelocity = Vector2(-20.0 + (-speed * 0.6), 0);
    _lastWorldOffset = worldOffset;
  }
}
