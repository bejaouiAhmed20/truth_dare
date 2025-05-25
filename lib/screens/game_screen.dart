import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../models/models.dart';
import '../utils/player_utils.dart';
import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isLoading = false;
  bool _showChallenge = false;
  bool _showChoiceButtons = true;

  @override
  void initState() {
    super.initState();
    // Delay to ensure the widget is fully built before getting the next player
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
      // Preload player images to ensure they're available
      PlayerUtils.preloadPlayerImages(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is a good place to ensure we have player data
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (gameProvider.players.isEmpty) {
      // Use addPostFrameCallback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeGame();
      });
    }
  }

  Future<void> _initializeGame() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Make sure we have players
    if (gameProvider.players.isEmpty) {
      // Create players with fixed IDs to ensure consistent identification
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

      // Log the players for debugging
      debugPrint('Added default players: ${gameProvider.players.length}');
      for (final player in gameProvider.players) {
        debugPrint('Player: ${player.id}, ${player.name}, ${player.imagePath}');
      }
    }

    // Make sure we have a current player
    if (gameProvider.currentPlayer == null && gameProvider.players.isNotEmpty) {
      gameProvider.getNextPlayer();
      debugPrint('Set current player: ${gameProvider.currentPlayer?.name}');
    }

    // Make sure we have a category selected
    if (gameProvider.selectedCategoryIds.isEmpty &&
        gameProvider.categories.isNotEmpty) {
      // Select the first category by default
      gameProvider.updateSettings(
        selectedCategoryIds: [gameProvider.categories.first.id],
      );
    }

    // Now get the next player
    _getNextPlayer();
  }

  void _getNextPlayer() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Make sure we have players
    if (gameProvider.players.isEmpty) {
      _initializeGame();
      return;
    }

    // Get the next player
    gameProvider.getNextPlayer();

    // Ensure we have a current player
    if (gameProvider.currentPlayer == null) {
      debugPrint("Warning: Current player is null after getNextPlayer()");
      // Force set a player if needed
      if (gameProvider.players.isNotEmpty) {
        // This is a fallback in case getNextPlayer() didn't set a player
        gameProvider.updateSettings(); // Just to trigger a notification
      }
      return;
    }

    // Check if we should skip the choice screen
    final bool truthEnabled = gameProvider.truthsEnabled;
    final bool dareEnabled = gameProvider.daresEnabled;

    // If only one type is enabled, automatically get that type of challenge
    if (truthEnabled && !dareEnabled) {
      _getNextChallenge(type: 'truth');
    } else if (!truthEnabled && dareEnabled) {
      _getNextChallenge(type: 'dare');
    } else {
      // Both or neither are enabled, show choice buttons
      setState(() {
        _showChallenge = false;
        _showChoiceButtons = true;
      });
    }
  }

  Future<void> _getNextChallenge({String? type}) async {
    setState(() {
      _isLoading = true;
      _showChallenge = false;
      _showChoiceButtons = false;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await gameProvider.getNextChallenge(specificType: type);

      // Add a small delay for animation effect
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        setState(() {
          _showChallenge = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get challenge: $e')));

        // Show choice buttons again if there was an error
        setState(() {
          _showChoiceButtons = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final currentPlayer = gameProvider.currentPlayer;
          final currentChallenge = gameProvider.currentChallenge;

          // Ensure we have a current player
          if (currentPlayer == null && gameProvider.players.isNotEmpty) {
            // If no current player is set but we have players, set the first one
            WidgetsBinding.instance.addPostFrameCallback((_) {
              gameProvider.getNextPlayer();
            });
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getChallengeColor(
                    currentChallenge?.type,
                  ).withAlpha(179), // 0.7 opacity
                  _getChallengeColor(
                    currentChallenge?.type,
                  ).withAlpha(77), // 0.3 opacity
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(40),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _showExitDialog,
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 22,
                            ),
                            color: Colors.white,
                            tooltip: 'Exit Game',
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Truth or Dare',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _showSettingsDialog,
                            icon: const Icon(Icons.settings, size: 22),
                            color: Colors.white,
                            tooltip: 'Game Settings',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Current Player
                    if (currentPlayer != null)
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: PlayerUtils.getPlayerImageWidget(
                                  currentPlayer,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isMarouma(currentPlayer))
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red.shade400,
                                    size: 20,
                                  ),
                                if (_isMarouma(currentPlayer))
                                  const SizedBox(width: 8),
                                Text(
                                  _getPlayerName(currentPlayer),
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(100),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isMarouma(currentPlayer))
                                  const SizedBox(width: 8),
                                if (_isMarouma(currentPlayer))
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red.shade400,
                                    size: 20,
                                  ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(100),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'It\'s your turn!',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Challenge Card or Choice Buttons
                    Expanded(
                      child: Center(
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : currentChallenge == null
                                ? _showChoiceButtons
                                    ? _buildChoiceButtons()
                                    : _buildNoChallengeCard()
                                : _buildChallengeCard(currentChallenge),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    if (!_isLoading && currentChallenge != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            // Skip Button
                            Expanded(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(20),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _skipChallenge,
                                  icon: const Icon(Icons.skip_next, size: 22),
                                  label: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withAlpha(
                                      150,
                                    ),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Complete Button
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getChallengeColor(
                                        currentChallenge.type,
                                      ).withAlpha(50),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _completeChallenge,
                                  icon: const Icon(
                                    Icons.check_circle,
                                    size: 22,
                                  ),
                                  label: const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: _getChallengeColor(
                                      currentChallenge.type,
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
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
        },
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final challengeColor = _getChallengeColor(challenge.type);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final currentPlayer = gameProvider.currentPlayer;

    // Ensure we have a current player
    if (currentPlayer == null && gameProvider.players.isNotEmpty) {
      // If we're building a challenge card but don't have a current player, use the first player
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameProvider.getNextPlayer();
      });
    }

    return AnimatedOpacity(
      opacity: _showChallenge ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: challengeColor.withAlpha(40),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, challengeColor.withAlpha(15)],
              ),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Player Info at the top of the card - Always show player info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: challengeColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: PlayerUtils.getPlayerImageWidget(
                          currentPlayer,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentPlayer != null && _isMarouma(currentPlayer))
                          Icon(
                            Icons.favorite,
                            color: Colors.red.shade400,
                            size: 16,
                          ),
                        if (currentPlayer != null && _isMarouma(currentPlayer))
                          const SizedBox(width: 4),
                        Text(
                          _getPlayerName(currentPlayer),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: challengeColor,
                          ),
                        ),
                        if (currentPlayer != null && _isMarouma(currentPlayer))
                          const SizedBox(width: 4),
                        if (currentPlayer != null && _isMarouma(currentPlayer))
                          Icon(
                            Icons.favorite,
                            color: Colors.red.shade400,
                            size: 16,
                          ),
                      ],
                    ),
                  ],
                ).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),

                // Challenge Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: challengeColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: challengeColor.withAlpha(100),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        challenge.type == 'truth'
                            ? Icons.question_answer
                            : Icons.local_fire_department,
                        color: challengeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        challenge.type.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: challengeColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 30),

                // Challenge Content
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Text(
                      challenge.content,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ).animate().fade(duration: 800.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 30),

                // Challenge Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (challenge.forGender != null &&
                        challenge.forGender != 'any')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  challenge.forGender == 'male'
                                      ? 'assets/ahmed.jpg'
                                      : 'assets/maram.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: Colors.grey.shade700,
                                      size: 12,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              challenge.forGender == 'male'
                                  ? 'For Bouhmid'
                                  : 'For Marouma',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (challenge.coupleOnly)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.pink.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 18,
                                color: Colors.pink.shade400,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Couples',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.pink.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ).animate().fade(duration: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoChallengeCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.orange.withAlpha(15)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Challenges Available',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please select different categories or create custom challenges.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withAlpha(50),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _showSettingsDialog,
                  icon: const Icon(Icons.settings),
                  label: const Text(
                    'Game Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChallengeColor(String? type) {
    if (type == 'truth') {
      return Colors.blue;
    } else if (type == 'dare') {
      return Colors.deepOrange;
    } else {
      return Colors.purple;
    }
  }

  // Use the utility class methods
  String _getPlayerName(Player? player) => PlayerUtils.getPlayerName(player);
  bool _isMarouma(Player? player) => PlayerUtils.isMarouma(player);

  Widget _buildChoiceButtons() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final bool truthEnabled = gameProvider.truthsEnabled;
    final bool dareEnabled = gameProvider.daresEnabled;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Player info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purple.shade300,
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
                      borderRadius: BorderRadius.circular(20),
                      child: PlayerUtils.getPlayerImageWidget(
                        gameProvider.currentPlayer,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _getPlayerName(gameProvider.currentPlayer),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ],
              ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              Text(
                'Choose Your Challenge',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ).animate().fade(duration: 700.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 4),

              Text(
                'What will it be?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ).animate().fade(duration: 800.ms),

              const SizedBox(height: 16),

              // Truth Button
              _buildChoiceButton(
                label: 'TRUTH',
                icon: Icons.question_answer,
                color: Colors.blue,
                onPressed:
                    truthEnabled
                        ? () => _getNextChallenge(type: 'truth')
                        : null,
                description: 'Answer honestly',
                height: 60,
                fontSize: 16,
                descriptionSize: 12,
                iconSize: 22,
              ).animate().fade(duration: 900.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 10),

              // Dare Button
              _buildChoiceButton(
                label: 'DARE',
                icon: Icons.local_fire_department,
                color: Colors.deepOrange,
                onPressed:
                    dareEnabled ? () => _getNextChallenge(type: 'dare') : null,
                description: 'Complete a challenge',
                height: 60,
                fontSize: 16,
                descriptionSize: 12,
                iconSize: 22,
              ).animate().fade(duration: 1100.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 10),

              // Random Button - Only show if both truth and dare are enabled
              if (truthEnabled && dareEnabled)
                _buildChoiceButton(
                  label: 'RANDOM',
                  icon: Icons.shuffle,
                  color: Colors.purple,
                  onPressed: () => _getNextChallenge(),
                  description: 'Surprise me',
                  height: 60,
                  fontSize: 16,
                  descriptionSize: 12,
                  iconSize: 22,
                ).animate().fade(duration: 1300.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String description,
    double height = 70,
    double fontSize = 18,
    double descriptionSize = 13,
    double iconSize = 24,
  }) {
    final isEnabled = onPressed != null;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            isEnabled
                ? [
                  BoxShadow(
                    color: color.withAlpha(40),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: isEnabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: iconSize * 1.8,
                  height: iconSize * 1.8,
                  decoration: BoxDecoration(
                    color:
                        isEnabled ? color.withAlpha(30) : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isEnabled ? color : Colors.grey,
                    size: iconSize,
                  ),
                ),

                const SizedBox(width: 12),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: isEnabled ? color : Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: descriptionSize,
                          color: isEnabled ? Colors.black54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: isEnabled ? color : Colors.grey.shade400,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeChallenge() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await gameProvider.completeChallenge();

      // Add a small delay for better user experience
      await Future.delayed(const Duration(milliseconds: 500));

      // Get the next challenge directly instead of going through _getNextPlayer
      // This ensures we always get a new challenge
      String? challengeType =
          gameProvider.truthsEnabled && gameProvider.daresEnabled
              ? null // Random type if both are enabled
              : gameProvider.truthsEnabled
              ? 'truth'
              : 'dare';

      await _getNextChallenge(type: challengeType);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete challenge: $e')),
        );

        // If there was an error, still try to get the next player
        _getNextPlayer();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skipChallenge() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await gameProvider.skipChallenge();

      // Add a small delay for better user experience
      await Future.delayed(const Duration(milliseconds: 500));

      // Get the next challenge directly instead of going through _getNextPlayer
      // This ensures we always get a new challenge
      String? challengeType =
          gameProvider.truthsEnabled && gameProvider.daresEnabled
              ? null // Random type if both are enabled
              : gameProvider.truthsEnabled
              ? 'truth'
              : 'dare';

      await _getNextChallenge(type: challengeType);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to skip challenge: $e')));

        // If there was an error, still try to get the next player
        _getNextPlayer();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSettingsDialog() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Game Settings',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Include Custom Challenges'),
                  value: gameProvider.includeCustomChallenges,
                  onChanged: (value) {
                    gameProvider.updateSettings(includeCustomChallenges: value);
                    Navigator.of(context).pop();
                    _showSettingsDialog();
                  },
                ),
                SwitchListTile(
                  title: const Text('Truth Questions'),
                  value: gameProvider.truthsEnabled,
                  onChanged: (value) {
                    gameProvider.updateSettings(truthsEnabled: value);
                    Navigator.of(context).pop();
                    _showSettingsDialog();
                  },
                ),
                SwitchListTile(
                  title: const Text('Dare Challenges'),
                  value: gameProvider.daresEnabled,
                  onChanged: (value) {
                    gameProvider.updateSettings(daresEnabled: value);
                    Navigator.of(context).pop();
                    _showSettingsDialog();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showExitDialog() {
    // Store context before async gap
    final dialogContext = context;

    showDialog(
      context: dialogContext,
      builder:
          (context) => AlertDialog(
            title: Text(
              'End Game',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to end the current game?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _endGame();
                },
                child: const Text('End Game'),
              ),
            ],
          ),
    );
  }

  Future<void> _endGame() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await gameProvider.endGameSession();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to end game: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }
}
