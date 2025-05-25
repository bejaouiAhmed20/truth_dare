class Challenge {
  final String id;
  final String type; // 'truth' or 'dare'
  final String content;
  final String categoryId;
  final String forGender; // 'male', 'female', or 'any'
  final bool coupleOnly;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.type,
    required this.content,
    required this.categoryId,
    required this.forGender,
    required this.coupleOnly,
    required this.createdAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      categoryId: json['category_id'] as String,
      forGender: json['for_gender'] as String,
      coupleOnly: json['couple_only'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}
