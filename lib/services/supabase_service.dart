import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/db_category.dart';
import '../models/challenge.dart';

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Get all categories
  Future<List<DbCategory>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('difficulty', ascending: true);

      return response.map((json) => DbCategory.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }

  // Get category by ID
  Future<DbCategory> getCategoryById(String id) async {
    try {
      final response =
          await _client.from('categories').select().eq('id', id).single();

      return DbCategory.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching category by ID: $e');
      rethrow;
    }
  }

  // Get challenges by category and type
  Future<List<Challenge>> getChallengesByCategoryAndType({
    required String categoryId,
    required String type,
    required String gender,
  }) async {
    try {
      // First, ensure we have a valid category ID
      String actualCategoryId = categoryId;

      // If categoryId is not a UUID, try to get the actual UUID
      if (categoryId.length < 36) {
        final categoryIdFromName = await getCategoryIdByName(categoryId);
        if (categoryIdFromName != null) {
          actualCategoryId = categoryIdFromName;
        } else {
          // If we can't find the category, return an empty list
          debugPrint('Category not found: $categoryId');
          return [];
        }
      }

      final response = await _client
          .from('challenges')
          .select()
          .eq('category_id', actualCategoryId)
          .eq('type', type)
          .or('for_gender.eq.any,for_gender.eq.$gender');

      return response.map((json) => Challenge.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching challenges: $e');
      rethrow;
    }
  }

  // Get category ID by name
  Future<String?> getCategoryIdByName(String categoryName) async {
    try {
      final response =
          await _client
              .from('categories')
              .select('id')
              .eq('name', categoryName)
              .single();

      return response['id'] as String;
    } catch (e) {
      debugPrint('Error fetching category ID by name: $e');
      return null;
    }
  }

  // Get random challenge by category name and type
  Future<Challenge?> getRandomChallenge({
    required String categoryId,
    required String type,
    required String gender,
  }) async {
    try {
      debugPrint(
        'Getting random challenge for category: $categoryId, type: $type, gender: $gender',
      );

      // First, try to get the actual UUID for the category name
      String? actualCategoryId;

      // Check if categoryId is already a UUID or a name
      if (categoryId.length < 36) {
        // Not a UUID, likely a name like "soft"
        // Convert category name to ID
        debugPrint('Converting category name to ID: $categoryId');
        actualCategoryId = await getCategoryIdByName(categoryId);
        debugPrint('Category ID from name: $actualCategoryId');

        if (actualCategoryId == null) {
          // Try with capitalized name
          debugPrint(
            'Trying with capitalized name: ${categoryId.capitalize()}',
          );
          actualCategoryId = await getCategoryIdByName(categoryId.capitalize());

          if (actualCategoryId == null) {
            // Try with lowercase name
            debugPrint(
              'Trying with lowercase name: ${categoryId.toLowerCase()}',
            );
            actualCategoryId = await getCategoryIdByName(
              categoryId.toLowerCase(),
            );

            if (actualCategoryId == null) {
              debugPrint(
                'Category not found after multiple attempts: $categoryId',
              );
              // Return null instead of throwing an exception
              return null;
            }
          }
        }
      } else {
        // Already a UUID
        actualCategoryId = categoryId;
      }

      debugPrint('Using category ID: $actualCategoryId');

      final challenges = await getChallengesByCategoryAndType(
        categoryId: actualCategoryId,
        type: type,
        gender: gender,
      );

      debugPrint('Found ${challenges.length} challenges');

      if (challenges.isEmpty) {
        return null;
      }

      // Shuffle the list to get a random challenge
      challenges.shuffle();
      return challenges.first;
    } catch (e, stackTrace) {
      debugPrint('Error fetching random challenge: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return null instead of rethrowing to prevent app crashes
      return null;
    }
  }

  // Add a custom challenge
  Future<Challenge> addCustomChallenge({
    required String type,
    required String content,
    required String categoryId,
    required String forGender,
    required bool coupleOnly,
  }) async {
    try {
      final response =
          await _client
              .from('challenges')
              .insert({
                'type': type,
                'content': content,
                'category_id': categoryId,
                'for_gender': forGender,
                'couple_only': coupleOnly,
              })
              .select()
              .single();

      return Challenge.fromJson(response);
    } catch (e) {
      debugPrint('Error adding custom challenge: $e');
      rethrow;
    }
  }
}
