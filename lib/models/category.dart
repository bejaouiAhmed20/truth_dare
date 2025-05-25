import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });

  // Predefined categories
  static List<Category> getPredefinedCategories() {
    return [
      const Category(
        id: 'soft',
        name: 'Soft',
        icon: Icons.cloud,
        color: Colors.blue,
        description: 'Gentle and easy questions and challenges',
      ),
      const Category(
        id: 'hard',
        name: 'Hard',
        icon: Icons.fitness_center,
        color: Colors.orange,
        description: 'More challenging and difficult dares',
      ),
      const Category(
        id: 'hot',
        name: 'Hot',
        icon: Icons.whatshot,
        color: Colors.red,
        description: 'Spicy and exciting challenges',
      ),
      const Category(
        id: 'romantic',
        name: 'Romantic',
        icon: Icons.favorite,
        color: Colors.pink,
        description: 'Romantic questions and challenges for couples',
      ),
      const Category(
        id: 'extreme',
        name: 'Extreme',
        icon: Icons.bolt,
        color: Colors.purple,
        description: 'The most daring and extreme challenges',
      ),
    ];
  }
}
