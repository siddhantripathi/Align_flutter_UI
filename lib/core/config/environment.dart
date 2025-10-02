class Environment {
  // API Configuration
  static const String alignApiKey = String.fromEnvironment(
    '0181633b1ae2cb31e6763acae61b392f4e712048673375215afaf19fb4e8435e',
    defaultValue: '0181633b1ae2cb31e6763acae61b392f4e712048673375215afaf19fb4e8435e', // Temporary API key for testing - update your backend .env file
  );
  
  static const String baseUrl = 'https://dev.lifestages.us';
  
  // Firebase Configuration (these will be loaded from firebase config files)
  static const String firebaseProjectId = 'lifestages-app';
  
  // Development flags
  static const bool isDevelopment = bool.fromEnvironment('DEBUG', defaultValue: true);
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  
}
