import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade100, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal.shade700,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App name
                  Center(
                    child: Text(
                      'Bouhmid & Marouma\nTruth or Dare',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // App version
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // About section
                  Text(
                    'About',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'This app is a special edition of Truth or Dare created exclusively for Bouhmid and Marouma. It features personalized questions and challenges for a fun experience.',
                    style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  // How to play section
                  Text(
                    'How to Play',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildHowToPlayItem(
                    '1',
                    'Take turns answering questions or performing dares',
                  ),

                  const SizedBox(height: 10),

                  _buildHowToPlayItem(
                    '2',
                    'Choose between Truth or Dare when it\'s your turn',
                  ),

                  const SizedBox(height: 10),

                  _buildHowToPlayItem(
                    '3',
                    'Complete the challenge and pass to the next player',
                  ),

                  const SizedBox(height: 10),

                  _buildHowToPlayItem(
                    '4',
                    'Use the settings to customize your game experience',
                  ),

                  const SizedBox(height: 40),

                  // Copyright
                  Center(
                    child: Text(
                      '© 2023 Bouhmid & Marouma',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowToPlayItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal.shade700,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
