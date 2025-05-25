import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../models/models.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  String _selectedType = 'truth';
  String _selectedGender = 'any';
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        _selectedType == 'truth'
            ? const Color(0xFF1E88E5) // Blue
            : const Color(0xFFE53935); // Red/Orange

    final Color textColor = Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Add Custom Challenge',
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _selectedType == 'truth'
                  ? const Color(0xFF1976D2) // Blue
                  : const Color(0xFFD32F2F), // Red
              _selectedType == 'truth'
                  ? const Color(0xFF42A5F5) // Lighter Blue
                  : const Color(0xFFE57373), // Lighter Red
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
                      'Create Your Challenge',
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
                        'Add your own ${_selectedType == 'truth' ? 'question' : 'challenge'} to the game',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Challenge Type
                    Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Challenge Type',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeOption(
                            'Truth',
                            'truth',
                            Icons.question_answer_rounded,
                            const Color(0xFF1E88E5),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTypeOption(
                            'Dare',
                            'dare',
                            Icons.local_fire_department_rounded,
                            const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Challenge Content
                    Row(
                      children: [
                        Icon(
                          _selectedType == 'truth'
                              ? Icons.edit_note_rounded
                              : Icons.edit_attributes_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Challenge Content',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText:
                              _selectedType == 'truth'
                                  ? 'Enter your truth question...'
                                  : 'Enter your dare challenge...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        maxLines: 3,
                        style: GoogleFonts.poppins(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the challenge content';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category Selection
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Category',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Consumer<GameProvider>(
                        builder: (context, gameProvider, child) {
                          return DropdownButtonFormField<String>(
                            value: _selectedCategoryId,
                            decoration: InputDecoration(
                              hintText: 'Select a category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color:
                                  _selectedType == 'truth'
                                      ? const Color(0xFF1E88E5)
                                      : const Color(0xFFE53935),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            dropdownColor: Colors.white,
                            items:
                                gameProvider.categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Gender Selection
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'For Gender',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                            'Any',
                            'any',
                            Icons.people_alt_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                            'Male',
                            'male',
                            Icons.male_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                            'Female',
                            'female',
                            Icons.female_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
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
                        onPressed: _isLoading ? null : _submitChallenge,
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
                                      colors:
                                          _selectedType == 'truth'
                                              ? [
                                                const Color(0xFF1976D2),
                                                const Color(0xFF42A5F5),
                                              ]
                                              : [
                                                const Color(0xFFD32F2F),
                                                const Color(0xFFE57373),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _selectedType == 'truth'
                                              ? Icons.question_answer_rounded
                                              : Icons
                                                  .local_fire_department_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Add Challenge',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
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

  Widget _buildTypeOption(
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.white.withAlpha(240),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.white.withAlpha(100),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(30) : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? color : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, String value, IconData icon) {
    final isSelected = _selectedGender == value;
    final Color color = const Color(0xFF9C27B0); // Purple

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.white.withAlpha(240),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.white.withAlpha(100),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? color.withAlpha(30) : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? color : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitChallenge() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final gameProvider = Provider.of<GameProvider>(context, listen: false);

        await gameProvider.createCustomChallenge(
          type: _selectedType,
          content: _contentController.text,
          forGender: _selectedGender == 'any' ? null : _selectedGender,
          categoryId: _selectedCategoryId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Challenge added successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add challenge: $e')),
          );
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
