import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/simple_home_screen.dart';
import 'services/sound_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://xnmmemirznytfsdqcuzm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhubW1lbWlyem55dGZzZHFjdXptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Mzc0NjIsImV4cCI6MjA2MzMxMzQ2Mn0.LmZUK7nhKHwmDdFrSVGmA7LBLBJCr27bYC67AXpkF6A',
  );

  // Force asset loading at startup
  await _preloadAssets();

  // Initialize sound service
  SoundService();

  runApp(const MyApp());
}

/// Preload assets to ensure they're available when needed
Future<void> _preloadAssets() async {
  try {
    // Force load the player images and sound files into cache
    await Future.wait([
      rootBundle.load('assets/ahmed.jpg'),
      rootBundle.load('assets/maram.jpg'),
      rootBundle.load('assets/sounds/pop.mp3'),
      rootBundle.load('assets/sounds/roulette.mp3'),
      rootBundle.load('assets/sounds/success.mp3'),
      rootBundle.load('assets/sounds/Two Feet - Love is a Bitch.mp3'),
      rootBundle.load(
        'assets/sounds/Elvis Presley - Can\'t Help Falling In Love (Official Audio).mp3',
      ),
      rootBundle.load('assets/sounds/7 Seconds.mp3'),
      rootBundle.load(
        'assets/sounds/Michele Morrone - Feel It (from 365 days movie).mp3',
      ),
    ]);
    debugPrint('Assets preloaded successfully');
  } catch (e) {
    debugPrint('Error preloading assets: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouhmid & Marouma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SimpleHomeScreen(),
    );
  }
}
