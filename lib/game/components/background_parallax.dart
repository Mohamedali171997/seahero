
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
    final level = (game as TurtleHeroGame).level;
    
    // Default layers
    final layers = [
      ParallaxImageData('backgrounds/layer1.png'),
      ParallaxImageData('backgrounds/layer2.png'),
      ParallaxImageData('backgrounds/layer3.png'),
    ];

    // Add Seaweed layers for Level 2
    if (level == 2) {
      layers.add(ParallaxImageData('backgrounds/seaweed.png'));
      layers.add(ParallaxImageData('backgrounds/seaweed2.png'));
    }

    parallax = await game.loadParallax(
      layers,
      baseVelocity: Vector2(level == 2 ? -30 : -20, 0), // Faster base speed for level 2
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
