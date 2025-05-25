import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/emotion.dart';
import '../services/emotion_service.dart';
import '../services/sound_service.dart';
import '../services/notification_service.dart';
import 'dart:async';

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({super.key});

  @override
  State<EmotionsScreen> createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  final EmotionService _emotionService = EmotionService();
  final SoundService _soundService = SoundService();
  bool _isLoading = false;
  List<Emotion> _recentEmotions = [];
  Stream<List<Emotion>>? _emotionStream;
  StreamSubscription<List<Emotion>>? _emotionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeEmotions();
  }

  Future<void> _initializeEmotions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize the emotions table
      await _emotionService.initializeEmotionsTable();

      // Set up real-time listener
      _emotionStream = _emotionService.listenToEmotions();

      // Listen for new emotions and show notifications
      _emotionSubscription = _emotionStream!.listen((emotions) {
        if (_recentEmotions.isNotEmpty && emotions.isNotEmpty) {
          // Check for new emotions
          final newEmotions =
              emotions.where((emotion) {
                return !_recentEmotions.any(
                  (existing) => existing.id == emotion.id,
                );
              }).toList();

          // Show notifications for new emotions
          for (final emotion in newEmotions) {
            if (mounted) {
              NotificationService.showEmotionNotification(context, emotion);
            }
          }
        }

        // Update the recent emotions list
        setState(() {
          _recentEmotions = emotions;
        });
      });

      // Load initial emotions
      _recentEmotions = await _emotionService.getRecentEmotions();
    } catch (e) {
      if (kDebugMode) print('Failed to initialize emotions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emotionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _shareEmotion(EmotionData emotionData, String category) async {
    _soundService.playClickSound();

    // Show user selection dialog
    final selectedUser = await _showUserSelectionDialog();
    if (selectedUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _emotionService.shareEmotion(
        emoji: emotionData.emoji,
        name: emotionData.name,
        category: category,
        userName: selectedUser,
      );

      // Play success sound
      _soundService.playResultSound();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(emotionData.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text('$selectedUser is feeling ${emotionData.name}!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share emotion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _showUserSelectionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Who is feeling this emotion?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouhmid option
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('assets/ahmed.jpg'),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                title: Text(
                  'Bouhmid',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Male',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600),
                ),
                onTap: () {
                  _soundService.playClickSound();
                  Navigator.of(context).pop('Bouhmid');
                },
              ),
              const Divider(),
              // Marouma option
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('assets/maram.jpg'),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person, color: Colors.pink),
                ),
                title: Text(
                  'Marouma',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Female',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600),
                ),
                onTap: () {
                  _soundService.playClickSound();
                  Navigator.of(context).pop('Marouma');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _soundService.playClickSound();
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Share Your Emotions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              _soundService.playClickSound();
              _showRecentEmotions();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(40),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '💝 How are you feeling?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fade(duration: 600.ms)
                            .slideY(begin: -0.2, end: 0),

                        const SizedBox(height: 20),

                        // Emotions List
                        Expanded(
                          child: ListView.builder(
                            itemCount: EmotionConstants.categories.length,
                            itemBuilder: (context, index) {
                              final category =
                                  EmotionConstants.categories[index];
                              return _buildEmotionCategory(category, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildEmotionCategory(EmotionCategory category, int categoryIndex) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  category.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Emotions Grid
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: category.emotions.length,
                  itemBuilder: (context, index) {
                    final emotion = category.emotions[index];
                    return _buildEmotionButton(emotion, category.name);
                  },
                ),
              ),
            ],
          ),
        )
        .animate(delay: (categoryIndex * 100).ms)
        .fade(duration: 600.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildEmotionButton(EmotionData emotion, String category) {
    return Material(
      color: Colors.white.withAlpha(60),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _shareEmotion(emotion, category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(100)),
          ),
          child: Row(
            children: [
              Text(emotion.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emotion.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecentEmotions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildRecentEmotionsSheet(),
    );
  }

  Widget _buildRecentEmotionsSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Recent Emotions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Emotions List
          Expanded(
            child: StreamBuilder<List<Emotion>>(
              stream: _emotionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final emotions = snapshot.data ?? [];

                if (emotions.isEmpty) {
                  return Center(
                    child: Text(
                      'No emotions shared yet',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: emotions.length,
                  itemBuilder: (context, index) {
                    final emotion = emotions[index];
                    return _buildEmotionTile(emotion);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionTile(Emotion emotion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(emotion.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${emotion.userName} is feeling ${emotion.name}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatTime(emotion.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
