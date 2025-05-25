class Emotion {
  final String id;
  final String emoji;
  final String name;
  final String category;
  final String userName;
  final DateTime timestamp;

  Emotion({
    required this.id,
    required this.emoji,
    required this.name,
    required this.category,
    required this.userName,
    required this.timestamp,
  });

  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      id: json['id'] ?? '',
      emoji: json['emoji'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      userName: json['user_name'] ?? '',
      timestamp: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emoji': emoji,
      'name': name,
      'category': category,
      'user_name': userName,
      'created_at': timestamp.toIso8601String(),
    };
  }
}

class EmotionCategory {
  final String name;
  final List<EmotionData> emotions;

  EmotionCategory({required this.name, required this.emotions});
}

class EmotionData {
  final String emoji;
  final String name;

  EmotionData({required this.emoji, required this.name});
}

// Predefined emotion categories and data
class EmotionConstants {
  static final List<EmotionCategory> categories = [
    EmotionCategory(
      name: '😄 Positive Emotions',
      emotions: [
        EmotionData(emoji: '😊', name: 'Happy'),
        EmotionData(emoji: '😍', name: 'Loving'),
        EmotionData(emoji: '😌', name: 'Content'),
        EmotionData(emoji: '🤩', name: 'Excited'),
        EmotionData(emoji: '😁', name: 'Joyful'),
        EmotionData(emoji: '🥳', name: 'Celebratory'),
        EmotionData(emoji: '😄', name: 'Cheerful'),
        EmotionData(emoji: '🤗', name: 'Grateful'),
        EmotionData(emoji: '😇', name: 'Blessed'),
        EmotionData(emoji: '🥰', name: 'Adored'),
      ],
    ),
    EmotionCategory(
      name: '😢 Negative Emotions',
      emotions: [
        EmotionData(emoji: '😭', name: 'Sad'),
        EmotionData(emoji: '💔', name: 'Heartbroken'),
        EmotionData(emoji: '😞', name: 'Disappointed'),
        EmotionData(emoji: '😔', name: 'Lonely'),
        EmotionData(emoji: '😢', name: 'Crying'),
        EmotionData(emoji: '😿', name: 'Devastated'),
        EmotionData(emoji: '😩', name: 'Overwhelmed'),
        EmotionData(emoji: '😫', name: 'Exhausted'),
        EmotionData(emoji: '😪', name: 'Tired'),
        EmotionData(emoji: '🥺', name: 'Vulnerable'),
      ],
    ),
    EmotionCategory(
      name: '😡 Anger-Related Emotions',
      emotions: [
        EmotionData(emoji: '😠', name: 'Angry'),
        EmotionData(emoji: '😤', name: 'Frustrated'),
        EmotionData(emoji: '😒', name: 'Annoyed'),
        EmotionData(emoji: '😡', name: 'Enraged'),
        EmotionData(emoji: '🤬', name: 'Furious'),
        EmotionData(emoji: '😾', name: 'Grumpy'),
        EmotionData(emoji: '🙄', name: 'Irritated'),
        EmotionData(emoji: '😤', name: 'Huffing'),
        EmotionData(emoji: '💢', name: 'Explosive'),
        EmotionData(emoji: '🔥', name: 'Heated'),
      ],
    ),
    EmotionCategory(
      name: '😨 Fear & Anxiety',
      emotions: [
        EmotionData(emoji: '😱', name: 'Scared'),
        EmotionData(emoji: '😰', name: 'Anxious'),
        EmotionData(emoji: '😟', name: 'Worried'),
        EmotionData(emoji: '😬', name: 'Nervous'),
        EmotionData(emoji: '😨', name: 'Fearful'),
        EmotionData(emoji: '😧', name: 'Anguished'),
        EmotionData(emoji: '🫨', name: 'Shaking'),
        EmotionData(emoji: '😵‍💫', name: 'Dizzy'),
        EmotionData(emoji: '🤢', name: 'Nauseous'),
        EmotionData(emoji: '😓', name: 'Stressed'),
      ],
    ),
    EmotionCategory(
      name: '😳 Surprise & Shock',
      emotions: [
        EmotionData(emoji: '😲', name: 'Surprised'),
        EmotionData(emoji: '😮', name: 'Shocked'),
        EmotionData(emoji: '🤯', name: 'Stunned'),
        EmotionData(emoji: '😵', name: 'Baffled'),
        EmotionData(emoji: '😳', name: 'Flustered'),
        EmotionData(emoji: '🫢', name: 'Gasping'),
        EmotionData(emoji: '😯', name: 'Amazed'),
        EmotionData(emoji: '🤭', name: 'Giggling'),
        EmotionData(emoji: '😦', name: 'Bewildered'),
        EmotionData(emoji: '😧', name: 'Startled'),
      ],
    ),
    EmotionCategory(
      name: '❤️‍🔥 Love & Desire',
      emotions: [
        EmotionData(emoji: '🥰', name: 'Romantic'),
        EmotionData(emoji: '😈', name: 'Flirtatious'),
        EmotionData(emoji: '🫦', name: 'Horny'),
        EmotionData(emoji: '🔥', name: 'Desirous'),
        EmotionData(emoji: '😘', name: 'Kissing'),
        EmotionData(emoji: '💋', name: 'Passionate'),
        EmotionData(emoji: '😏', name: 'Seductive'),
        EmotionData(emoji: '🤤', name: 'Craving'),
        EmotionData(emoji: '💕', name: 'Affectionate'),
        EmotionData(emoji: '💖', name: 'Smitten'),
      ],
    ),
    EmotionCategory(
      name: '😐 Neutral or Mixed Emotions',
      emotions: [
        EmotionData(emoji: '😐', name: 'Indifferent'),
        EmotionData(emoji: '😶', name: 'Numb'),
        EmotionData(emoji: '😕', name: 'Confused'),
        EmotionData(emoji: '😒', name: 'Bored'),
        EmotionData(emoji: '🤔', name: 'Thinking'),
        EmotionData(emoji: '😑', name: 'Blank'),
        EmotionData(emoji: '🫤', name: 'Meh'),
        EmotionData(emoji: '😴', name: 'Sleepy'),
        EmotionData(emoji: '🤷', name: 'Unsure'),
        EmotionData(emoji: '😶‍🌫️', name: 'Foggy'),
      ],
    ),
  ];
}
