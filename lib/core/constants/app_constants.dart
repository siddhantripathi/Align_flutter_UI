// App Constants
// All app-wide constants are defined here for easy maintenance

class AppConstants {
  // App Info
  static const String appName = 'Align';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:5001'; // Update this to your deployed URL
  static const String apiKeyHeader = 'X-API-Key';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(seconds: 1);
  static const Duration earthAnimationDuration = Duration(seconds: 4);
  
  // UI Constants
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 32.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  
  // Check-in Flow
  static const int exitConfirmationDuration = 3; // seconds
  
  // AI Coach
  static const int defaultConversationsLeft = 80;
  
  // Wellness
  static const int defaultWellnessModules = 10;
}
