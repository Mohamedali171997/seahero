
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

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
      baseVelocity: Vector2(-20, 0), // Scroll LEFT to simulate forward movement
      velocityMultiplierDelta: Vector2(1.5, 0),
      fill: LayerFill.height,
    );
}
}
