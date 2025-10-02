import 'package:flutter/material.dart';

// App Color Palette
// Centralized color management for consistent theming

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6B73FF);
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color primaryDark = Color(0xFF4A4A4A);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFFE8F5E8);
  
  // Accent Colors
  static const Color accent = Color(0xFFFFB6C1); // Light pink
  static const Color accentDark = Color(0xFFFF9800); // Orange
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentTeal = Color(0xFF4DB6AC);
  
  // Background Colors
  static const Color background = Colors.white;
  static const Color backgroundDark = Color(0xFF2C2C2C);
  static const Color backgroundLight = Color(0xFFFFFEF3);
  static const Color cardBackground = Color(0xFFFFE4E6);
  
  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textLight = Colors.white;
  static const Color textHint = Color(0xFF515041);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Colors.red;
  static const Color info = Color(0xFF2196F3);
  
  // Mood Colors
  static const Color moodNeutral = Colors.grey;
  static const Color moodHappy = Colors.yellow;
  static const Color moodAngry = Colors.red;
  static const Color moodSad = Colors.blue;
  static const Color moodTired = Colors.purple;
  
  // Wellness Activity Colors
  static const Color wellnessTherapy = Colors.purple;
  static const Color wellnessExercise = Colors.green;
  static const Color wellnessMeditation = Colors.pink;
  static const Color wellnessJournaling = Colors.orange;
  
  // Utility Colors
  static Color shadow = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color overlay = Colors.black.withOpacity(0.3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
