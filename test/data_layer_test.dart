import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/data/models/mood_option.dart';
import 'package:align_app/data/models/checkin_data.dart';
import 'package:align_app/data/models/wellness_module.dart';
import 'package:align_app/data/models/wellness_module.dart' show WellnessActivity;
import 'package:align_app/data/models/chat_message.dart';
import 'package:align_app/data/services/firebase_service.dart';
import 'package:align_app/data/repositories/checkin_repository.dart';
import 'package:flutter/material.dart';

// Data Layer Tests
// Tests data models, services, and repositories for proper structure and behavior

void main() {
  group('Data Model Tests', () {
    
    group('MoodOption Model', () {
      test('MoodOption creates correctly with required fields', () {
        final mood = MoodOption(
          emoji: '😊',
          name: 'Happy',
          color: Colors.yellow,
        );

        expect(mood.emoji, equals('😊'));
        expect(mood.name, equals('Happy'));
        expect(mood.color, equals(Colors.yellow));
      });

      test('MoodOption toJson works correctly', () {
        final mood = MoodOption(
          emoji: '😊',
          name: 'Happy',
          color: Colors.yellow,
        );

        final json = mood.toJson();
        expect(json['emoji'], equals('😊'));
        expect(json['name'], equals('Happy'));
        expect(json['color'], equals(Colors.yellow.value));
      });

      test('MoodOption fromJson works correctly', () {
        final json = {
          'emoji': '😢',
          'name': 'Sad',
          'color': Colors.blue.value,
        };

        final mood = MoodOption.fromJson(json);
        expect(mood.emoji, equals('😢'));
        expect(mood.name, equals('Sad'));
        expect(mood.color, equals(Colors.blue));
      });

      test('MoodOption equality works correctly', () {
        final mood1 = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
        final mood2 = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
        final mood3 = MoodOption(emoji: '😢', name: 'Sad', color: Colors.blue);

        expect(mood1, equals(mood2));
        expect(mood1, isNot(equals(mood3)));
      });
    });

    group('WellnessActivity Model', () {
      test('WellnessActivity creates with all fields', () {
        final activity = WellnessActivity(
          name: 'Meditation',
          icon: Icons.self_improvement,
          color: Colors.purple,
        );

        expect(activity.name, equals('Meditation'));
        expect(activity.icon, equals(Icons.self_improvement));
        expect(activity.color, equals(Colors.purple));
      });

      test('WellnessActivity JSON serialization works', () {
        final activity = WellnessActivity(
          name: 'Exercise',
          icon: Icons.fitness_center,
          color: Colors.green,
        );

        final json = activity.toJson();
        expect(json['name'], equals('Exercise'));
        expect(json['iconCodePoint'], equals(Icons.fitness_center.codePoint));
        expect(json['color'], equals(Colors.green.value));

        final recreated = WellnessActivity.fromJson(json);
        expect(recreated.name, equals('Exercise'));
        expect(recreated.color, equals(Colors.green));
      });
    });

    group('CheckinData Model', () {
      test('CheckinData creates with all required fields', () {
        final mood = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
        final checkin = CheckinData(
          selectedMood: mood,
          selectedMoodTags: ['Confident', 'Joyful'],
          selectedWellness: ['Meditation'],
          selectedSocial: ['Coffee with friends'],
          additionalNotes: 'Great day!',
        );

        expect(checkin.selectedMood, equals(mood));
        expect(checkin.selectedMoodTags, contains('Confident'));
        expect(checkin.selectedWellness, contains('Meditation'));
        expect(checkin.selectedSocial, contains('Coffee with friends'));
        expect(checkin.additionalNotes, equals('Great day!'));
        expect(checkin.timestamp, isA<DateTime>());
      });

      test('CheckinData copyWith works correctly', () {
        final mood = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
        final original = CheckinData(
          selectedMood: mood,
          selectedMoodTags: ['Happy'],
          selectedWellness: [],
          selectedSocial: [],
        );

        final updated = original.copyWith(
          selectedMoodTags: ['Happy', 'Excited'],
          additionalNotes: 'Updated notes',
        );

        expect(updated.selectedMoodTags, contains('Excited'));
        expect(updated.additionalNotes, equals('Updated notes'));
        expect(updated.selectedMood, equals(original.selectedMood));
      });

      test('CheckinData JSON serialization works', () {
        final mood = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
        final checkin = CheckinData(
          selectedMood: mood,
          selectedMoodTags: ['Happy'],
          selectedWellness: ['Meditation'],
          selectedSocial: [],
        );

        final json = checkin.toJson();
        expect(json['selectedMoodTags'], contains('Happy'));
        expect(json['selectedWellness'], contains('Meditation'));
        expect(json['timestamp'], isA<String>());

        final recreated = CheckinData.fromJson(json);
        expect(recreated.selectedMoodTags, contains('Happy'));
        expect(recreated.selectedWellness, contains('Meditation'));
      });
    });

    group('WellnessModule Model', () {
      test('WellnessModule creates with required fields', () {
        final module = WellnessModule(
          id: 'test_module',
          title: 'Test Module',
          description: 'Test Description',
          contentType: ContentType.guidedAudio,
          category: WellnessCategory.mindfulness,
        );

        expect(module.id, equals('test_module'));
        expect(module.title, equals('Test Module'));
        expect(module.contentType, equals(ContentType.guidedAudio));
        expect(module.category, equals(WellnessCategory.mindfulness));
        expect(module.isLocked, isFalse);
        expect(module.isEmpty, isFalse);
      });

      test('WellnessModule JSON serialization works', () {
        final activity = WellnessActivity(
          id: 'activity1',
          title: 'Activity Title',
          description: 'Activity Description',
          durationMinutes: 5,
        );

        final module = WellnessModule(
          id: 'module1',
          title: 'Module Title',
          description: 'Module Description',
          contentType: ContentType.article,
          category: WellnessCategory.recommended,
          activities: [activity],
          isLocked: true,
        );

        final json = module.toJson();
        expect(json['id'], equals('module1'));
        expect(json['contentType'], equals('article'));
        expect(json['category'], equals('recommended'));
        expect(json['isLocked'], isTrue);
        expect(json['activities'], hasLength(1));

        final recreated = WellnessModule.fromJson(json);
        expect(recreated.id, equals('module1'));
        expect(recreated.contentType, equals(ContentType.article));
        expect(recreated.isLocked, isTrue);
        expect(recreated.activities, hasLength(1));
      });

      test('ContentType enum works correctly', () {
        expect(ContentType.values, hasLength(3));
        expect(ContentType.guidedAudio.name, equals('guidedAudio'));
        expect(ContentType.article.name, equals('article'));
        expect(ContentType.quiz.name, equals('quiz'));
      });

      test('WellnessCategory enum works correctly', () {
        expect(WellnessCategory.values, hasLength(3));
        expect(WellnessCategory.recommended.name, equals('recommended'));
        expect(WellnessCategory.mindfulness.name, equals('mindfulness'));
        expect(WellnessCategory.selfAlignment.name, equals('selfAlignment'));
      });
    });

    group('ChatMessage Model', () {
      test('ChatMessage creates correctly', () {
        final message = ChatMessage(
          text: 'Hello!',
          isUser: true,
        );

        expect(message.text, equals('Hello!'));
        expect(message.isUser, isTrue);
        expect(message.timestamp, isA<DateTime>());
      });

      test('ChatMessage JSON serialization works', () {
        final message = ChatMessage(
          text: 'Test message',
          isUser: false,
          id: 'msg1',
        );

        final json = message.toJson();
        expect(json['text'], equals('Test message'));
        expect(json['isUser'], isFalse);
        expect(json['id'], equals('msg1'));

        final recreated = ChatMessage.fromJson(json);
        expect(recreated.text, equals('Test message'));
        expect(recreated.isUser, isFalse);
        expect(recreated.id, equals('msg1'));
      });

      test('ChatMessage copyWith works', () {
        final original = ChatMessage(text: 'Original', isUser: true);
        final updated = original.copyWith(text: 'Updated');

        expect(updated.text, equals('Updated'));
        expect(updated.isUser, isTrue);
        expect(updated.timestamp, equals(original.timestamp));
      });
    });
  });

  group('Firebase Service Tests', () {
    
    test('FirebaseService returns mock data when Firebase unavailable', () async {
      final service = FirebaseService();
      
      // Test practice modules
      final practiceModules = await service.getWellnessModules('practice');
      expect(practiceModules, isNotEmpty);
      expect(practiceModules.first.id, isNotEmpty);
      expect(practiceModules.first.title, isNotEmpty);
      
      // Should have modules in different categories
      final categories = practiceModules.map((m) => m.category).toSet();
      expect(categories, contains(WellnessCategory.recommended));
      expect(categories, contains(WellnessCategory.mindfulness));
      expect(categories, contains(WellnessCategory.selfAlignment));
    });

    test('FirebaseService returns learn modules', () async {
      final service = FirebaseService();
      
      final learnModules = await service.getWellnessModules('learn');
      expect(learnModules, isNotEmpty);
      
      // Should have different content types
      final contentTypes = learnModules.map((m) => m.contentType).toSet();
      expect(contentTypes, isNotEmpty);
    });

    test('FirebaseService handles invalid module types', () async {
      final service = FirebaseService();
      
      final invalidModules = await service.getWellnessModules('invalid_type');
      expect(invalidModules, isEmpty);
    });

    test('FirebaseService mock data has proper structure', () async {
      final service = FirebaseService();
      final modules = await service.getWellnessModules('practice');
      
      for (final module in modules) {
        expect(module.id, isNotEmpty);
        expect(module.title, isNotEmpty);
        expect(module.description, isNotEmpty);
        expect(module.contentType, isA<ContentType>());
        expect(module.category, isA<WellnessCategory>());
        
        // Test activities if present
        for (final activity in module.activities) {
          expect(activity.id, isNotEmpty);
          expect(activity.title, isNotEmpty);
          expect(activity.description, isNotEmpty);
        }
      }
    });

    test('FirebaseService getUserProgress returns empty map for development', () async {
      final service = FirebaseService();
      final progress = await service.getUserProgress('test_user');
      expect(progress, isA<Map<String, double>>());
    });

    test('FirebaseService saveModuleProgress handles gracefully', () async {
      final service = FirebaseService();
      final result = await service.saveModuleProgress('user1', 'module1', 0.5);
      expect(result, isA<bool>());
    });
  });

  group('CheckinRepository Tests', () {
    
    test('CheckinRepository provides mood options', () {
      final repo = CheckinRepository();
      final moods = repo.getMoodOptions();
      
      expect(moods, isNotEmpty);
      expect(moods.length, equals(5));
      
      // Should have required mood types
      final names = moods.map((m) => m.name).toList();
      expect(names, contains('Happy'));
      expect(names, contains('Neutral'));
      expect(names, contains('Angry'));
      expect(names, contains('Sad'));
      expect(names, contains('Tired'));
      
      // All should have emojis and colors
      for (final mood in moods) {
        expect(mood.emoji, isNotEmpty);
        expect(mood.name, isNotEmpty);
        expect(mood.color, isA<Color>());
      }
    });

    test('CheckinRepository provides mood tags', () {
      final repo = CheckinRepository();
      final tags = repo.getMoodTags();
      
      expect(tags, isNotEmpty);
      expect(tags.length, greaterThan(10));
      
      // Should contain common mood descriptors
      expect(tags, contains('Confident'));
      expect(tags, contains('Joyful'));
      expect(tags, contains('Peaceful'));
      expect(tags, contains('Energetic'));
    });

    test('CheckinRepository provides wellness activities', () {
      final repo = CheckinRepository();
      final activities = repo.getWellnessActivities();
      
      expect(activities, isNotEmpty);
      expect(activities.length, equals(4));
      
      final names = activities.map((a) => a.name).toList();
      expect(names, contains('Therapy'));
      expect(names, contains('Exercise'));
      expect(names, contains('Meditation'));
      expect(names, contains('Journaling'));
      
      // All should have icons and colors
      for (final activity in activities) {
        expect(activity.icon, isA<IconData>());
        expect(activity.color, isA<Color>());
      }
    });

    test('CheckinRepository provides social activities', () {
      final repo = CheckinRepository();
      final social = repo.getSocialActivities();
      
      expect(social, isNotEmpty);
      expect(social.length, greaterThan(5));
      
      expect(social, contains('Coffee with friends'));
      expect(social, contains('Family dinner'));
      expect(social, contains('Team meeting'));
    });

    test('CheckinRepository saveCheckinData handles gracefully', () async {
      final repo = CheckinRepository();
      final mood = MoodOption(emoji: '😊', name: 'Happy', color: Colors.yellow);
      final checkin = CheckinData(
        selectedMood: mood,
        selectedMoodTags: ['Happy'],
        selectedWellness: [],
        selectedSocial: [],
      );
      
      final result = await repo.saveCheckinData(checkin);
      expect(result, isA<bool>());
    });

    test('CheckinRepository getCheckinHistory returns empty for development', () async {
      final repo = CheckinRepository();
      final history = await repo.getCheckinHistory('test_user');
      expect(history, isEmpty);
    });

    test('CheckinRepository getCheckinAnalytics returns empty for development', () async {
      final repo = CheckinRepository();
      final analytics = await repo.getCheckinAnalytics('test_user');
      expect(analytics, isEmpty);
    });
  });

  group('Data Integration Tests', () {
    
    test('Models work together in complete workflow', () {
      final repo = CheckinRepository();
      
      // Get mood options
      final moods = repo.getMoodOptions();
      expect(moods, isNotEmpty);
      
      // Select a mood
      final selectedMood = moods.first;
      
      // Get additional data
      final moodTags = repo.getMoodTags();
      final wellness = repo.getWellnessActivities();
      final social = repo.getSocialActivities();
      
      // Create checkin data
      final checkin = CheckinData(
        selectedMood: selectedMood,
        selectedMoodTags: [moodTags.first],
        selectedWellness: [wellness.first.name],
        selectedSocial: [social.first],
        additionalNotes: 'Test notes',
      );
      
      expect(checkin.selectedMood, equals(selectedMood));
      expect(checkin.selectedMoodTags, hasLength(1));
      expect(checkin.selectedWellness, hasLength(1));
      expect(checkin.selectedSocial, hasLength(1));
    });

    test('Wellness modules and activities integrate correctly', () async {
      final service = FirebaseService();
      final modules = await service.getWellnessModules('practice');
      
      // Find module with activities
      final moduleWithActivities = modules.firstWhere(
        (m) => m.activities.isNotEmpty,
        orElse: () => modules.first,
      );
      
      expect(moduleWithActivities.id, isNotEmpty);
      expect(moduleWithActivities.title, isNotEmpty);
      
      if (moduleWithActivities.activities.isNotEmpty) {
        final activity = moduleWithActivities.activities.first;
        expect(activity.id, isNotEmpty);
        expect(activity.title, isNotEmpty);
        expect(activity.description, isNotEmpty);
      }
    });

    test('Data models handle edge cases gracefully', () {
      // Test with minimal data
      final mood = MoodOption(emoji: '', name: '', color: Colors.transparent);
      expect(mood.emoji, isEmpty);
      
      final checkin = CheckinData(
        selectedMood: mood,
        selectedMoodTags: [],
        selectedWellness: [],
        selectedSocial: [],
      );
      expect(checkin.selectedMoodTags, isEmpty);
      
      // Test JSON with missing fields
      final incompleteJson = {'emoji': '😊'};
      final moodFromJson = MoodOption.fromJson(incompleteJson);
      expect(moodFromJson.emoji, equals('😊'));
      expect(moodFromJson.name, isEmpty);
    });
  });
}
