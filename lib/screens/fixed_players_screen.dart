import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../utils/player_utils.dart';
import 'category_selection_screen.dart';

class FixedPlayersScreen extends StatefulWidget {
  const FixedPlayersScreen({super.key});

  @override
  State<FixedPlayersScreen> createState() => _FixedPlayersScreenState();
}

class _FixedPlayersScreenState extends State<FixedPlayersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Preload images when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  Future<void> _preloadImages() async {
    try {
      // Preload first image
      if (mounted) {
        await precacheImage(const AssetImage('assets/ahmed.jpg'), context);
      }

      // Check mounted again before second operation
      if (mounted) {
        await precacheImage(const AssetImage('assets/maram.jpg'), context);
      }
    } catch (e) {
      debugPrint('Error preloading player images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Players',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9C27B0), // Purple
              Color(0xFFD81B60), // Pink
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Decorative element
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(30),
                    ),
                  ),
                ),

                Text(
                  'Meet the Players',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Get ready for a fun game!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Player Cards
                Expanded(
                  child: Row(
                    children: [
                      // Ahmed Card
                      Expanded(
                        child: _buildPlayerCard(
                          'Bouhmid',
                          'Male',
                          'assets/ahmed.jpg',
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Maram Card
                      Expanded(
                        child: _buildPlayerCard(
                          'Marouma',
                          'Female',
                          'assets/maram.jpg',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Continue Button
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continueToCategories,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(60),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      disabledBackgroundColor: Colors.white.withAlpha(30),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient:
                            _isLoading
                                ? null
                                : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withAlpha(80),
                                    Colors.white.withAlpha(40),
                                  ],
                                ),
                      ),
                      child: Center(
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Continue to Game',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(String name, String gender, String imagePath) {
    final Color genderColor =
        gender.toLowerCase() == 'male'
            ? const Color(0xFF2196F3) // Blue
            : const Color(0xFFE91E63); // Pink

    final bool isMaram = name.toLowerCase() == 'marouma';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.white.withAlpha(240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Player Image with border
              Expanded(
                child: Stack(
                  children: [
                    // Image container
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: genderColor.withAlpha(100),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: genderColor.withAlpha(40),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Error loading player image: $error');
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey.shade700,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Hearts for Maram
                    if (isMaram) ...[
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red.shade400,
                          size: 28,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red.shade300,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red.shade300,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Player Name with gradient
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMaram)
                      Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                        size: 18,
                      ),
                    if (isMaram) const SizedBox(width: 4),
                    Flexible(
                      child: ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [genderColor, genderColor.withAlpha(180)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isMaram) const SizedBox(width: 4),
                    if (isMaram)
                      Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                        size: 18,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Player Gender with pill background
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: genderColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: genderColor.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      gender.toLowerCase() == 'male'
                          ? Icons.male
                          : Icons.favorite,
                      color: isMaram ? Colors.red.shade400 : genderColor,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        isMaram ? "My Love" : gender,
                        style: GoogleFonts.poppins(
                          color: isMaram ? Colors.red.shade400 : genderColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);

      // Add the fixed players to the game
      await gameProvider.addPlayer(
        'Bouhmid',
        'male',
        imagePath: 'assets/ahmed.jpg',
      );
      await gameProvider.addPlayer(
        'Marouma',
        'female',
        imagePath: 'assets/maram.jpg',
      );

      // Navigate to category selection
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategorySelectionScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add players: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
