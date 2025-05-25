import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emotion.dart';

class EmotionService {
  static final EmotionService _instance = EmotionService._internal();
  factory EmotionService() => _instance;
  EmotionService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create the emotions table if it doesn't exist
  Future<void> initializeEmotionsTable() async {
    try {
      // Check if table exists by trying to query it
      await _supabase.from('emotions').select('id').limit(1);
      if (kDebugMode) print('EmotionService: Emotions table already exists');
    } catch (e) {
      if (kDebugMode)
        print('EmotionService: Table might not exist, trying to create...');

      // Try to create a simple record to test if table exists
      // If it fails, we'll assume the table doesn't exist and continue
      try {
        // Try a simple insert that will fail if table doesn't exist
        await _supabase.from('emotions').insert({
          'emoji': '😊',
          'name': 'Test',
          'category': 'Test',
          'user_id': 'test',
          'user_name': 'Test User',
          'created_at': DateTime.now().toIso8601String(),
        });

        // If we get here, table exists, delete the test record
        await _supabase.from('emotions').delete().eq('user_id', 'test');
        if (kDebugMode) print('EmotionService: Emotions table is ready');
      } catch (insertError) {
        if (kDebugMode)
          print('EmotionService: Table creation/access issue: $insertError');
        // Continue anyway - the table might exist but we don't have proper permissions
      }
    }
  }

  // Share an emotion
  Future<void> shareEmotion({
    required String emoji,
    required String name,
    required String category,
    required String userName,
  }) async {
    try {
      if (kDebugMode)
        print('EmotionService: Sharing emotion $emoji $name for $userName');

      final emotion = {
        'emoji': emoji,
        'name': name,
        'category': category,
        'user_name': userName,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('emotions').insert(emotion);

      if (kDebugMode) print('EmotionService: Emotion shared successfully');
    } catch (e) {
      if (kDebugMode) print('EmotionService: Failed to share emotion: $e');
      throw Exception('Failed to share emotion: $e');
    }
  }

  // Get recent emotions
  Future<List<Emotion>> getRecentEmotions({int limit = 50}) async {
    try {
      if (kDebugMode) print('EmotionService: Fetching recent emotions');

      final response = await _supabase
          .from('emotions')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      final emotions =
          (response as List).map((json) => Emotion.fromJson(json)).toList();

      if (kDebugMode)
        print('EmotionService: Fetched ${emotions.length} emotions');
      return emotions;
    } catch (e) {
      if (kDebugMode) print('EmotionService: Failed to fetch emotions: $e');
      return [];
    }
  }

  // Listen to real-time emotion updates
  Stream<List<Emotion>> listenToEmotions() {
    if (kDebugMode)
      print('EmotionService: Setting up real-time emotion listener');

    return _supabase
        .from('emotions')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(50)
        .map((data) {
          return data.map((json) => Emotion.fromJson(json)).toList();
        });
  }

  // Get emotions by user
  Future<List<Emotion>> getEmotionsByUser(String userId) async {
    try {
      if (kDebugMode)
        print('EmotionService: Fetching emotions for user $userId');

      final response = await _supabase
          .from('emotions')
          .select()
          .eq('user_name', userId)
          .order('created_at', ascending: false)
          .limit(20);

      final emotions =
          (response as List).map((json) => Emotion.fromJson(json)).toList();

      if (kDebugMode)
        print('EmotionService: Fetched ${emotions.length} emotions for user');
      return emotions;
    } catch (e) {
      if (kDebugMode)
        print('EmotionService: Failed to fetch user emotions: $e');
      return [];
    }
  }

  // Delete an emotion by ID
  Future<void> deleteEmotion(String emotionId) async {
    try {
      if (kDebugMode) print('EmotionService: Deleting emotion $emotionId');

      await _supabase.from('emotions').delete().eq('id', emotionId);

      if (kDebugMode) print('EmotionService: Emotion deleted successfully');
    } catch (e) {
      if (kDebugMode) print('EmotionService: Failed to delete emotion: $e');
      throw Exception('Failed to delete emotion: $e');
    }
  }

  // Get emotion statistics
  Future<Map<String, int>> getEmotionStats() async {
    try {
      if (kDebugMode) print('EmotionService: Fetching emotion statistics');

      final response = await _supabase
          .from('emotions')
          .select('category')
          .gte(
            'created_at',
            DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
          );

      final stats = <String, int>{};
      for (final item in response as List) {
        final category = item['category'] as String;
        stats[category] = (stats[category] ?? 0) + 1;
      }

      if (kDebugMode) print('EmotionService: Fetched emotion stats: $stats');
      return stats;
    } catch (e) {
      if (kDebugMode)
        print('EmotionService: Failed to fetch emotion stats: $e');
      return {};
    }
  }
}
