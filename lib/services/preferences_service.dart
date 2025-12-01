import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _bestScoreKey = 'bestScore';
  static const _soundKey = 'soundEnabled';
  static const _musicKey = 'musicEnabled';
  static const _vibrationKey = 'vibrationEnabled';
  static const _languageKey = 'language';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get bestScore => _prefs.getInt(_bestScoreKey) ?? 0;

  Future<void> saveBestScore(int score) async {
    if (score > bestScore) {
      await _prefs.setInt(_bestScoreKey, score);
    }
  }

  bool get soundEnabled => _prefs.getBool(_soundKey) ?? true;

  Future<void> setSoundEnabled(bool value) =>
      _prefs.setBool(_soundKey, value);

  bool get musicEnabled => _prefs.getBool(_musicKey) ?? true;

  Future<void> setMusicEnabled(bool value) =>
      _prefs.setBool(_musicKey, value);

  bool get vibrationEnabled => _prefs.getBool(_vibrationKey) ?? true;

  Future<void> setVibrationEnabled(bool value) =>
      _prefs.setBool(_vibrationKey, value);

  String get language => _prefs.getString(_languageKey) ?? 'ar';

  Future<void> setLanguage(String value) =>
      _prefs.setString(_languageKey, value);
}

