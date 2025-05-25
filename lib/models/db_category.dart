class DbCategory {
  final String id;
  final String name;
  final String description;
  final int difficulty;
  final DateTime createdAt;

  DbCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.createdAt,
  });

  factory DbCategory.fromJson(Map<String, dynamic> json) {
    return DbCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
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
