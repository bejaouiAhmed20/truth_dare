import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_question.dart';

class CustomQuestionService {
  static const String _storageKey = 'custom_questions';
  final Uuid _uuid = const Uuid();

  // Get all custom questions
  Future<List<CustomQuestion>> getAllQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? questionsJson = prefs.getString(_storageKey);
    
    if (questionsJson == null) {
      return [];
    }
    
    final List<dynamic> decodedList = jsonDecode(questionsJson);
    return decodedList
        .map((item) => CustomQuestion.fromMap(item))
        .toList();
  }
  
  // Add a new custom question
  Future<CustomQuestion> addQuestion({
    required String text,
    required String type,
    required String category,
    required String targetGender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CustomQuestion> questions = await getAllQuestions();
    
    final newQuestion = CustomQuestion(
      id: _uuid.v4(),
      text: text,
      type: type,
      category: category,
      targetGender: targetGender,
      createdAt: DateTime.now(),
    );
    
    questions.add(newQuestion);
    
    await prefs.setString(
      _storageKey,
      jsonEncode(questions.map((q) => q.toMap()).toList()),
    );
    
    return newQuestion;
  }
  
  // Delete a custom question
  Future<void> deleteQuestion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CustomQuestion> questions = await getAllQuestions();
    
    final updatedQuestions = questions.where((q) => q.id != id).toList();
    
    await prefs.setString(
      _storageKey,
      jsonEncode(updatedQuestions.map((q) => q.toMap()).toList()),
    );
  }
  
  // Get questions by type and category
  Future<List<CustomQuestion>> getQuestionsByTypeAndCategory({
    required String type,
    required String category,
    required String gender,
  }) async {
    final List<CustomQuestion> allQuestions = await getAllQuestions();
    
    return allQuestions.where((q) => 
      q.type == type && 
      q.category == category && 
      (q.targetGender == gender || q.targetGender == 'both')
    ).toList();
  }
}
