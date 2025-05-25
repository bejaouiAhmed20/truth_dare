import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/simple_home_screen.dart';

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

  runApp(const MyApp());
}

/// Preload assets to ensure they're available when needed
Future<void> _preloadAssets() async {
  try {
    // Force load the player images into cache
    await Future.wait([
      rootBundle.load('assets/ahmed.jpg'),
      rootBundle.load('assets/maram.jpg'),
    ]);
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
