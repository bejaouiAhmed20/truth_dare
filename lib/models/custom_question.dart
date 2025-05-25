class CustomQuestion {
  final String id;
  final String text;
  final String type; // 'truth' or 'dare'
  final String category; // 'soft', 'hard', 'hot', 'romantic', 'extreme'
  final String targetGender; // 'male', 'female', or 'both'
  final DateTime createdAt;

  CustomQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.category,
    required this.targetGender,
    required this.createdAt,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'category': category,
      'targetGender': targetGender,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map for retrieval
  factory CustomQuestion.fromMap(Map<String, dynamic> map) {
    return CustomQuestion(
      id: map['id'],
      text: map['text'],
      type: map['type'],
      category: map['category'],
      targetGender: map['targetGender'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
