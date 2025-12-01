import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/audio_service.dart';
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.preferencesService,
    required this.audioService,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _sound;
  late bool _music;
  late bool _vibration;
  late String _language;

  @override
  void initState() {
    super.initState();
    _sound = widget.preferencesService.soundEnabled;
    _music = widget.preferencesService.musicEnabled;
    _vibration = widget.preferencesService.vibrationEnabled;
    _language = widget.preferencesService.language;
  }

  Future<void> _updateSound(bool value) async {
    setState(() => _sound = value);
    await widget.preferencesService.setSoundEnabled(value);
  }

  Future<void> _updateMusic(bool value) async {
    setState(() => _music = value);
    await widget.preferencesService.setMusicEnabled(value);
    if (value) {
      widget.audioService.resumeBgm();
    } else {
      widget.audioService.pauseBgm();
    }
  }

  Future<void> _updateVibration(bool value) async {
    setState(() => _vibration = value);
    await widget.preferencesService.setVibrationEnabled(value);
  }

  Future<void> _updateLanguage(String value) async {
    setState(() => _language = value);
    await widget.preferencesService.setLanguage(value);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: const Color(0xFF003566),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile(
            title: 'المؤثرات الصوتية',
            value: _sound,
            onChanged: _updateSound,
          ),
          _buildSwitchTile(
            title: 'الموسيقى',
            value: _music,
            onChanged: _updateMusic,
          ),
          _buildSwitchTile(
            title: 'الاهتزاز',
            value: _vibration,
            onChanged: _updateVibration,
          ),
          const Divider(),
          ListTile(
            title: Text('اللغة', style: titleStyle.titleMedium),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) _updateLanguage(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent,
    );
  }
}

