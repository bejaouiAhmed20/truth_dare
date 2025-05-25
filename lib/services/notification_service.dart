import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/emotion.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal() {
    _initializeNotifications();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Initialize local notifications
  Future<void> _initializeNotifications() async {
    if (_isInitialized) return;

    try {
      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Combined initialization settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      // Initialize the plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for Android 13+
      await _requestPermissions();

      _isInitialized = true;
      if (kDebugMode) {
        print(
          'NotificationService: Local notifications initialized successfully',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Failed to initialize notifications: $e');
      }
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Failed to request permissions: $e');
      }
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      print(
        'NotificationService: Notification tapped: ${notificationResponse.payload}',
      );
    }
    // Handle notification tap here if needed
  }

  // Show local notification (phone notification)
  Future<void> showLocalNotification(Emotion emotion) async {
    if (!_isInitialized) {
      await _initializeNotifications();
    }

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'emotions_channel',
            'Emotion Notifications',
            channelDescription: 'Notifications for shared emotions',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        emotion.hashCode, // Use emotion hashCode as unique ID
        '${emotion.emoji} ${emotion.userName} is feeling ${emotion.name}',
        _formatCategory(emotion.category),
        platformChannelSpecifics,
        payload: emotion.id,
      );

      if (kDebugMode) {
        print('NotificationService: Local notification sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Failed to show local notification: $e');
      }
    }
  }

  // Show emotion notification (both overlay and local notification)
  static void showEmotionNotification(BuildContext context, Emotion emotion) {
    if (kDebugMode) {
      print(
        'NotificationService: Showing notification for ${emotion.userName} feeling ${emotion.name}',
      );
    }

    // Show local notification (phone notification)
    NotificationService()._showLocalNotificationSafely(emotion);

    // Create overlay entry for custom notification
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) =>
              _buildNotificationWidget(emotion, () => overlayEntry.remove()),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // Safe wrapper for showing local notifications
  void _showLocalNotificationSafely(Emotion emotion) {
    showLocalNotification(emotion).catchError((error) {
      if (kDebugMode) {
        print('NotificationService: Error showing local notification: $error');
      }
    });
  }

  static Widget _buildNotificationWidget(
    Emotion emotion,
    VoidCallback onDismiss,
  ) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getEmotionColor(emotion.category).withOpacity(0.9),
                _getEmotionColor(emotion.category).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emotion emoji
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    emotion.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${emotion.userName} is feeling ${emotion.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCategory(emotion.category),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _getEmotionColor(String category) {
    switch (category.toLowerCase()) {
      case '😄 positive emotions':
        return Colors.green;
      case '😢 negative emotions':
        return Colors.blue;
      case '😡 anger-related emotions':
        return Colors.red;
      case '😨 fear & anxiety':
        return Colors.orange;
      case '😳 surprise & shock':
        return Colors.purple;
      case '❤️‍🔥 love & desire':
        return Colors.pink;
      case '😐 neutral or mixed emotions':
        return Colors.grey;
      default:
        return Colors.indigo;
    }
  }

  static String _formatCategory(String category) {
    // Remove emoji from category name
    return category.replaceAll(RegExp(r'[^\w\s&]'), '').trim();
  }
}
