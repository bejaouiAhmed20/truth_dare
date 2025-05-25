import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_carousel_screen.dart';
import 'settings_screen.dart';
import 'romantic_about_screen.dart';
import 'add_question_screen.dart';

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade600, Colors.deepPurple.shade800],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Column(
                  children: [
                    Text(
                      'Bouhmid & Marouma',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(100),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Truth or Dare',
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(100),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Special Edition',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Player avatars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouhmid avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.shade300,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/ahmed.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey.shade700,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Heart icon in the middle
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                        size: 40,
                      ),
                    ),

                    // Marouma avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.pink.shade300,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/maram.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey.shade700,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Play Button
                _buildButton(
                  context,
                  'Play Game',
                  Icons.play_circle_filled,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryCarouselScreen(),
                    ),
                  ),
                  Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                // Settings Button
                _buildButton(
                  context,
                  'Settings',
                  Icons.settings,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
                  Colors.blue.shade700,
                ),

                const SizedBox(height: 20),

                // Add Question Button
                _buildButton(
                  context,
                  'Add Question',
                  Icons.add_circle_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddQuestionScreen(),
                    ),
                  ),
                  Colors.teal.shade600,
                ),

                const SizedBox(height: 20),

                // About Button with heart icon
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RomanticAboutScreen(),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withAlpha(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'About',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.black.withAlpha(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
