
import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import 'components/background_parallax.dart';

class EcosystemGame extends FlameGame with TapDetector {
  EcosystemGame({
    required this.preferencesService,
    required this.audioService,
  }) : super();

  final PreferencesService preferencesService;
  final AudioService audioService;
  
  // Game State
  double pollutionLevel = 0.0; // 0.0 (Clean) -> 1.0 (Polluted)
  int targetFishCount = 5;
  int targetSeaweedCount = 3;
  
  // Containers
  late final Timer _pollutionTimer;
  
  // Visuals
  late RectangleComponent _overlayFilter;

  @override
  Color backgroundColor() => const Color(0xFF006994); // Deep sea blue base

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Static Background (Reusing parallax but static or slow)
    // For ecosystem, we might just want a nice static gradient or the parallax moving very slowly.
    // Let's use the parallax but with 0 velocity to show independent layers or just a static image.
    // Actually, let's reuse BackgroundParallax but tell it to be static? 
    // The current BackgroundParallax is tied to TurtleHeroGame loops. 
    // Let's just add the layers manually here for simplicity.
    
    add(SpriteComponent()
      ..sprite = await loadSprite('backgrounds/layer1.png')
      ..size = size
      ..priority = -10
    );
    
    // 2. Overlay for pollution (darkens/greens the water)
    _overlayFilter = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.transparent,
      priority: 100, // On top of everything
    );
    add(_overlayFilter);

    // 3. Initial Spawn
    _updateSeaweed();
    _updateFish();
    _updateTrash();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Smoothly interpolate filter color based on pollution
    // Pollution makes water darker (Black opacity) and murkier (Greenish)
    final pollutionAlpha = (pollutionLevel * 180).clamp(0, 200).toInt();
    _overlayFilter.paint.color = Color.fromARGB(pollutionAlpha, 20, 40, 0);

    // Continuous Spawn Logic to match targets
    _maintainPopulation(dt);
  }

  void _maintainPopulation(double dt) {
    // Fish
    final fish = children.whereType<EcosystemFish>().toList();
    if (fish.length < targetFishCount) {
      if (Random().nextDouble() < 0.1) _spawnFish();
    } else if (fish.length > targetFishCount) {
      fish.first.removeFromParent();
    }

    // Seaweed
    final seaweed = children.whereType<SeaweedComponent>().toList();
    if (seaweed.length < targetSeaweedCount) {
      _spawnSeaweed();
    } else if (seaweed.length > targetSeaweedCount) {
      seaweed.first.removeFromParent(); // Remove simplisticly
    }
    
    // Trash (Driven by pollution level, not a slider directly, but user can add/remove)
    // Actually user sets parameters "Pollution".
    final trash = children.whereType<EcosystemTrash>().toList();
    final targetTrash = (pollutionLevel * 10).toInt(); // 0 to 10 pieces
    if (trash.length < targetTrash) {
      _spawnTrash(); // Spawn immediately
    } else if (trash.length > targetTrash) {
      trash.first.removeFromParent();
    }
  }

  void _spawnFish() {
    final fishTypes = [
      'images/fishSVG/fish_blue.svg',
      'images/fishSVG/fish_green.svg',
      'images/fishSVG/fish_orange.svg',
      'images/fishSVG/fish_pink.svg',
    ];
    final type = fishTypes[Random().nextInt(fishTypes.length)];
    add(EcosystemFish(assetPath: type));
  }
  
  void _spawnSeaweed() {
    final isType2 = Random().nextBool();
    add(SeaweedComponent(isType2: isType2)
        ..position = Vector2(
          Random().nextDouble() * size.x, 
          size.y - (100 + Random().nextDouble() * 50) // Bottom anchored
        )
    );
  }

  void _spawnTrash() {
    add(EcosystemTrash());
  }
  
  // Public methods for UI to call
  void setFishCount(double val) => targetFishCount = val.toInt();
  void setSeaweedCount(double val) => targetSeaweedCount = val.toInt();
  void setPollutionLevel(double val) => pollutionLevel = val;

  // Helper methods
  void _updateSeaweed() {} // Handled in update loop
  void _updateFish() {}    // Handled in update loop
  void _updateTrash() {}   // Handled in update loop
}


// --- Components ---

enum FishDiet { herbivore, carnivore }

class EcosystemFish extends SvgComponent with HasGameRef<EcosystemGame> {
  EcosystemFish({required this.assetPath}) 
      : diet = assetPath.contains('orange') ? FishDiet.carnivore : FishDiet.herbivore,
        super(size: Vector2(60, 40), anchor: Anchor.center);
  
  final String assetPath;
  final FishDiet diet;
  late Vector2 _velocity;
  final double _baseSpeed = 60.0;
  double _time = Random().nextDouble() * 100;
  
  // Feeding state
  PositionComponent? _targetFood;
  double _eatingCooldown = 0.0;

  @override
  Future<void> onLoad() async {
    try {
      svg = await gameRef.loadSvg(assetPath);
    } catch (e) {
      debugPrint('Failed to load SVG: $e');
    }
    
    // Carnivores are slightly bigger and faster
    if (diet == FishDiet.carnivore) {
      size = Vector2(80, 50);
    }
    
    position = Vector2(
      Random().nextDouble() * gameRef.size.x,
      Random().nextDouble() * gameRef.size.y,
    );
    _pickNewVelocity();
  }
  
  @override
  void render(Canvas canvas) {
    if (svg == null) {
      canvas.drawOval(
        size.toRect(), 
        Paint()..color = diet == FishDiet.carnivore ? Colors.redAccent : Colors.orangeAccent
      );
    } else {
      super.render(canvas);
    }
  }

  void _pickNewVelocity() {
    final angle = Random().nextDouble() * 2 * pi;
    final speedMult = diet == FishDiet.carnivore ? 1.4 : 1.0;
    _velocity = Vector2(cos(angle), sin(angle))..scale(_baseSpeed * speedMult);
    _orientVisuals();
  }
  
  void _orientVisuals() {
    if (_velocity.x > 0) {
      scale = Vector2(-1, 1); // Face right
    } else {
      scale = Vector2(1, 1); // Face left
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_eatingCooldown > 0) _eatingCooldown -= dt;

    // Pollution Effect
    double currentSpeedMult = 1.0;
    if (gameRef.pollutionLevel > 0.5) {
      currentSpeedMult = 0.3;
      angle = sin(_time * 5) * 0.2; 
    } else {
      angle = sin(_time * 2) * 0.1; 
      
      // AI Logic: Seek Food if hungry (cooldown is done) and water is clean enough to see
      if (_eatingCooldown <= 0 && gameRef.pollutionLevel < 0.8) {
        _seekAndEat(dt);
      }
    }

    position += _velocity * currentSpeedMult * dt;

    // Bounce off walls
    if (position.x < 0 || position.x > gameRef.size.x) {
      _velocity.x *= -1;
      _orientVisuals();
      position.x = position.x.clamp(0, gameRef.size.x);
    }
    if (position.y < 0 || position.y > gameRef.size.y) {
      _velocity.y *= -1;
      position.y = position.y.clamp(0, gameRef.size.y);
    }

    // Wander randomly if no target
    if (_targetFood == null && Random().nextDouble() < 0.01) {
      _pickNewVelocity();
    }
  }
  
  void _seekAndEat(double dt) {
    // 1. Find target if we don't have one or it's gone
    if (_targetFood == null || _targetFood!.parent == null) {
      _targetFood = _findNearestFood();
    }
    
    // 2. Move towards target
    if (_targetFood != null) {
      final direction = (_targetFood!.position - position).normalized();
      final speedMult = diet == FishDiet.carnivore ? 1.5 : 1.0; // Sprint to food
      _velocity = direction * _baseSpeed * speedMult;
      _orientVisuals();
      
      // 3. Eat if close
      if (position.distanceTo(_targetFood!.position) < 30) {
        _targetFood!.removeFromParent();
        _targetFood = null;
        _eatingCooldown = 2.0 + Random().nextDouble() * 3.0; // Digest
        _pickNewVelocity(); // Wander away
      }
    }
  }
  
  PositionComponent? _findNearestFood() {
    final range = 300.0;
    PositionComponent? nearest;
    double minDistance = double.infinity;

    if (diet == FishDiet.herbivore) {
      // Look for Seaweed
      for (final seaweed in gameRef.children.whereType<SeaweedComponent>()) {
        final dist = position.distanceTo(seaweed.position);
        if (dist < range && dist < minDistance) {
          minDistance = dist;
          nearest = seaweed;
        }
      }
    } else {
      // Carnivore: Look for other Fish (smaller/different type)
      // For simplicity: Carnivores eat Herbivores (non-orange fish)
      for (final fish in gameRef.children.whereType<EcosystemFish>()) {
        if (fish == this) continue;
        if (fish.diet == FishDiet.herbivore) {
           final dist = position.distanceTo(fish.position);
           if (dist < range && dist < minDistance) {
             minDistance = dist;
             nearest = fish;
           }
        }
      }
    }
    return nearest;
  }
}

class SeaweedComponent extends SpriteComponent with HasGameRef<EcosystemGame> {
  SeaweedComponent({this.isType2 = false}) : super(anchor: Anchor.bottomCenter);
  final bool isType2;
  
  @override
  Future<void> onLoad() async {
    try {
      sprite = await gameRef.loadSprite(isType2 ? 'backgrounds/seaweed2.png' : 'backgrounds/seaweed.png');
    } catch (e) {
       debugPrint('Failed to load Seaweed: $e');
    }
    size = Vector2(80, 160); // Approx size
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite == null) {
      canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
    }
  }
}

class EcosystemTrash extends SpriteComponent with HasGameRef<EcosystemGame> {
  EcosystemTrash() : super(anchor: Anchor.center, size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
     final options = [
      'entities/trash_bottle.png',
      'entities/trash_bag.png',
      'entities/trash_can.png',
    ];
    try {
      sprite = await gameRef.loadSprite(options[Random().nextInt(options.length)]);
    } catch (e) { debugPrint('Trash load error: $e'); }
    
    position = Vector2(
      Random().nextDouble() * gameRef.size.x,
      Random().nextDouble() * gameRef.size.y,
    );
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite == null) {
      canvas.drawRect(size.toRect(), Paint()..color = Colors.grey);
    }
  }
  
  // Float around
  double _time = Random().nextDouble() * 100;
  
  @override
  void update(double dt) {
    _time += dt;
    position.y += sin(_time) * 0.5;
    position.x += cos(_time * 0.7) * 0.3;
  }
}
