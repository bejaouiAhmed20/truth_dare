/// Player model representing a user in the game
class Player {
  final String id;
  final String name;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;

  Player({
    required this.id,
    required this.name,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_path': imagePath,
    };
  }
}

/// Game session model representing a game instance
class GameSession {
  final String id;
  final String sessionName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? endedAt;
  final Map<String, dynamic> settings;

  GameSession({
    required this.id,
    required this.sessionName,
    required this.createdAt,
    required this.updatedAt,
    this.endedAt,
    required this.settings,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'],
      sessionName: json['session_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      endedAt:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      settings: json['settings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_name': sessionName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'settings': settings,
    };
  }
}

/// Category model representing a challenge category
class GameCategory {
  final String id;
  final String name;
  final String? description;
  final int difficulty;
  final DateTime createdAt;

  GameCategory({
    required this.id,
    required this.name,
    this.description,
    required this.difficulty,
    required this.createdAt,
  });

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Challenge model representing a truth or dare challenge
class Challenge {
  final String id;
  final String type; // 'truth' or 'dare'
  final String content;
  final String categoryId;
  final String? forGender;
  final bool coupleOnly;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Challenge({
    required this.id,
    required this.type,
    required this.content,
    required this.categoryId,
    this.forGender,
    required this.coupleOnly,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      type: json['type'],
      content: json['content'],
      categoryId: json['category_id'],
      forGender: json['for_gender'],
      coupleOnly: json['couple_only'],
      usageCount: json['usage_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'category_id': categoryId,
      'for_gender': forGender,
      'couple_only': coupleOnly,
      'usage_count': usageCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Custom challenge model representing user-created challenges
class CustomChallenge {
  final String id;
  final String type; // 'truth' or 'dare'
  final String content;
  final String createdBy;
  final String? forGender;
  final String? categoryId;
  final bool coupleOnly;
  final DateTime createdAt;

  CustomChallenge({
    required this.id,
    required this.type,
    required this.content,
    required this.createdBy,
    this.forGender,
    this.categoryId,
    required this.coupleOnly,
    required this.createdAt,
  });

  factory CustomChallenge.fromJson(Map<String, dynamic> json) {
    return CustomChallenge(
      id: json['id'],
      type: json['type'],
      content: json['content'],
      createdBy: json['created_by'],
      forGender: json['for_gender'],
      categoryId: json['category_id'],
      coupleOnly: json['couple_only'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'created_by': createdBy,
      'for_gender': forGender,
      'category_id': categoryId,
      'couple_only': coupleOnly,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Challenge history model representing a record of a challenge being used
class ChallengeHistory {
  final String id;
  final String challengeId;
  final String sessionId;
  final String playerId;
  final bool completed;
  final bool skipped;
  final DateTime timestamp;

  ChallengeHistory({
    required this.id,
    required this.challengeId,
    required this.sessionId,
    required this.playerId,
    required this.completed,
    required this.skipped,
    required this.timestamp,
  });

  factory ChallengeHistory.fromJson(Map<String, dynamic> json) {
    return ChallengeHistory(
      id: json['id'],
      challengeId: json['challenge_id'],
      sessionId: json['session_id'],
      playerId: json['player_id'],
      completed: json['completed'],
      skipped: json['skipped'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'session_id': sessionId,
      'player_id': playerId,
      'completed': completed,
      'skipped': skipped,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
