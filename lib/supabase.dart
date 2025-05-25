import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client configuration
///
/// This class initializes and provides access to the Supabase client.
/// It uses the credentials provided by the user to connect to the Supabase project.
class SupabaseConfig {
  // Supabase URL - Replace with your Supabase URL
  // Example: https://xnmmemirznytfsdqcuzm.supabase.co
  static const String supabaseUrl = 'https://xnmmemirznytfsdqcuzm.supabase.co';

  // Supabase Anon/Public Key - Replace with your Supabase Anon Key
  // Example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhubW1lbWlyem55dGZzZHFjdXptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Mzc0NjIsImV4cCI6MjA2MzMxMzQ2Mn0.LmZUK7nhKHwmDdFrSVGmA7LBLBJCr27bYC67AXpkF6A
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhubW1lbWlyem55dGZzZHFjdXptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Mzc0NjIsImV4cCI6MjA2MzMxMzQ2Mn0.LmZUK7nhKHwmDdFrSVGmA7LBLBJCr27bYC67AXpkF6A';

  /// Initialize Supabase client
  ///
  /// This method should be called before runApp() in main.dart
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode,
    );
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get the current user ID if authenticated
  static String? get currentUserId => client.auth.currentUser?.id;

  /// Check if a user is currently authenticated
  static bool get isAuthenticated => client.auth.currentUser != null;
}

/// Database service for interacting with Supabase tables
///
/// This class provides methods for CRUD operations on the database tables.
class DatabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Get all categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('difficulty', ascending: true);
    return response;
  }

  /// Get challenges by category
  Future<List<Map<String, dynamic>>> getChallengesByCategory({
    required String categoryId,
    required String type,
    String? gender,
    bool? coupleOnly,
  }) async {
    var query = _client
        .from('challenges')
        .select()
        .eq('category_id', categoryId)
        .eq('type', type);

    if (gender != null) {
      query = query.or('for_gender.eq.any,for_gender.eq.$gender');
    }

    if (coupleOnly != null) {
      query = query.eq('couple_only', coupleOnly);
    }

    final response = await query.order('usage_count', ascending: true);
    return response;
  }

  /// Create a new game session
  Future<Map<String, dynamic>> createGameSession({
    required String sessionName,
    required Map<String, dynamic> settings,
  }) async {
    final response =
        await _client
            .from('game_sessions')
            .insert({'session_name': sessionName, 'settings': settings})
            .select()
            .single();
    return response;
  }

  /// Add a player to a game session
  Future<void> addPlayerToSession({
    required String playerId,
    required String sessionId,
  }) async {
    await _client.from('player_sessions').insert({
      'player_id': playerId,
      'session_id': sessionId,
    });
  }

  /// Create a new player
  Future<Map<String, dynamic>> createPlayer({
    required String name,
    required String gender,
    String? imagePath,
    String? id,
  }) async {
    final playerData = {
      'name': name,
      'gender': gender,
      'image_path': imagePath,
    };

    // If an ID is provided, use it
    if (id != null && id.isNotEmpty) {
      playerData['id'] = id;
    }

    final response =
        await _client.from('players').insert(playerData).select().single();
    return response;
  }

  /// Record challenge history
  Future<void> recordChallengeHistory({
    required String challengeId,
    required String sessionId,
    required String playerId,
    required bool completed,
    bool skipped = false,
  }) async {
    await _client.from('challenge_history').insert({
      'challenge_id': challengeId,
      'session_id': sessionId,
      'player_id': playerId,
      'completed': completed,
      'skipped': skipped,
    });
  }

  /// Create a custom challenge
  Future<Map<String, dynamic>> createCustomChallenge({
    required String type,
    required String content,
    required String createdBy,
    String? forGender,
    String? categoryId,
    bool coupleOnly = true,
  }) async {
    final response =
        await _client
            .from('custom_challenges')
            .insert({
              'type': type,
              'content': content,
              'created_by': createdBy,
              'for_gender': forGender,
              'category_id': categoryId,
              'couple_only': coupleOnly,
            })
            .select()
            .single();
    return response;
  }

  /// Get custom challenges for a player
  Future<List<Map<String, dynamic>>> getCustomChallenges({
    required String playerId,
  }) async {
    final response = await _client
        .from('custom_challenges')
        .select()
        .eq('created_by', playerId);
    return response;
  }
}
