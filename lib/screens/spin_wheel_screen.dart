import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import '../services/sound_service.dart';
import 'simple_game_screen.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Category> _categories = Category.getPredefinedCategories();
  Category? _selectedCategory;
  bool _isSpinning = false;
  bool _showWheel = true;
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Faster animation
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _soundService.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;

    // Play spin sound
    _soundService.playSpinSound();

    setState(() {
      _isSpinning = true;
      _selectedCategory = null;
      _showWheel = true;
    });

    final random = Random();
    final rotations = 3 + random.nextInt(3);
    final finalAngle = random.nextDouble() * 2 * pi;

    _animation = Tween<double>(
      begin: 0,
      end: rotations * 2 * pi + finalAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.reset();
    _controller.forward().then((_) {
      final normalizedAngle = finalAngle % (2 * pi);
      final sectionAngle = (2 * pi) / _categories.length;
      final selectedIndex =
          ((2 * pi - normalizedAngle) / sectionAngle).floor() %
          _categories.length;

      // Stop spin sound and play result sound
      _soundService.stopSpinSound();
      _soundService.playResultSound();

      setState(() {
        _selectedCategory = _categories[selectedIndex];
        _isSpinning = false;
        _showWheel = false;
      });
    });
  }

  void _startGame() {
    if (_selectedCategory != null) {
      _soundService.playClickSound();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  SimpleGameScreen(selectedCategory: _selectedCategory),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade600,
              Colors.purple.shade700,
              Colors.pink.shade600,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          _soundService.playClickSound();
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Text(
                          '🎰 Spin the Wheel',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Sound toggle button
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _soundService.soundEnabled
                                ? Icons.volume_up
                                : Icons.volume_off,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          _soundService.playClickSound();
                          setState(() {
                            _soundService.toggleSound();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Main content area
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child:
                          _showWheel
                              ? _buildSpinWheel()
                              : _buildResultDisplay(),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withAlpha(100),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSpinning ? null : _spinWheel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSpinning ? Icons.autorenew : Icons.casino,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _isSpinning ? 'Spinning...' : 'Spin Wheel',
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
                    if (_selectedCategory != null && !_showWheel) ...[
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedCategory!.color.withAlpha(150),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCategory!.color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.play_arrow, size: 24),
                                const SizedBox(width: 10),
                                Text(
                                  'Start Game',
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the spin wheel widget
  Widget _buildSpinWheel() {
    return Container(
      key: const ValueKey('wheel'),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha(50),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Colors.purple.withAlpha(100),
            blurRadius: 50,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(100), width: 3),
            ),
          ),

          // Wheel with enhanced shadow
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: WheelPainter(_categories),
                  ),
                ),
              );
            },
          ),

          // Enhanced center circle with gradient
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade100],
              ),
              border: Border.all(color: Colors.grey.shade300, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isSpinning ? Icons.autorenew : Icons.play_arrow,
              color: Colors.purple.shade600,
              size: 35,
            ),
          ),

          // Enhanced pointer with shadow
          Positioned(
            top: 15,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 15, color: Colors.transparent),
                    right: BorderSide(width: 15, color: Colors.transparent),
                    bottom: BorderSide(width: 35, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the result display widget
  Widget _buildResultDisplay() {
    if (_selectedCategory == null) return const SizedBox.shrink();

    return Container(
      key: const ValueKey('result'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _selectedCategory!.color.withAlpha(200),
              _selectedCategory!.color.withAlpha(100),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(150), width: 2),
          boxShadow: [
            BoxShadow(
              color: _selectedCategory!.color.withAlpha(100),
              blurRadius: 20,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon with pulse effect
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.8, end: 1.2),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(50),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      _selectedCategory!.icon,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              '🎉 ${_selectedCategory!.name.toUpperCase()} 🎉',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedCategory!.description,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white.withAlpha(230),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<Category> categories;

  WheelPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sectionAngle = (2 * pi) / categories.length;

    for (int i = 0; i < categories.length; i++) {
      final startAngle = i * sectionAngle - pi / 2;

      // Create gradient for each section
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          categories[i].color.withAlpha(255),
          categories[i].color.withAlpha(200),
        ],
        stops: const [0.6, 1.0],
      );

      final paint =
          Paint()
            ..shader = gradient.createShader(
              Rect.fromCircle(center: center, radius: radius),
            )
            ..style = PaintingStyle.fill;

      // Draw section with gradient
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngle,
        true,
        paint,
      );

      // Draw enhanced border
      final borderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngle,
        true,
        borderPaint,
      );

      // Draw category name with better styling
      final textAngle = startAngle + sectionAngle / 2;
      final textRadius = radius * 0.6;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: categories[i].name.toUpperCase(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            shadows: [
              const Shadow(
                color: Colors.black,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
