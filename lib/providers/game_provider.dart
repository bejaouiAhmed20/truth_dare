import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../supabase.dart';
import '../utils/player_utils.dart';

/// Game provider for managing the state of the Truth or Dare game
class GameProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  // Game state
  GameSession? _currentSession;
  final List<Player> _players = [];
  List<GameCategory> _categories = [];
  List<Challenge> _challenges = [];
  List<CustomChallenge> _customChallenges = [];

  // Current game state
  Player? _currentPlayer;
  Challenge? _currentChallenge;
  int _currentPlayerIndex = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  // Game settings
  bool _includeCustomChallenges = true;
  List<String> _selectedCategoryIds = [];
  bool _truthsEnabled = true;
  bool _daresEnabled = true;

  // Getters
  GameSession? get currentSession => _currentSession;
  List<Player> get players => _players;
  List<GameCategory> get categories => _categories;
  List<Challenge> get challenges => _challenges;
  List<CustomChallenge> get customChallenges => _customChallenges;
  Player? get currentPlayer => _currentPlayer;
  Challenge? get currentChallenge => _currentChallenge;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get includeCustomChallenges => _includeCustomChallenges;
  List<String> get selectedCategoryIds => _selectedCategoryIds;
  bool get truthsEnabled => _truthsEnabled;
  bool get daresEnabled => _daresEnabled;

  /// Initialize the game provider
  Future<void> initialize() async {
    try {
      // Load categories first
      await _loadCategories();

      // Clear existing players and create the default players
      _players.clear();
      await _createDefaultPlayers();

      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize game: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load categories from the database
  Future<void> _loadCategories() async {
    try {
      final categoriesData = await _databaseService.getCategories();
      _categories =
          categoriesData.map((data) => GameCategory.fromJson(data)).toList();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: $e');
    }
  }

  // We no longer need to save or load players from local storage
  // since we're using fixed players

  /// Create a new game session
  Future<void> createGameSession(String sessionName) async {
    _setLoading(true);
    try {
      final settings = {
        'include_custom_challenges': _includeCustomChallenges,
        'selected_categories': _selectedCategoryIds,
        'truths_enabled': _truthsEnabled,
        'dares_enabled': _daresEnabled,
      };

      final sessionData = await _databaseService.createGameSession(
        sessionName: sessionName,
        settings: settings,
      );

      _currentSession = GameSession.fromJson(sessionData);

      // Add all players to the session
      for (final player in _players) {
        await _databaseService.addPlayerToSession(
          playerId: player.id,
          sessionId: _currentSession!.id,
        );
      }

      // Load challenges for the selected categories
      await _loadChallenges();

      // Set the first player as current
      if (_players.isNotEmpty) {
        _currentPlayerIndex = 0;
        _currentPlayer = _players[_currentPlayerIndex];
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create game session: $e');
    }
  }

  /// Load challenges for the selected categories
  Future<void> _loadChallenges() async {
    _setLoading(true);
    try {
      _challenges = [];

      for (final categoryId in _selectedCategoryIds) {
        if (_truthsEnabled) {
          final truthsData = await _databaseService.getChallengesByCategory(
            categoryId: categoryId,
            type: 'truth',
          );
          _challenges.addAll(
            truthsData.map((data) => Challenge.fromJson(data)),
          );
        }

        if (_daresEnabled) {
          final daresData = await _databaseService.getChallengesByCategory(
            categoryId: categoryId,
            type: 'dare',
          );
          _challenges.addAll(daresData.map((data) => Challenge.fromJson(data)));
        }
      }

      // Load custom challenges if enabled
      if (_includeCustomChallenges) {
        await _loadCustomChallenges();
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load challenges: $e');
    }
  }

  /// Load custom challenges
  Future<void> _loadCustomChallenges() async {
    try {
      _customChallenges = [];

      for (final player in _players) {
        final customChallengesData = await _databaseService.getCustomChallenges(
          playerId: player.id,
        );

        _customChallenges.addAll(
          customChallengesData.map((data) => CustomChallenge.fromJson(data)),
        );
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load custom challenges: $e');
    }
  }

  /// Add a player to the game
  Future<void> addPlayer(
    String name,
    String gender, {
    String? imagePath,
    String? playerId,
  }) async {
    _setLoading(true);
    try {
      final playerData = await _databaseService.createPlayer(
        name: name,
        gender: gender,
        imagePath: imagePath,
        id: playerId,
      );

      final player = Player.fromJson(playerData);
      _players.add(player);

      // Add player to current session if one exists
      if (_currentSession != null) {
        await _databaseService.addPlayerToSession(
          playerId: player.id,
          sessionId: _currentSession!.id,
        );
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add player: $e');
    }
  }

  /// Get the next challenge
  Future<void> getNextChallenge({String? specificType}) async {
    _setLoading(true);
    try {
      // Move to the next player if not requesting a specific type
      if (specificType == null) {
        _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
        _currentPlayer = _players[_currentPlayerIndex];
      }

      // Make sure we have challenges loaded
      if (_challenges.isEmpty && _selectedCategoryIds.isNotEmpty) {
        await _loadChallenges();
      }

      // If we still don't have challenges and no categories are selected,
      // select the first category and load challenges
      if (_challenges.isEmpty &&
          _categories.isNotEmpty &&
          _selectedCategoryIds.isEmpty) {
        _selectedCategoryIds = [_categories.first.id];
        await _loadChallenges();
      }

      // Get challenges
      final random = Random();
      List<Challenge> allChallenges = [];

      // Filter challenges by type if specified
      if (specificType != null) {
        allChallenges =
            _challenges.where((c) => c.type == specificType).toList();

        // Add custom challenges of the specified type
        if (_includeCustomChallenges) {
          for (final customChallenge in _customChallenges) {
            if (customChallenge.type == specificType) {
              // If we're filtering by category, only include challenges from that category
              if (_selectedCategoryIds.isNotEmpty &&
                  customChallenge.categoryId != null &&
                  !_selectedCategoryIds.contains(customChallenge.categoryId)) {
                continue; // Skip this challenge if it's not in the selected category
              }

              final challenge = Challenge(
                id: customChallenge.id,
                type: customChallenge.type,
                content: customChallenge.content,
                categoryId:
                    customChallenge.categoryId ??
                    '', // Use the category if available
                forGender: customChallenge.forGender,
                coupleOnly: customChallenge.coupleOnly,
                usageCount: 0,
                createdAt: customChallenge.createdAt,
                updatedAt: customChallenge.createdAt,
              );
              allChallenges.add(challenge);
            }
          }
        }
      } else {
        // Get all challenges based on settings
        allChallenges = [..._challenges];

        if (_includeCustomChallenges) {
          // Add custom challenges that match the current settings
          for (final customChallenge in _customChallenges) {
            if ((_truthsEnabled && customChallenge.type == 'truth') ||
                (_daresEnabled && customChallenge.type == 'dare')) {
              // If we're filtering by category, only include challenges from that category
              if (_selectedCategoryIds.isNotEmpty &&
                  customChallenge.categoryId != null &&
                  !_selectedCategoryIds.contains(customChallenge.categoryId)) {
                continue; // Skip this challenge if it's not in the selected category
              }

              // Convert custom challenge to regular challenge format
              final challenge = Challenge(
                id: customChallenge.id,
                type: customChallenge.type,
                content: customChallenge.content,
                categoryId:
                    customChallenge.categoryId ??
                    '', // Use the category if available
                forGender: customChallenge.forGender,
                coupleOnly: customChallenge.coupleOnly,
                usageCount: 0,
                createdAt: customChallenge.createdAt,
                updatedAt: customChallenge.createdAt,
              );
              allChallenges.add(challenge);
            }
          }
        }
      }

      if (allChallenges.isNotEmpty) {
        _currentChallenge = allChallenges[random.nextInt(allChallenges.length)];

        // Record challenge history
        if (_currentSession != null &&
            _currentPlayer != null &&
            _currentChallenge != null) {
          await _databaseService.recordChallengeHistory(
            challengeId: _currentChallenge!.id,
            sessionId: _currentSession!.id,
            playerId: _currentPlayer!.id,
            completed: false,
          );
        }
      } else {
        // If no challenges are available, create a default challenge
        final defaultType =
            specificType ?? (Random().nextBool() ? 'truth' : 'dare');
        final defaultContent =
            defaultType == 'truth'
                ? 'What is your most intense sexual experience and what made it so good?'
                : 'Give your partner a sensual massage for 2 minutes.';

        // Create a default challenge
        _currentChallenge = Challenge(
          id: 'default-${DateTime.now().millisecondsSinceEpoch}',
          type: defaultType,
          content: defaultContent,
          categoryId:
              _selectedCategoryIds.isNotEmpty
                  ? _selectedCategoryIds.first
                  : 'default',
          forGender: null,
          coupleOnly: true,
          usageCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to get challenge: $e');
    }
  }

  /// Get the next player without getting a challenge
  void getNextPlayer() {
    if (_players.isEmpty) {
      // If no players exist, create default players
      _createDefaultPlayers();
      return;
    }

    // Ensure we're cycling through players correctly
    if (_players.length > 1) {
      // Make sure we don't get the same player twice in a row
      int nextIndex;
      do {
        nextIndex = Random().nextInt(_players.length);
      } while (nextIndex == _currentPlayerIndex && _players.length > 1);

      _currentPlayerIndex = nextIndex;
    } else {
      _currentPlayerIndex = 0; // Only one player, so always use that one
    }

    _currentPlayer = _players[_currentPlayerIndex];
    _currentChallenge = null;
    notifyListeners();
  }

  /// Create default players if none exist
  Future<void> _createDefaultPlayers() async {
    try {
      // Get default players from PlayerUtils
      final defaultPlayers = PlayerUtils.getDefaultPlayers();

      // Add each default player
      for (final player in defaultPlayers) {
        await addPlayer(
          player.name,
          player.gender,
          imagePath: player.imagePath,
          playerId: player.id,
        );
      }

      // Set the first player as current
      if (_players.isNotEmpty) {
        _currentPlayerIndex = 0;
        _currentPlayer = _players[_currentPlayerIndex];
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to create default players: $e');
    }
  }

  /// Mark the current challenge as completed
  Future<void> completeChallenge() async {
    try {
      if (_currentSession != null &&
          _currentPlayer != null &&
          _currentChallenge != null) {
        await _databaseService.recordChallengeHistory(
          challengeId: _currentChallenge!.id,
          sessionId: _currentSession!.id,
          playerId: _currentPlayer!.id,
          completed: true,
        );
      }
    } catch (e) {
      _setError('Failed to mark challenge as completed: $e');
    }
  }

  /// Skip the current challenge
  Future<void> skipChallenge() async {
    try {
      if (_currentSession != null &&
          _currentPlayer != null &&
          _currentChallenge != null) {
        await _databaseService.recordChallengeHistory(
          challengeId: _currentChallenge!.id,
          sessionId: _currentSession!.id,
          playerId: _currentPlayer!.id,
          completed: false,
          skipped: true,
        );
      }

      // Clear the current challenge but don't get a new one
      _currentChallenge = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to skip challenge: $e');
    }
  }

  /// Create a custom challenge
  Future<void> createCustomChallenge({
    required String type,
    required String content,
    String? forGender,
    String? categoryId,
    bool coupleOnly = true,
  }) async {
    _setLoading(true);
    try {
      if (_currentPlayer == null) {
        throw Exception('No current player');
      }

      final customChallengeData = await _databaseService.createCustomChallenge(
        type: type,
        content: content,
        createdBy: _currentPlayer!.id,
        forGender: forGender,
        categoryId: categoryId,
        coupleOnly: coupleOnly,
      );

      final customChallenge = CustomChallenge.fromJson(customChallengeData);
      _customChallenges.add(customChallenge);

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create custom challenge: $e');
    }
  }

  /// Update game settings
  void updateSettings({
    bool? includeCustomChallenges,
    List<String>? selectedCategoryIds,
    bool? truthsEnabled,
    bool? daresEnabled,
  }) {
    if (includeCustomChallenges != null) {
      _includeCustomChallenges = includeCustomChallenges;
    }

    if (selectedCategoryIds != null) {
      _selectedCategoryIds = selectedCategoryIds;
    }

    if (truthsEnabled != null) {
      _truthsEnabled = truthsEnabled;
    }

    if (daresEnabled != null) {
      _daresEnabled = daresEnabled;
    }

    notifyListeners();
  }

  /// End the current game session
  Future<void> endGameSession() async {
    _setLoading(true);
    try {
      if (_currentSession != null) {
        // Use the Supabase client from SupabaseConfig
        await SupabaseConfig.client
            .from('game_sessions')
            .update({'ended_at': DateTime.now().toIso8601String()})
            .eq('id', _currentSession!.id);

        _currentSession = null;
        _currentPlayer = null;
        _currentChallenge = null;
        _challenges = [];
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to end game session: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    // Only notify if the state actually changed
    if (_isLoading != loading) {
      _isLoading = loading;
      if (loading) {
        _errorMessage = '';
      }
      notifyListeners();
    }
  }

  /// Set error message
  void _setError(String message) {
    // Only notify if the error message changed
    if (_errorMessage != message) {
      _errorMessage = message;
      _isLoading = false;
      notifyListeners();
    }
  }
}
