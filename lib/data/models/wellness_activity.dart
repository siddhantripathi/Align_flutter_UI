import 'package:flutter/material.dart';

// Wellness Activity Model
// Data model for wellness activities with icon and color

class WellnessActivity {
  final String name;
  final IconData icon;
  final Color color;

  WellnessActivity({
    required this.name,
    required this.icon,
    required this.color,
  });

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'color': color.value,
    };
  }

  // Create from JSON response
  factory WellnessActivity.fromJson(Map<String, dynamic> json) {
    return WellnessActivity(
      name: json['name'] ?? '',
      icon: IconData(
        json['iconCodePoint'] ?? Icons.help.codePoint,
        fontFamily: json['iconFontFamily'],
      ),
      color: Color(json['color'] ?? 0xFF000000),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WellnessActivity &&
        other.name == name &&
        other.icon == icon &&
        other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ color.hashCode;

  @override
  String toString() {
    return 'WellnessActivity(name: $name, icon: $icon, color: $color)';
  }
}
