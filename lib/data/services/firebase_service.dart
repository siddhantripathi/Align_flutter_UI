import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wellness_module.dart';

// Firebase Service
// Service for interacting with Firebase Firestore for wellness modules

class FirebaseService {
  // TODO: Replace with your actual Firebase project URL
  static const String _baseUrl = 'https://lifestages-app-default-rtdb.firebaseio.com';
  
  // TODO: Add your Firebase API key here
  static const String _apiKey = 'YOUR_FIREBASE_API_KEY_HERE';
  
  // Get wellness modules by type (practice or learn)
  Future<List<WellnessModule>> getWellnessModules(String type) async {
    // For now, always return mock data since Firebase is not set up
    // TODO: Uncomment the Firebase code below when Firebase is properly configured
    
    /*
    try {
      final url = '$_baseUrl/wellness_modules/$type.json?auth=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);
        if (data == null) return _getMockWellnessModules(type);
        
        return data.entries.map((entry) {
          final moduleData = entry.value as Map<String, dynamic>;
          moduleData['id'] = entry.key;
          return WellnessModule.fromJson(moduleData);
        }).toList();
      } else {
        return _getMockWellnessModules(type);
      }
    } catch (e) {
      print('Error fetching wellness modules: $e');
      return _getMockWellnessModules(type);
    }
    */
    
    // Return mock data for development
    return _getMockWellnessModules(type);
  }
  
  // Get specific wellness module by ID
  Future<WellnessModule?> getWellnessModule(String type, String moduleId) async {
    try {
      final url = '$_baseUrl/wellness_modules/$type/$moduleId.json?auth=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);
        if (data == null) return null;
        
        data['id'] = moduleId;
        return WellnessModule.fromJson(data);
      } else {
        throw Exception('Failed to load wellness module: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wellness module: $e');
      return null;
    }
  }
  
  // Save user progress for a module
  Future<bool> saveModuleProgress(String userId, String moduleId, double progress) async {
    try {
      final url = '$_baseUrl/user_progress/$userId/$moduleId.json?auth=$_apiKey';
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'progress': progress,
          'lastAccessed': DateTime.now().toIso8601String(),
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error saving module progress: $e');
      return false;
    }
  }
  
  // Get user progress for modules
  Future<Map<String, double>> getUserProgress(String userId) async {
    try {
      final url = '$_baseUrl/user_progress/$userId.json?auth=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);
        if (data == null) return {};
        
        return data.map((key, value) => MapEntry(
          key,
          (value['progress'] as num?)?.toDouble() ?? 0.0,
        ));
      }
      
      return {};
    } catch (e) {
      print('Error fetching user progress: $e');
      return {};
    }
  }
  
  // Mock data for development/testing
  List<WellnessModule> _getMockWellnessModules(String type) {
    if (type == 'practice') {
      return [
        // Recommended for you
        WellnessModule(
          id: 'guided_meditation',
          title: 'Guided meditation',
          description: 'Peaceful meditation session',
          contentType: ContentType.guidedAudio,
          category: WellnessCategory.recommended,
          imageUrl: 'https://example.com/lake_sunset.jpg', // TODO: Replace with actual image URLs
          durationMinutes: 15,
          activities: [
            WellnessActivity(
              id: 'breathing_exercise',
              title: 'Breathing Exercise',
              description: 'This activity will help you relieve stress and become mindful of your body as you focus on your breathing.',
              durationMinutes: 2,
              audioUrl: 'https://example.com/breathing_audio.mp3', // TODO: Replace with actual audio URL
            ),
          ],
        ),
        WellnessModule(
          id: 'understanding_grief',
          title: 'Understanding Grief',
          description: 'Learn about processing grief',
          contentType: ContentType.article,
          category: WellnessCategory.recommended,
          imageUrl: 'https://example.com/hillside_flowers.jpg', // TODO: Replace with actual image URL
        ),
        
        // Mindfulness
        WellnessModule(
          id: 'breathing_exercise_2',
          title: 'Breathing Exercise',
          description: 'Focus on your breath',
          contentType: ContentType.guidedAudio,
          category: WellnessCategory.mindfulness,
          imageUrl: 'https://example.com/wildflowers.jpg', // TODO: Replace with actual image URL
        ),
        WellnessModule(
          id: 'body_scan',
          title: 'Body Scan Squeeze',
          description: 'Full body relaxation',
          contentType: ContentType.guidedAudio,
          category: WellnessCategory.mindfulness,
          imageUrl: 'https://example.com/waterfall.jpg', // TODO: Replace with actual image URL
          isLocked: true,
          isStarred: true,
        ),
        
        // Self-Alignment
        WellnessModule(
          id: 'personal_growth_quiz',
          title: 'Personal Growth Quiz',
          description: 'Assess your personal development',
          contentType: ContentType.quiz,
          category: WellnessCategory.selfAlignment,
          imageUrl: 'https://example.com/rolling_hills.jpg', // TODO: Replace with actual image URL
        ),
        WellnessModule(
          id: 'coming_soon',
          title: 'Coming Soon',
          description: 'New content coming soon',
          contentType: ContentType.article,
          category: WellnessCategory.selfAlignment,
          isEmpty: true,
        ),
      ];
    }
    
    // Mock data for learn wellness
    if (type == 'learn') {
      return [
        // Recommended for you
        WellnessModule(
          id: 'understanding_emotions',
          title: 'Understanding Emotions',
          description: 'Learn about emotional intelligence',
          contentType: ContentType.article,
          category: WellnessCategory.recommended,
          imageUrl: 'https://example.com/emotions.jpg',
          activities: [
            WellnessActivity(
              id: 'emotion_basics',
              title: 'Emotion Basics',
              description: 'Understanding the fundamentals of emotions and how they affect our daily lives.',
              durationMinutes: 10,
              contentUrl: 'https://example.com/emotion_basics.html',
            ),
          ],
        ),
        WellnessModule(
          id: 'stress_management',
          title: 'Stress Management',
          description: 'Learn effective stress management techniques',
          contentType: ContentType.article,
          category: WellnessCategory.recommended,
          imageUrl: 'https://example.com/stress.jpg',
        ),
        
        // Mindfulness
        WellnessModule(
          id: 'mindfulness_basics',
          title: 'Mindfulness Basics',
          description: 'Introduction to mindfulness practices',
          contentType: ContentType.article,
          category: WellnessCategory.mindfulness,
          imageUrl: 'https://example.com/mindfulness.jpg',
        ),
        
        // Self-Alignment
        WellnessModule(
          id: 'self_discovery',
          title: 'Self Discovery',
          description: 'Journey of self-awareness and growth',
          contentType: ContentType.quiz,
          category: WellnessCategory.selfAlignment,
          imageUrl: 'https://example.com/self_discovery.jpg',
        ),
      ];
    }
    
    // Return empty list for other types
    return [];
  }
}
