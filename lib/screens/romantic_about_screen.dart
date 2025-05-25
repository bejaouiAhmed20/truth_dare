import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RomanticAboutScreen extends StatelessWidget {
  const RomanticAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade400,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // App Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Our Love Story',
                        style: GoogleFonts.dancingScript(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                'Exclusively for Maram & Ahmed',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Heart Icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.pink.withOpacity(0.2),
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  size: 50,
                                  color: Colors.pink.shade300,
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Love Letter Title
                              Text(
                                'To Maram, my Marouma,',
                                style: GoogleFonts.dancingScript(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink.shade200,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // Subtitle
                              Text(
                                'my love, my future wife, my soulmate, my favorite person, my best friend, my everything ❤️',
                                style: GoogleFonts.dancingScript(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Love Letter Content
                              Text(
                                'I don\'t even know where to begin, because every time I think about how much I love you, it feels too big to put into words. But I\'m going to try.\n\n'
                                'Marouma, you mean the world to me. You\'re not just my girlfriend — you\'re the person I want to spend forever with. You\'re the one I imagine building a life with, sharing dreams, laughter, late-night talks, and all the little moments that matter most. From the way you smile to the way you say my name, you have this magic that makes everything feel right.\n\n'
                                'Sometimes, all it takes is your voice — just hearing it is enough to make me feel calm, happy, and safe. I fall in love with you again and again, even in the smallest moments — when you laugh, when you look at me, or when I see a picture of you and can\'t help but smile like an idiot.\n\n'
                                'You\'re so beautiful, inside and out. Not just gorgeous in the way you look (which you definitely are), but in the way you care, the way you love, the way you light up a room without even trying. You can change my whole mood without even realizing it — just one message from you, one look, one word, and everything feels better.\n\n'
                                'You\'re my comfort, my support, my peace, and my excitement all in one. I\'ve never felt this way before, and I don\'t want it with anyone else but you. You\'re the one I want to wake up next to, the one I want to come home to, the one I want to share every part of my life with.\n\n'
                                'I love you so much, Marouma. So deeply, so endlessly, it\'s hard to explain. But I hope you feel it — in my words, in my actions, and every time I look at you. You\'re not just my girlfriend… you\'re the girl. The one. And I\'ll keep loving you more every day.',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Signature
                              Text(
                                'Forever yours,',
                                style: GoogleFonts.dancingScript(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 5),
                              
                              Text(
                                'Ahmed',
                                style: GoogleFonts.dancingScript(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink.shade200,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Floating Hearts
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite, color: Colors.pink.shade300, size: 20),
                                  const SizedBox(width: 10),
                                  Icon(Icons.favorite, color: Colors.pink.shade200, size: 15),
                                  const SizedBox(width: 10),
                                  Icon(Icons.favorite, color: Colors.pink.shade300, size: 20),
                                ],
                              ),
                            ],
                          ),
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
}
