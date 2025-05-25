import 'package:flutter/material.dart';
import '../models/models.dart';

/// Utility class for player-related functions
class PlayerUtils {
  /// Get the correct player name regardless of what's in the database
  static String getPlayerName(Player? player) {
    if (player == null) return 'Player';

    // Always return the fixed names based on player ID or name
    final lowerName = player.name.toLowerCase();

    // Check if this is player 1 (Bouhmid/Ahmed)
    if (player.id == 'player_bouhmid' ||
        lowerName.contains('bouhmid') ||
        lowerName.contains('ahmed')) {
      return 'Bouhmid';
    }
    // Check if this is player 2 (Marouma/Maram)
    else if (player.id == 'player_marouma' ||
        lowerName.contains('marouma') ||
        lowerName.contains('maram')) {
      return 'Marouma';
    }
    // Fallback to the actual name in the database
    else {
      return player.name;
    }
  }

  /// Get the correct player image path regardless of what's in the database
  /// This method ensures proper asset path formatting for different platforms
  static String getPlayerImagePath(Player? player) {
    if (player == null) return 'assets/ahmed.jpg'; // Default image

    // Always return the fixed image paths based on player ID or name
    final lowerName = player.name.toLowerCase();
    String assetPath;

    // Check if this is player 1 (Bouhmid/Ahmed)
    if (player.id == 'player_bouhmid' ||
        lowerName.contains('bouhmid') ||
        lowerName.contains('ahmed')) {
      assetPath = 'assets/ahmed.jpg';
    }
    // Check if this is player 2 (Marouma/Maram)
    else if (player.id == 'player_marouma' ||
        lowerName.contains('marouma') ||
        lowerName.contains('maram')) {
      assetPath = 'assets/maram.jpg';
    }
    // Fallback to the image path in the database or default
    else if (player.imagePath != null && player.imagePath!.isNotEmpty) {
      assetPath = player.imagePath!;
    } else {
      // Default fallback
      assetPath = 'assets/ahmed.jpg';
    }

    // Ensure the asset path is correctly formatted
    return assetPath;
  }

  /// Check if player is Marouma (for hearts)
  static bool isMarouma(Player? player) {
    if (player == null) return false;

    final lowerName = player.name.toLowerCase();

    // Check if this is player 2 (Marouma/Maram)
    return player.id == 'player_marouma' ||
        lowerName.contains('marouma') ||
        lowerName.contains('maram');
  }

  /// Get a list of default players
  static List<Player> getDefaultPlayers() {
    final now = DateTime.now();
    return [
      Player(
        id: 'player_bouhmid',
        name: 'Bouhmid',
        gender: 'male',
        imagePath: 'assets/ahmed.jpg',
        createdAt: now,
        updatedAt: now,
      ),
      Player(
        id: 'player_marouma',
        name: 'Marouma',
        gender: 'female',
        imagePath: 'assets/maram.jpg',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Preload player images to ensure they're available when needed
  static Future<void> preloadPlayerImages(BuildContext context) async {
    // Store context state to avoid async gap issues
    final mounted = context.mounted;

    try {
      // Preload first image
      if (mounted) {
        await precacheImage(const AssetImage('assets/ahmed.jpg'), context);
      }

      // Check mounted again before second operation
      if (context.mounted) {
        await precacheImage(const AssetImage('assets/maram.jpg'), context);
      }
    } catch (e) {
      debugPrint('Error preloading player images: $e');
    }
  }

  /// Create an image widget with error handling for player images
  static Widget getPlayerImageWidget(
    Player? player, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final imagePath = getPlayerImagePath(player);

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading player image: $error');
        // Return a fallback icon if the image fails to load
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Icon(
            Icons.person,
            color: Colors.grey.shade700,
            size: (width ?? 40) * 0.6,
          ),
        );
      },
    );
  }
}
