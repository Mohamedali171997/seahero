import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import '../widgets/sea_button.dart';
import 'gameplay_screen.dart';
import 'high_scores_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.preferencesService,
    required this.audioService,
  });

  final PreferencesService preferencesService;
  final AudioService audioService;

  @override
  Widget build(BuildContext context) {
    final headline = GoogleFonts.tajawal(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001845), Color(0xFF003566)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            const _FloatingBubble(
              delay: Duration(seconds: 2),
              left: 60,
              size: 60,
            ),
            const _FloatingBubble(
              delay: Duration(seconds: 4),
              left: 280,
              size: 90,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text('Turtle Hero', style: headline),
                    const SizedBox(height: 8),
                    Text(
                      'ساعد السلحفاة في النجاة من التلوث!',
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SeaButton(
                      label: 'ابدأ اللعب',
                      icon: Icons.play_arrow,
                      onPressed: () {
                        audioService.playSfx(SfxType.click);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameplayScreen(
                              preferencesService: preferencesService,
                              audioService: audioService,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SeaButton(
                      label: 'أفضل النتائج',
                      icon: Icons.emoji_events,
                      onPressed: () {
                        audioService.playSfx(SfxType.click);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HighScoresScreen(
                              preferencesService: preferencesService,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SeaButton(
                      label: 'الإعدادات',
                      icon: Icons.settings,
                      onPressed: () {
                        audioService.playSfx(SfxType.click);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsScreen(
                              preferencesService: preferencesService,
                              audioService: audioService,
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingBubble extends StatefulWidget {
  const _FloatingBubble({
    required this.delay,
    required this.left,
    required this.size,
  });

  final Duration delay;
  final double left;
  final double size;

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = ( _controller.value * 0.4) - 0.2;
        return Positioned(
          left: widget.left,
          top: 100 + offset * 60,
          child: child!,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

