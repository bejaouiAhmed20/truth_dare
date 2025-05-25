import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import 'add_challenge_screen.dart';
import 'category_selection_screen.dart';
import 'emotions_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8E2DE2), // Vibrant purple
              Color(0xFF4A00E0), // Deep blue/purple
              Color(0xFFD81B60), // Pink
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(40),
                      Colors.white.withAlpha(10),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withAlpha(15),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(40),
                      Colors.white.withAlpha(10),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withAlpha(15),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            // Additional decorative elements
            Positioned(
              top: 150,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(30),
                      Colors.white.withAlpha(5),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(30),
                      Colors.white.withAlpha(5),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Game Logo
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withAlpha(80),
                                Colors.white.withAlpha(30),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.white.withAlpha(30),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 85,
                                  color: Color(0xFFFF4081).withAlpha(230),
                                ),
                                Icon(
                                  Icons.favorite,
                                  size: 65,
                                  color: Colors.white.withAlpha(230),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fade(duration: 600.ms).scale(),

                        const SizedBox(height: 30),

                        // Game Title
                        ShaderMask(
                              shaderCallback:
                                  (bounds) => LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFFF48FB1), // Light pink
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                              child: Column(
                                children: [
                                  Text(
                                    'Bouhmid & Marouma',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Truth or Dare',
                                    style: GoogleFonts.poppins(
                                      fontSize: 44,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fade(duration: 800.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 8),

                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF4081).withAlpha(180), // Pink
                                    Color(0xFF9C27B0).withAlpha(180), // Purple
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Special Edition',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.favorite,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fade(duration: 1000.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 50),

                        // Start Game Button
                        _buildButton(
                              context,
                              'Play Truth or Dare',
                              Icons.play_circle_filled_rounded,
                              () => _startGame(context),
                              const LinearGradient(
                                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            )
                            .animate()
                            .fade(duration: 1200.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 20),

                        // Add Challenge Button
                        _buildButton(
                              context,
                              'Add Custom Challenge',
                              Icons.add_reaction_rounded,
                              () => _navigateToAddChallenge(context),
                              const LinearGradient(
                                colors: [Color(0xFFFF4081), Color(0xFFF50057)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            )
                            .animate()
                            .fade(duration: 1300.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 20),

                        // Emotions Button
                        _buildButton(
                              context,
                              '💝 Share Your Emotions',
                              Icons.emoji_emotions_rounded,
                              () => _navigateToEmotions(context),
                              const LinearGradient(
                                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            )
                            .animate()
                            .fade(duration: 1350.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 20),

                        // Test Sound Button (Debug only)
                        if (kDebugMode) ...[
                          _buildButton(
                                context,
                                'Test Sounds',
                                Icons.volume_up,
                                () => _testSounds(context),
                                const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9800),
                                    Color(0xFFFF5722),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              )
                              .animate()
                              .fade(duration: 1350.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                        ],

                        // Settings Button
                        _buildButton(
                              context,
                              'Game Settings',
                              Icons.settings_rounded,
                              () => _showSettingsDialog(context),
                              const LinearGradient(
                                colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            )
                            .animate()
                            .fade(duration: 1400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, [
    Gradient? customGradient,
  ]) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (kDebugMode)
            print('HomeScreen: Button pressed, playing click sound');
          SoundService().playClickSound();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:
                customGradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withAlpha(80),
                    Colors.white.withAlpha(30),
                  ],
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(30),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(60),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withAlpha(180),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
    );

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);

      // Ensure we have the default players
      if (gameProvider.players.isEmpty) {
        // Create players with fixed IDs
        await gameProvider.addPlayer(
          'Bouhmid',
          'male',
          imagePath: 'assets/ahmed.jpg',
          playerId: 'player_bouhmid',
        );

        await gameProvider.addPlayer(
          'Marouma',
          'female',
          imagePath: 'assets/maram.jpg',
          playerId: 'player_marouma',
        );
      }

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Navigate directly to category selection
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategorySelectionScreen(),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to set up game: $e')));
      }
    }
  }

  void _navigateToAddChallenge(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddChallengeScreen()));
  }

  void _navigateToEmotions(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EmotionsScreen()));
  }

  void _testSounds(BuildContext context) async {
    final soundService = SoundService();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            title: Text('Testing Sounds'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Testing audio files...'),
              ],
            ),
          ),
    );

    // Test all sounds
    await soundService.testSounds();

    // Test individual sounds with delay
    await Future.delayed(const Duration(milliseconds: 500));
    await soundService.playClickSound();

    await Future.delayed(const Duration(milliseconds: 500));
    await soundService.playResultSound();

    await Future.delayed(const Duration(milliseconds: 500));
    await soundService.playSpinSound();

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();

      // Show result
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sound test completed! Check console for details.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final soundService = SoundService();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(
                    'Game Settings',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sound Effects Control
                      SwitchListTile(
                        title: Row(
                          children: [
                            Icon(Icons.volume_up, size: 20),
                            SizedBox(width: 8),
                            Text('Sound Effects'),
                          ],
                        ),
                        subtitle: Text('Button clicks and game sounds'),
                        value: soundService.soundEnabled,
                        onChanged: (value) {
                          soundService.playClickSound();
                          setState(() {
                            soundService.setSoundEnabled(value);
                          });
                        },
                      ),

                      // Background Music Control
                      SwitchListTile(
                        title: Row(
                          children: [
                            Icon(Icons.music_note, size: 20),
                            SizedBox(width: 8),
                            Text('Background Music'),
                          ],
                        ),
                        subtitle: Text('Music for extreme/hard categories'),
                        value: soundService.musicEnabled,
                        onChanged: (value) {
                          soundService.playClickSound();
                          setState(() {
                            soundService.setMusicEnabled(value);
                          });
                        },
                      ),

                      Divider(),

                      // Game Settings
                      SwitchListTile(
                        title: const Text('Include Custom Challenges'),
                        value: gameProvider.includeCustomChallenges,
                        onChanged: (value) {
                          soundService.playClickSound();
                          gameProvider.updateSettings(
                            includeCustomChallenges: value,
                          );
                          Navigator.of(context).pop();
                          _showSettingsDialog(context);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Truth Questions'),
                        value: gameProvider.truthsEnabled,
                        onChanged: (value) {
                          soundService.playClickSound();
                          gameProvider.updateSettings(truthsEnabled: value);
                          Navigator.of(context).pop();
                          _showSettingsDialog(context);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Dare Challenges'),
                        value: gameProvider.daresEnabled,
                        onChanged: (value) {
                          soundService.playClickSound();
                          gameProvider.updateSettings(daresEnabled: value);
                          Navigator.of(context).pop();
                          _showSettingsDialog(context);
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        soundService.playClickSound();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
          ),
    );
  }
}
