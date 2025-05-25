import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _spinPlayer = AudioPlayer();
  final AudioPlayer _resultPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      stopBackgroundMusic();
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  Future<void> playSpinSound() async {
    if (!_soundEnabled) return;

    try {
      // Play your custom roulette spinning sound
      await _spinPlayer.play(AssetSource('sounds/roulette.mp3'));
    } catch (e) {
      // Fallback: Use haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  Future<void> playResultSound() async {
    if (!_soundEnabled) return;

    try {
      // Play your custom success sound
      await _resultPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      // Fallback: Use haptic feedback
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> playClickSound() async {
    if (!_soundEnabled) return;

    try {
      // Play your custom pop sound for button clicks
      await _clickPlayer.play(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      // Fallback: Use haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      // Play background music for extreme/hard categories
      await _backgroundMusicPlayer.play(
        AssetSource('sounds/Two Feet - Love is a Bitch.mp3'),
        mode: PlayerMode.mediaPlayer,
      );
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(
        0.3,
      ); // Lower volume for background
    } catch (e) {
      // Music failed to load, continue without background music
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundMusicPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (_musicEnabled) {
      await _backgroundMusicPlayer.resume();
    }
  }

  Future<void> stopSpinSound() async {
    await _spinPlayer.stop();
  }

  Future<void> stopAllSounds() async {
    await _spinPlayer.stop();
    await _resultPlayer.stop();
    await _clickPlayer.stop();
    await _backgroundMusicPlayer.stop();
  }

  void dispose() {
    _spinPlayer.dispose();
    _resultPlayer.dispose();
    _clickPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}
