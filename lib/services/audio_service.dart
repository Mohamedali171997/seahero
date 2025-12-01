import 'package:flame_audio/flame_audio.dart';

import 'preferences_service.dart';

enum SfxType { collect, hit, click }

class AudioService {
  AudioService({required PreferencesService preferencesService})
      : _preferencesService = preferencesService;

  final PreferencesService _preferencesService;
  bool _isBgmPlaying = false;

  Future<void> preload() async {
    FlameAudio.audioCache.prefix = 'assets/audio/';
    await FlameAudio.audioCache.loadAll(const [
      'collect.ogg',
      'hit.ogg',
      'click.ogg',
    ]);
    FlameAudio.bgm.initialize();
  }

  void playBgm() {
    if (!_preferencesService.musicEnabled || _isBgmPlaying) return;
    _isBgmPlaying = true;
    FlameAudio.bgm.play('bgm_ocean.ogg', volume: 0.6).catchError((_) {
      _isBgmPlaying = false;
    });
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
    _isBgmPlaying = false;
  }

  void resumeBgm() {
    if (!_preferencesService.musicEnabled) return;
    FlameAudio.bgm.resume().then((_) {
      _isBgmPlaying = true;
    }).catchError((_) {
      _isBgmPlaying = false;
    });
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
    _isBgmPlaying = false;
  }

  void playSfx(SfxType type) {
    if (!_preferencesService.soundEnabled) return;
    final track = switch (type) {
      SfxType.collect => 'collect.ogg',
      SfxType.hit => 'hit.ogg',
      SfxType.click => 'click.ogg',
    };
    try {
      FlameAudio.play(track, volume: 0.9);
    } catch (_) {
      // Ignore audio errors
    }
  }
}

