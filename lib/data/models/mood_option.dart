import 'package:flutter/material.dart';

// Mood Option Model
// Data model for mood selection with emoji, name, and color

class MoodOption {
  final String emoji;
  final String name;
  final Color color;

  MoodOption({
    required this.emoji,
    required this.name,
    required this.color,
  });

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'name': name,
      'color': color.value,
    };
  }

  // Create from JSON response
  factory MoodOption.fromJson(Map<String, dynamic> json) {
    return MoodOption(
      emoji: json['emoji'] ?? '',
      name: json['name'] ?? '',
      color: Color(json['color'] ?? 0xFF000000),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodOption &&
        other.emoji == emoji &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => emoji.hashCode ^ name.hashCode ^ color.hashCode;

  @override
  String toString() {
    return 'MoodOption(emoji: $emoji, name: $name, color: $color)';
  }
}
