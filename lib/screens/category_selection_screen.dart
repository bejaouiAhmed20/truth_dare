import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import 'game_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        await gameProvider.initialize();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load categories: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Choose Category',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Sound toggle button
          IconButton(
            icon: Icon(
              SoundService().soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                SoundService().toggleSound();
              });
            },
          ),
          // Music toggle button
          IconButton(
            icon: Icon(
              SoundService().musicEnabled ? Icons.music_note : Icons.music_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                SoundService().toggleMusic();
              });
            },
          ),
        ],
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
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(24.0),
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
                          'Choose a Category',
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
                            'Select a category for Bouhmid and Marouma',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Player avatars
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Bouhmid avatar
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue.shade300,
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
                                    'assets/ahmed.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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

                              // Heart icon in the middle
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red.shade400,
                                  size: 30,
                                ),
                              ),

                              // Marouma avatar
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.pink.shade300,
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
                                    'assets/maram.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Categories
                        Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Categories',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Expanded(
                          child: Consumer<GameProvider>(
                            builder: (context, gameProvider, child) {
                              return ListView.builder(
                                itemCount: gameProvider.categories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      gameProvider.categories[index];
                                  return _buildCategoryCard(context, category);
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Start Game Button
                        Container(
                          width: double.infinity,
                          height: 60,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow:
                                _selectedCategoryId != null
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(40),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: ElevatedButton(
                            onPressed:
                                _selectedCategoryId == null ? null : _startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withAlpha(60),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBackgroundColor: Colors.white.withAlpha(
                                30,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient:
                                    _selectedCategoryId == null
                                        ? null
                                        : LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF6A1B9A),
                                            const Color(0xFF9C27B0),
                                          ],
                                        ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Start Truth or Dare',
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
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, GameCategory category) {
    final isSelected = _selectedCategoryId == category.id;
    final categoryColor = _getCategoryColor(category.difficulty);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? categoryColor.withAlpha(100)
                    : Colors.black.withAlpha(30),
            blurRadius: isSelected ? 10 : 6,
            spreadRadius: isSelected ? 1 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            SoundService().playClickSound();
            setState(() {
              // If already selected, deselect it
              if (isSelected) {
                _selectedCategoryId = null;
              } else {
                // Otherwise select this category (only one at a time)
                _selectedCategoryId = category.id;
              }
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? categoryColor : Colors.white.withAlpha(100),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Category Icon with animated container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? categoryColor.withAlpha(50)
                            : categoryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: categoryColor.withAlpha(40),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                            : [],
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(category.name),
                      color: categoryColor,
                      size: isSelected ? 34 : 28,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Category Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? categoryColor : Colors.black87,
                        ),
                      ),
                      if (category.description != null)
                        Text(
                          category.description!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      const SizedBox(height: 4),
                      // Difficulty indicator
                      Row(
                        children: [
                          ...List.generate(
                            category.difficulty,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: categoryColor,
                              ),
                            ),
                          ),
                          ...List.generate(
                            5 - category.difficulty,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? categoryColor : Colors.grey.shade200,
                    border: Border.all(
                      color: isSelected ? categoryColor : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: categoryColor.withAlpha(60),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                            : [],
                  ),
                  child:
                      isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'soft':
        return Icons.sentiment_satisfied;
      case 'romantic':
        return Icons.favorite;
      case 'hot':
        return Icons.whatshot;
      case 'hard':
        return Icons.local_fire_department;
      case 'extreme':
        return Icons.flash_on;
      default:
        return Icons.category;
    }
  }

  void _startGame() async {
    SoundService().playClickSound();

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);

      // Update selected category
      gameProvider.updateSettings(selectedCategoryIds: [_selectedCategoryId!]);

      // Create game session with default name
      final sessionName =
          'Game Session ${DateTime.now().toString().substring(0, 16)}';
      await gameProvider.createGameSession(sessionName);

      // Navigate to game screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to start game: $e')));
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
