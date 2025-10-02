import '../models/checkin_data.dart';
import '../models/mood_option.dart';
import '../models/wellness_activity.dart';
import '../services/api_service.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Check-in Repository
// Repository pattern for check-in related data operations

class CheckinRepository {
  final ApiService _apiService;
  
  CheckinRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  // Get available moods
  List<MoodOption> getMoodOptions() {
    return [
      MoodOption(
        emoji: '😐',
        name: 'Neutral',
        color: AppColors.moodNeutral,
      ),
      MoodOption(
        emoji: '😊',
        name: 'Happy',
        color: AppColors.moodHappy,
      ),
      MoodOption(
        emoji: '😠',
        name: 'Angry',
        color: AppColors.moodAngry,
      ),
      MoodOption(
        emoji: '😢',
        name: 'Sad',
        color: AppColors.moodSad,
      ),
      MoodOption(
        emoji: '😴',
        name: 'Tired',
        color: AppColors.moodTired,
      ),
    ];
  }

  // Get available mood tags
  List<String> getMoodTags() {
    return [
      'Ecstatic', 'Optimistic', 'Confident', 'Joyful', 'Loving',
      'Strong', 'Playful', 'Generous', 'Inspired', 'Delighted',
      'Grateful', 'Peaceful', 'Energetic', 'Creative', 'Motivated',
      'Calm', 'Focused', 'Content', 'Excited', 'Proud'
    ];
  }

  // Get available wellness activities
  List<WellnessActivity> getWellnessActivities() {
    return [
      WellnessActivity(
        name: 'Therapy',
        icon: Icons.psychology,
        color: AppColors.wellnessTherapy,
      ),
      WellnessActivity(
        name: 'Exercise',
        icon: Icons.fitness_center,
        color: AppColors.wellnessExercise,
      ),
      WellnessActivity(
        name: 'Meditation',
        icon: Icons.self_improvement,
        color: AppColors.wellnessMeditation,
      ),
      WellnessActivity(
        name: 'Journaling',
        icon: Icons.edit_note,
        color: AppColors.wellnessJournaling,
      ),
    ];
  }

  // Get available social activities
  List<String> getSocialActivities() {
    return [
      'Coffee with friends', 'Family dinner', 'Team meeting', 'Date night',
      'Book club', 'Gym buddy', 'Phone call', 'Video chat'
    ];
  }

  // Save check-in data
  Future<bool> saveCheckinData(CheckinData checkinData) async {
    try {
      return await _apiService.saveCheckinData(checkinData);
    } catch (e) {
      // Log error or handle it appropriately
      print('Error saving check-in data: $e');
      return false;
    }
  }

  // Get check-in history (placeholder for future implementation)
  Future<List<CheckinData>> getCheckinHistory(String userId) async {
    // This would be implemented when the backend supports it
    return [];
  }

  // Get check-in analytics (placeholder for future implementation)
  Future<Map<String, dynamic>> getCheckinAnalytics(String userId) async {
    // This would be implemented when the backend supports it
    return {};
  }
}
