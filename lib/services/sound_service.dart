import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal() {
    // Initialize players asynchronously
    _initializePlayers();
  }

  final AudioPlayer _spinPlayer = AudioPlayer();
  final AudioPlayer _resultPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _initialized = false;

  Future<void> _initializePlayers() async {
    if (_initialized) return;

    try {
      if (kDebugMode) print('SoundService: Initializing audio players...');

      // Set player mode for web compatibility
      await _spinPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _resultPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _clickPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _backgroundMusicPlayer.setPlayerMode(PlayerMode.mediaPlayer);

      _initialized = true;
      if (kDebugMode) {
        print('SoundService: Audio players initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SoundService: Failed to initialize players: $e');
      }
    }
  }

  // Public method to ensure initialization
  Future<void> ensureInitialized() async {
    if (!_initialized) {
      await _initializePlayers();
    }
  }

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

  void toggleAll() {
    _soundEnabled = !_soundEnabled;
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
    // Ensure initialization
    await ensureInitialized();

    if (!_soundEnabled) {
      if (kDebugMode) {
        print('SoundService: Sound disabled, skipping spin sound');
      }
      return;
    }

    try {
      if (kDebugMode) print('SoundService: Playing spin sound...');
      await _spinPlayer.stop(); // Stop any previous sound
      await _spinPlayer.play(AssetSource('sounds/roulette.mp3'));
      if (kDebugMode) print('SoundService: Spin sound played successfully');
    } catch (e) {
      if (kDebugMode) print('SoundService: Failed to play spin sound: $e');
      // Fallback: Use haptic feedback
      try {
        HapticFeedback.lightImpact();
      } catch (hapticError) {
        if (kDebugMode) {
          print('SoundService: Haptic feedback also failed: $hapticError');
        }
      }
    }
  }

  Future<void> playResultSound() async {
    // Ensure initialization
    await ensureInitialized();

    if (!_soundEnabled) {
      if (kDebugMode) {
        print('SoundService: Sound disabled, skipping result sound');
      }
      return;
    }

    try {
      if (kDebugMode) print('SoundService: Playing result sound...');
      await _resultPlayer.stop(); // Stop any previous sound
      await _resultPlayer.play(AssetSource('sounds/success.mp3'));
      if (kDebugMode) print('SoundService: Result sound played successfully');
    } catch (e) {
      if (kDebugMode) print('SoundService: Failed to play result sound: $e');
      // Fallback: Use haptic feedback
      try {
        HapticFeedback.mediumImpact();
      } catch (hapticError) {
        if (kDebugMode) {
          print('SoundService: Haptic feedback also failed: $hapticError');
        }
      }
    }
  }

  Future<void> playClickSound() async {
    // Ensure initialization
    await ensureInitialized();

    if (!_soundEnabled) {
      if (kDebugMode) {
        print('SoundService: Sound disabled, skipping click sound');
      }
      return;
    }

    try {
      if (kDebugMode) print('SoundService: Playing click sound...');
      await _clickPlayer.stop(); // Stop any previous sound
      await _clickPlayer.play(AssetSource('sounds/pop.mp3'));
      if (kDebugMode) print('SoundService: Click sound played successfully');
    } catch (e) {
      if (kDebugMode) print('SoundService: Failed to play click sound: $e');
      // Fallback: Use haptic feedback
      try {
        HapticFeedback.selectionClick();
      } catch (hapticError) {
        if (kDebugMode) {
          print('SoundService: Haptic feedback also failed: $hapticError');
        }
      }
    }
  }

  Future<void> playBackgroundMusic([String? categoryName]) async {
    // Ensure initialization
    await ensureInitialized();

    if (!_musicEnabled) {
      if (kDebugMode) {
        print('SoundService: Music disabled, skipping background music');
      }
      return;
    }

    // Get the appropriate music file based on category
    String? musicFile = _getMusicFileForCategory(categoryName?.toLowerCase());

    if (musicFile == null) {
      if (kDebugMode) {
        print('SoundService: No background music for category: $categoryName');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print(
          'SoundService: Playing background music for $categoryName: $musicFile',
        );
      }
      await _backgroundMusicPlayer.stop(); // Stop any previous music
      await _backgroundMusicPlayer.play(AssetSource(musicFile));
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(
        0.3,
      ); // Lower volume for background
      if (kDebugMode) {
        print('SoundService: Background music started successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SoundService: Failed to play background music: $e');
      }
      // Music failed to load, continue without background music
    }
  }

  // Get the appropriate music file for each category
  String? _getMusicFileForCategory(String? categoryName) {
    switch (categoryName) {
      case 'extreme':
      case 'hard':
        return 'sounds/Two Feet - Love is a Bitch.mp3';
      case 'romantic':
        return 'sounds/Elvis Presley - Can\'t Help Falling In Love (Official Audio).mp3';
      case 'soft':
        return 'sounds/7 Seconds.mp3';
      case 'hot':
        return 'sounds/Michele Morrone - Feel It (from 365 days movie).mp3';
      default:
        return null; // No background music for other categories
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

  // Test method to verify sound files can be loaded
  Future<void> testSounds() async {
    if (kDebugMode) print('SoundService: Testing sound files...');

    final List<String> soundFiles = [
      'sounds/pop.mp3',
      'sounds/roulette.mp3',
      'sounds/success.mp3',
      'sounds/Two Feet - Love is a Bitch.mp3',
      'sounds/Elvis Presley - Can\'t Help Falling In Love (Official Audio).mp3',
      'sounds/7 Seconds.mp3',
      'sounds/Michele Morrone - Feel It (from 365 days movie).mp3',
    ];

    for (String soundFile in soundFiles) {
      try {
        final testPlayer = AudioPlayer();
        await testPlayer.setPlayerMode(PlayerMode.lowLatency);
        await testPlayer.play(AssetSource(soundFile));
        await testPlayer.stop();
        await testPlayer.dispose();
        if (kDebugMode) print('SoundService: ✓ $soundFile loaded successfully');
      } catch (e) {
        if (kDebugMode) print('SoundService: ✗ Failed to load $soundFile: $e');
      }
    }
  }

  void dispose() {
    _spinPlayer.dispose();
    _resultPlayer.dispose();
    _clickPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}
