# Turtle Hero - Sea Turtle Protection Game

An educational 2D side-scrolling game built with Flutter and Flame engine, designed to teach children about protecting sea turtles from ocean pollution.

## 🎮 Game Overview

Players control a sea turtle that moves up and down to:
- **Dodge falling trash** (plastic bottles, bags, straws, cans)
- **Collect jellyfish** for points
- **Learn about ocean pollution** through educational facts

## 🛠️ Technology Stack

- **Flutter** - Cross-platform framework
- **Flame** (v1.23.0) - 2D game engine
- **Flame Audio** (v2.10.7) - Audio management
- **Shared Preferences** - Local storage for scores and settings
- **Google Fonts** - Child-friendly Arabic typography

## 📱 Platform

- **Target**: Android (mobile) and Web
- **Orientation**: Landscape only
- **Performance**: Optimized for 60 FPS on low-end devices
- **Web Support**: Full support with mouse and touch controls

## 🎯 Features

### Gameplay
- Smooth turtle movement (up/down) with underwater physics
- Dynamic trash spawning with increasing difficulty
- Jellyfish collection system
- Collision detection using Flame's collision system
- Lives system (3 lives)
- Score tracking with best score persistence

### Screens
1. **Main Menu** - Play, High Scores, Settings
2. **Gameplay Screen** - Main game with HUD overlay
3. **Pause Menu** - Resume, Restart, Quit
4. **Game Over Screen** - Final score, best score, replay options
5. **High Scores Screen** - View top scores
6. **Settings Screen** - Sound/music toggles

### Educational Content
- Rotating Arabic facts about sea turtle protection
- Environmental awareness messages
- Pollution impact education

### Audio
- Background music (looping ocean theme)
- Sound effects:
  - Collect jellyfish
  - Hit trash
  - Menu clicks

## 📦 Project Structure

```
lib/
├── game/
│   ├── components/
│   │   ├── background_parallax.dart
│   │   ├── jellyfish_component.dart
│   │   ├── trash_component.dart
│   │   └── turtle_component.dart
│   ├── managers/
│   │   └── spawn_manager.dart
│   ├── overlays/
│   │   ├── game_over_overlay.dart
│   │   ├── hud_overlay.dart
│   │   └── pause_overlay.dart
│   └── turtle_hero_game.dart
├── screens/
│   ├── gameplay_screen.dart
│   ├── high_scores_screen.dart
│   ├── menu_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── audio_service.dart
│   └── preferences_service.dart
├── widgets/
│   └── sea_button.dart
└── main.dart
```

## 🎨 Assets Required

Place your assets in the following directories:

```
assets/
├── images/
│   ├── backgrounds/
│   │   ├── layer1.png
│   │   ├── layer2.png
│   │   └── layer3.png
│   ├── entities/
│   │   ├── turtle.png
│   │   ├── jellyfish.png
│   │   ├── trash_bottle.png
│   │   ├── trash_bag.png
│   │   ├── trash_straw.png
│   │   └── trash_can.png
│   └── ui/
│       ├── pause.png
│       ├── play.png
│       ├── home.png
│       └── restart.png
└── audio/
    ├── bgm_ocean.ogg
    ├── collect.ogg
    ├── hit.ogg
    └── click.ogg
```

**Note**: Placeholder assets are currently in place. Replace them with your actual game assets.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator

### Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd seahero
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your assets**
   - Replace placeholder images in `assets/images/`
   - Add audio files to `assets/audio/`

4. **Run the game**
   ```bash
   flutter run
   ```

### Building for Android

```bash
flutter build apk --release
```

Or for app bundle:
```bash
flutter build appbundle --release
```

### Building for Web

```bash
flutter build web --release
```

Then serve the `build/web` directory using any web server, or use:
```bash
flutter run -d chrome
```

**Web Controls:**
- **Mouse**: Click and drag to move turtle
- **Touch**: Tap and drag on touch-enabled devices
- Works best in landscape browser window

## 🎮 Controls

- **Tap/Drag**: Move turtle up or down
- **Movement**: Smooth, floaty underwater physics
- **Pause**: Tap pause button in top-right during gameplay

## ⚙️ Game Mechanics

### Difficulty Progression
- Trash spawns every 1.8 seconds initially
- Spawn rate increases every 8 seconds
- Minimum spawn interval: 0.7 seconds

### Scoring
- Collect jellyfish: +10 points
- Best score is automatically saved

### Lives
- Start with 3 lives
- Lose 1 life per trash collision
- Game over when lives reach 0

## 🔧 Configuration

### Landscape Mode
The game is configured for landscape orientation:
- `main.dart` sets preferred orientations
- `AndroidManifest.xml` locks landscape mode
- UI is optimized for landscape layout

### Performance
- Optimized for 60 FPS
- Memory target: < 120MB
- Efficient collision detection
- Parallax background for depth

## 📝 Educational Facts

The game displays rotating facts in Arabic about:
- Sea turtle confusion with plastic bags
- Light pollution effects
- Fishing net dangers
- Recycling importance
- Beach cleanup impact

## 🐛 Troubleshooting

### Audio Issues
- Ensure audio files are in OGG format
- Check file paths in `assets/audio/`
- Verify audio permissions in AndroidManifest

### Asset Loading
- Verify all asset paths in `pubspec.yaml`
- Run `flutter clean` and `flutter pub get` if assets don't load
- Check file names match exactly (case-sensitive)

### Performance
- Test on physical device for accurate performance
- Reduce parallax layers if needed
- Optimize image sizes (compress PNGs)

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Development Notes

- All game logic uses Flame's component system
- Collision detection via Flame's `CollisionCallbacks`
- State management with `ValueNotifier` for UI updates
- Persistent storage with `shared_preferences`
- Audio management through `flame_audio`

## 🎯 Next Steps

1. **Add your assets** - Replace placeholder images and audio
2. **Test on device** - Verify performance and controls
3. **Customize facts** - Update educational content in `turtle_hero_game.dart`
4. **Polish UI** - Adjust colors, fonts, and animations
5. **Add more features** - Power-ups, different turtle types, etc.

---

**Happy coding! 🐢🌊**
