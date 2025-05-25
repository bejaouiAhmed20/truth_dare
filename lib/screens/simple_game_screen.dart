import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/challenge.dart';
import '../models/db_category.dart';
import '../services/custom_question_service.dart';
import '../services/supabase_service.dart';

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class SimpleGameScreen extends StatefulWidget {
  final Category? selectedCategory;

  const SimpleGameScreen({super.key, this.selectedCategory});

  @override
  State<SimpleGameScreen> createState() => _SimpleGameScreenState();
}

class _SimpleGameScreenState extends State<SimpleGameScreen> {
  // Current player index (0 for Ahmed, 1 for Maram)
  int _currentPlayerIndex = 0;

  // Current challenge type (truth or dare)
  String _challengeType = 'truth';

  // Current challenge text
  String? _challengeText;

  // Loading state
  bool _isLoading = false;

  // Settings
  bool _showTruth = true;
  bool _showDare = true;

  // Services
  final CustomQuestionService _customQuestionService = CustomQuestionService();
  final SupabaseService _supabaseService = SupabaseService();

  // Player data
  final List<Map<String, dynamic>> _players = [
    {'name': 'Ahmed', 'gender': 'male', 'imagePath': 'assets/ahmed.jpg'},
    {'name': 'Maram', 'gender': 'female', 'imagePath': 'assets/maram.jpg'},
  ];

  // Error message
  String? _errorMessage;

  // Connection status
  bool _isConnectedToSupabase = false;

  // Sample challenges
  final Map<String, List<String>> _truthChallenges = {
    'male': [
      'What is your biggest fear?',
      'What is your most embarrassing moment?',
      'What is your biggest secret?',
      'What is the most daring thing you\'ve ever done?',
      'What is your biggest regret?',
      'If you could change one thing about yourself, what would it be?',
      'What is the most childish thing you still do?',
      'What is your biggest pet peeve?',
      'What is the worst gift you have ever received?',
      'What is the strangest dream you\'ve ever had?',
      'What is your most used emoji?',
      'What was the last lie you told?',
      'What is the most trouble you\'ve ever been in?',
      'What is the weirdest thought you\'ve ever had?',
      'What is the worst advice you\'ve ever given?',
    ],
    'female': [
      'What is your biggest dream?',
      'What is your favorite memory?',
      'What is something you\'ve never told anyone?',
      'What is the craziest thing you\'ve ever done?',
      'What is your biggest accomplishment?',
      'What is your favorite thing about yourself?',
      'What is the most spontaneous thing you\'ve ever done?',
      'What is your favorite childhood memory?',
      'What is the most embarrassing thing in your room?',
      'What is the last thing you searched for on your phone?',
      'What is your guilty pleasure?',
      'What is the worst fashion trend you\'ve ever participated in?',
      'What is the most embarrassing thing you\'ve done in front of a crowd?',
      'What is the silliest thing you\'ve ever done because someone dared you to?',
      'What is the most embarrassing thing you\'ve said to someone?',
    ],
  };

  final Map<String, List<String>> _dareChallenges = {
    'male': [
      'Do 10 push-ups right now',
      'Sing your favorite song',
      'Dance for 30 seconds',
      'Tell a joke',
      'Make a funny face and hold it for 10 seconds',
      'Imitate a celebrity',
      'Speak in an accent for the next 2 minutes',
      'Do your best animal impression',
      'Try to lick your elbow',
      'Do a handstand against the wall',
      'Hop on one foot for 30 seconds',
      'Do your best robot dance',
      'Pretend to be a news reporter for 1 minute',
      'Make up a rap about the person to your right',
      'Do 5 jumping jacks',
    ],
    'female': [
      'Do a twirl',
      'Recite a poem',
      'Do your best impression of someone',
      'Make up a short story',
      'Strike a model pose and hold it for 10 seconds',
      'Do your best catwalk',
      'Sing the chorus of your favorite song',
      'Do a silly dance',
      'Make a funny face and take a selfie',
      'Speak in a whisper for the next 2 minutes',
      'Do your best impression of a cartoon character',
      'Try to juggle with 3 items',
      'Balance a book on your head and walk across the room',
      'Draw something with your eyes closed',
      'Do your best ballet move',
    ],
  };

  @override
  void initState() {
    super.initState();
    // Check Supabase connection
    _checkSupabaseConnection();
    // Load settings and get the first challenge
    _loadSettings().then((_) async {
      await _getRandomChallenge();
    });
  }

  // Check Supabase connection
  Future<void> _checkSupabaseConnection() async {
    try {
      // Try to fetch a simple query to check connection
      await _supabaseService.getCategoryIdByName('Soft');
      setState(() {
        _isConnectedToSupabase = true;
      });
      debugPrint('Successfully connected to Supabase');
    } catch (e) {
      setState(() {
        _isConnectedToSupabase = false;
      });
      debugPrint('Failed to connect to Supabase: $e');
    }
  }

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _showTruth = prefs.getBool('show_truth') ?? true;
        _showDare = prefs.getBool('show_dare') ?? true;

        // If current challenge type is disabled, switch to the other one
        if (_challengeType == 'truth' && !_showTruth) {
          _challengeType = 'dare';
        } else if (_challengeType == 'dare' && !_showDare) {
          _challengeType = 'truth';
        }
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Get current player
  Map<String, dynamic> get _currentPlayer => _players[_currentPlayerIndex];

  // Get random challenge based on player gender and challenge type
  Future<void> _getRandomChallenge() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Get player gender
    final gender = _currentPlayer['gender'];

    // Check if we need to switch challenge type based on settings
    if (_challengeType == 'truth' && !_showTruth) {
      _challengeType = 'dare';
    } else if (_challengeType == 'dare' && !_showDare) {
      _challengeType = 'truth';
    }

    try {
      // Get challenge from Supabase if connected
      final categoryName = widget.selectedCategory?.name ?? 'Soft';

      Challenge? challenge;

      // Only try to get a challenge from Supabase if we're connected
      if (_isConnectedToSupabase) {
        debugPrint('Fetching challenge from Supabase...');
        try {
          challenge = await _supabaseService.getRandomChallenge(
            categoryId: categoryName, // Use the category name instead of ID
            type: _challengeType,
            gender: gender == 'male' ? 'male' : 'female',
          );
          debugPrint('Supabase challenge: ${challenge?.content}');
        } catch (e) {
          debugPrint('Error fetching from Supabase: $e');
          // If we fail here, set connection status to false for future attempts
          setState(() {
            _isConnectedToSupabase = false;
          });
        }
      } else {
        debugPrint('Not connected to Supabase, skipping remote fetch');
      }

      // If we got a challenge from Supabase, use it
      if (challenge != null) {
        final content = challenge.content;
        setState(() {
          _challengeText = content;
          _isLoading = false;
        });
        return;
      }

      // If no challenge from Supabase, try custom questions
      final customQuestions = await _customQuestionService
          .getQuestionsByTypeAndCategory(
            type: _challengeType,
            category: categoryName,
            gender: gender,
          );

      if (customQuestions.isNotEmpty) {
        // Shuffle and pick a random custom question
        customQuestions.shuffle();
        setState(() {
          _challengeText = customQuestions.first.text;
          _isLoading = false;
        });
        return;
      }

      // If no custom questions, fall back to default challenges
      final defaultChallenges =
          _challengeType == 'truth'
              ? _truthChallenges[gender]!
              : _dareChallenges[gender]!;

      // Shuffle the challenges for better randomization
      defaultChallenges.shuffle(Random());

      setState(() {
        _challengeText = defaultChallenges.first;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching challenge: $e');

      // Show error message
      setState(() {
        _errorMessage = 'Failed to fetch challenge. Please try again.';
      });

      // Fallback to default challenges if there's an error
      final defaultChallenges =
          _challengeType == 'truth'
              ? _truthChallenges[gender]!
              : _dareChallenges[gender]!;

      // Shuffle the challenges for better randomization
      defaultChallenges.shuffle(Random());

      setState(() {
        _challengeText = defaultChallenges.first;
        _isLoading = false;
      });
    }
  }

  // Switch to next player
  void _nextPlayer() {
    setState(() {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      _challengeText = null;
    });

    // Get new challenge for next player
    _getRandomChallenge();
  }

  // Set challenge type
  void _setChallengeType(String type) {
    // Check if the selected type is enabled
    if ((type == 'truth' && !_showTruth) || (type == 'dare' && !_showDare)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${type[0].toUpperCase()}${type.substring(1)} questions are disabled in settings',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _challengeType = type;
      _challengeText = null;
    });

    // Get new challenge with new type
    _getRandomChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.selectedCategory != null
                  ? widget.selectedCategory!.color
                  : (_challengeType == 'truth' ? Colors.blue : Colors.orange),
              widget.selectedCategory != null
                  ? widget.selectedCategory!.color.withAlpha(200)
                  : (_challengeType == 'truth'
                      ? Colors.blue.shade800
                      : Colors.deepOrange),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      widget.selectedCategory != null
                          ? '${widget.selectedCategory!.name} Category'
                          : 'Truth or Dare',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _getRandomChallenge,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Player Image
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      _currentPlayer['imagePath'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Player Name
                Text(
                  _currentPlayer['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                // Player Turn Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'It\'s your turn!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Challenge Type Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeButton('Truth', 'truth'),
                    const SizedBox(width: 20),
                    _buildTypeButton('Dare', 'dare'),
                  ],
                ),

                const SizedBox(height: 30),

                // Challenge Card
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _errorMessage != null
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _errorMessage!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _getRandomChallenge,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade100,
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _challengeType.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.selectedCategory != null
                                            ? widget.selectedCategory!.color
                                            : (_challengeType == 'truth'
                                                ? Colors.blue
                                                : Colors.orange),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        _challengeText ?? 'Loading...',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16, // Smaller font size
                                          fontWeight: FontWeight.w500,
                                          height: 1.4, // Better line height
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                // Next Player Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _nextPlayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          widget.selectedCategory != null
                              ? widget.selectedCategory!.color
                              : (_challengeType == 'truth'
                                  ? Colors.blue
                                  : Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Next Player',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  // Build challenge type button
  Widget _buildTypeButton(String label, String type) {
    final isSelected = _challengeType == type;
    final color = type == 'truth' ? Colors.blue : Colors.orange;

    return GestureDetector(
      onTap: () => _setChallengeType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withAlpha(75),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? color : Colors.white,
          ),
        ),
      ),
    );
  }
}
