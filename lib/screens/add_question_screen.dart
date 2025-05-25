import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import '../services/custom_question_service.dart';
import '../services/supabase_service.dart';

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _customQuestionService = CustomQuestionService();
  final _supabaseService = SupabaseService();

  String _selectedType = 'truth';
  String _selectedCategory = 'soft';
  String _selectedGender = 'both';
  bool _isSubmitting = false;

  final List<Category> _categories = Category.getPredefinedCategories();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  // Submit the question
  Future<void> _submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // First, save to local storage
        await _customQuestionService.addQuestion(
          text: _questionController.text.trim(),
          type: _selectedType,
          category: _selectedCategory,
          targetGender: _selectedGender,
        );

        // Then try to save to Supabase
        try {
          // Get the category ID from the name
          final categoryId = await _supabaseService.getCategoryIdByName(
            _selectedCategory[0].toUpperCase() + _selectedCategory.substring(1),
          );

          if (categoryId != null) {
            // Save to Supabase
            await _supabaseService.addCustomChallenge(
              type: _selectedType,
              content: _questionController.text.trim(),
              categoryId: categoryId,
              forGender: _selectedGender == 'both' ? 'any' : _selectedGender,
              coupleOnly: true,
            );
          }
        } catch (supabaseError) {
          // Just log the error, we already saved to local storage
          debugPrint('Error saving to Supabase: $supabaseError');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Question added successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Clear the form
          _questionController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding question: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade400, Colors.teal.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Add Custom Question',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Type
                          Text(
                            'Question Type',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTypeSelector(
                                  'Truth',
                                  'truth',
                                  Icons.question_answer,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildTypeSelector(
                                  'Dare',
                                  'dare',
                                  Icons.sports_kabaddi,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category
                          Text(
                            'Category',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedCategory,
                                items:
                                    _categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category.id,
                                        child: Row(
                                          children: [
                                            Icon(
                                              category.icon,
                                              color: category.color,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              category.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Target Gender
                          Text(
                            'For',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildGenderSelector(
                                  'Ahmed',
                                  'male',
                                  Icons.man,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildGenderSelector(
                                  'Both',
                                  'both',
                                  Icons.people,
                                  Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildGenderSelector(
                                  'Maram',
                                  'female',
                                  Icons.woman,
                                  Colors.pink,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Question Text
                          Text(
                            'Question Text',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _questionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter your question or challenge here...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.teal.shade700,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a question';
                              }
                              if (value.trim().length < 5) {
                                return 'Question is too short';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child:
                                  _isSubmitting
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                      : Text(
                                        'Add Question',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(25) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(25) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
