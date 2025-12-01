import 'dart:math';
import 'package:flame/components.dart';
import '../turtle_hero_game.dart';
import '../components/jellyfish_component.dart';
import '../components/trash_component.dart';

class SpawnManager extends Component with HasGameRef<TurtleHeroGame> {
  SpawnManager();

  double _spawnInterval = 1.8;
  double _timeSinceLastSpawn = 0;
  double _timeSinceLastDifficultyIncrease = 0;
  final double _difficultyIncreaseInterval = 8.0;
  final double _minSpawnInterval = 0.7;
  final Random _random = Random();

  @override
  void update(double dt) {
    super.update(dt);
    
    _timeSinceLastSpawn += dt;
    _timeSinceLastDifficultyIncrease += dt;

    // Increase difficulty over time
    if (_timeSinceLastDifficultyIncrease >= _difficultyIncreaseInterval) {
      _timeSinceLastDifficultyIncrease = 0;
      _spawnInterval = (_spawnInterval - 0.1).clamp(_minSpawnInterval, double.infinity);
    }

    // Spawn objects
    if (_timeSinceLastSpawn >= _spawnInterval) {
      _timeSinceLastSpawn = 0;
      _spawnObject();
    }
  }

  void _spawnObject() {
    // Spawn from TOP of screen at random X position
    final x = _random.nextDouble() * gameRef.size.x;
    final y = -50.0; // Just above the screen
    
    // 30% chance to spawn jellyfish, 70% chance to spawn trash
    if (_random.nextDouble() < 0.3) {
      _spawnJellyfish(x, y);
    } else {
      _spawnTrash(x, y);
    }
  }

  void _spawnJellyfish(double x, double y) {
    final jellyfish = JellyfishComponent()
      ..position = Vector2(x, y);
    gameRef.add(jellyfish);
  }

  void _spawnTrash(double x, double y) {
    final speed = 150.0 + (_random.nextDouble() * 100);
    final trash = TrashComponent(speed: speed)
      ..position = Vector2(x, y);
    gameRef.add(trash);
  }

  void reset() {
    _spawnInterval = 1.8;
    _timeSinceLastSpawn = 0;
    _timeSinceLastDifficultyIncrease = 0;
  }
}