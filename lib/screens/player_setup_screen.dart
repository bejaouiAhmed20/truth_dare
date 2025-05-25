import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_provider.dart';
import '../utils/player_utils.dart';
import 'category_selection_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _player1NameController = TextEditingController(text: 'Bouhmid');
  final _player2NameController = TextEditingController(text: 'Marouma');
  String _player1Gender = 'male';
  String _player2Gender = 'female';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load saved player names if available
    _loadSavedPlayerNames();

    // Preload player images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  @override
  void dispose() {
    _player1NameController.dispose();
    _player2NameController.dispose();
    super.dispose();
  }

  Future<void> _preloadImages() async {
    try {
      if (mounted) {
        await precacheImage(const AssetImage('assets/ahmed.jpg'), context);
      }

      if (mounted) {
        await precacheImage(const AssetImage('assets/maram.jpg'), context);
      }
    } catch (e) {
      debugPrint('Error preloading player images: $e');
    }
  }

  Future<void> _loadSavedPlayerNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final player1Name = prefs.getString('player1_name');
      final player2Name = prefs.getString('player2_name');

      if (player1Name != null && player1Name.isNotEmpty) {
        setState(() {
          _player1NameController.text = player1Name;
        });
      }

      if (player2Name != null && player2Name.isNotEmpty) {
        setState(() {
          _player2NameController.text = player2Name;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved player names: $e');
    }
  }

  Future<void> _savePlayerNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('player1_name', _player1NameController.text);
      await prefs.setString('player2_name', _player2NameController.text);
    } catch (e) {
      debugPrint('Error saving player names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Player Setup',
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Players',
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
                        'Customize your player names',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Player 1
                    _buildPlayerCard(
                      context,
                      'Player 1',
                      _player1NameController,
                      _player1Gender,
                      (value) => setState(() => _player1Gender = value),
                    ),

                    const SizedBox(height: 24),

                    // Player 2
                    _buildPlayerCard(
                      context,
                      'Player 2',
                      _player2NameController,
                      _player2Gender,
                      (value) => setState(() => _player2Gender = value),
                    ),

                    const SizedBox(height: 32),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _continueToCategories,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: Colors.purple.shade300,
                        ),
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
                                    Text(
                                      'Continue',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    String title,
    TextEditingController controller,
    String gender,
    Function(String) onGenderChanged,
  ) {
    final bool isPlayer1 = title == 'Player 1';
    final String imagePath =
        isPlayer1 ? 'assets/ahmed.jpg' : 'assets/maram.jpg';
    final bool isMarouma = !isPlayer1;
    final Color genderColor = isPlayer1 ? Colors.blue : Colors.pink;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player header with image
            Row(
              children: [
                // Player image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: genderColor.withAlpha(150),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
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
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Player title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isMarouma ? Icons.favorite : Icons.person,
                          color: isMarouma ? Colors.red : Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isMarouma ? 'Your Love' : 'Male Player',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon:
                    isMarouma
                        ? Icon(Icons.favorite, color: Colors.red.shade300)
                        : const Icon(Icons.person),
                suffixIcon:
                    isMarouma
                        ? Icon(Icons.favorite, color: Colors.red.shade300)
                        : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Gender Selection
            Text(
              'Gender',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption(
                    context,
                    'Male',
                    'male',
                    gender,
                    onGenderChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGenderOption(
                    context,
                    'Female',
                    'female',
                    gender,
                    onGenderChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String label,
    String value,
    String groupValue,
    Function(String) onChanged,
  ) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple.shade700 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'male' ? Icons.male : Icons.female,
              color: isSelected ? Colors.purple.shade700 : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color:
                    isSelected ? Colors.purple.shade700 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continueToCategories() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final gameProvider = Provider.of<GameProvider>(context, listen: false);

      try {
        // Save player names to shared preferences
        await _savePlayerNames();

        // Add players to the game with their fixed images and IDs
        await gameProvider.addPlayer(
          _player1NameController.text,
          _player1Gender,
          imagePath: 'assets/ahmed.jpg',
          playerId: 'player_bouhmid',
        );

        await gameProvider.addPlayer(
          _player2NameController.text,
          _player2Gender,
          imagePath: 'assets/maram.jpg',
          playerId: 'player_marouma',
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
          // Show error dialog
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
}
