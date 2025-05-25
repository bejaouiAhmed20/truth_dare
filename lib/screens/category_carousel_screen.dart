import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import 'simple_game_screen.dart';

class CategoryCarouselScreen extends StatefulWidget {
  const CategoryCarouselScreen({super.key});

  @override
  State<CategoryCarouselScreen> createState() => _CategoryCarouselScreenState();
}

class _CategoryCarouselScreenState extends State<CategoryCarouselScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  int _currentPage = 0;
  final List<Category> _categories = Category.getPredefinedCategories();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
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
                        'Choose a Category',
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

              const SizedBox(height: 20),

              // Player avatars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouhmid avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade300, width: 2),
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
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      border: Border.all(color: Colors.pink.shade300, width: 2),
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

              const SizedBox(height: 40),

              // Category Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _categories.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isCurrentPage = index == _currentPage;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutQuint,
                      margin: EdgeInsets.symmetric(
                        vertical: isCurrentPage ? 10 : 30,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            category.color,
                            category.color.withAlpha(200),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: category.color.withAlpha(100),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withAlpha(50),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category Icon with background
                          Container(
                            width: 100, // Smaller container
                            height: 100, // Smaller container
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(50),
                              border: Border.all(
                                color: Colors.white.withAlpha(100),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              category.icon,
                              size: 60, // Smaller icon
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 20), // Less spacing
                          // Category Name
                          Text(
                            category.name.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 28, // Smaller font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1, // Reduced letter spacing
                              shadows: [
                                Shadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Category Description
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              category.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14, // Smaller font size
                                color: Colors.white,
                                height: 1.3, // Tighter line height
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _categories.length,
                    (index) => _buildPageIndicator(index),
                  ),
                ),
              ),

              // Start Game Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to game screen with selected category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SimpleGameScreen(
                                selectedCategory: _categories[_currentPage],
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _categories[_currentPage].color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_filled, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'Start ${_categories[_currentPage].name} Game',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildPageIndicator(int index) {
    final isCurrentPage = index == _currentPage;
    final category = _categories[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isCurrentPage ? 12 : 8,
      width: isCurrentPage ? 12 : 8,
      decoration: BoxDecoration(
        color: isCurrentPage ? category.color : Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            isCurrentPage
                ? [
                  BoxShadow(
                    color: category.color.withAlpha(100),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
    );
  }
}
