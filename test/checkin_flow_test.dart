import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/main.dart';
import 'package:align_app/screens/checkin/checkin_screen.dart';
import 'package:align_app/screens/checkin/mood_depth_screen.dart';
import 'package:align_app/screens/checkin/checkin_final_screen.dart';

void main() {
  group('Check-in Flow Tests', () {
    testWidgets('Complete check-in flow from home to final screen', (WidgetTester tester) async {
      // Start from home screen
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Verify home screen is displayed
      expect(find.text('Hi, Emma!'), findsOneWidget);
      expect(find.text('Check-in: How are you feeling?'), findsOneWidget);

      // Tap on check-in card to start the flow
      await tester.tap(find.text('Check-in: How are you feeling?'));
      await tester.pumpAndSettle();

      // Verify mood selection screen is displayed
      expect(find.text('How would you describe your mood?'), findsOneWidget);
      expect(find.text('Set Mood >'), findsOneWidget);

      // Test circular mood selector interaction
      // Find the circular selector area
      final circularSelector = find.byType(CustomPaint);
      expect(circularSelector, findsOneWidget);

      // Simulate pan gesture on the circular selector
      await tester.drag(circularSelector, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Tap Set Mood button to proceed to depth screen
      await tester.tap(find.text('Set Mood >'));
      await tester.pumpAndSettle();

      // Verify mood depth screen is displayed
      expect(find.text("Let's dive deeper"), findsOneWidget);
      expect(find.text('What have you done today?'), findsOneWidget);
      expect(find.text('Continue >'), findsOneWidget);

      // Test mood tag selection
      final moodTag = find.text('Confident');
      if (moodTag.evaluate().isNotEmpty) {
        await tester.tap(moodTag);
        await tester.pumpAndSettle();
      }

      // Test wellness activity selection
      final wellnessActivity = find.text('Meditation');
      if (wellnessActivity.evaluate().isNotEmpty) {
        await tester.tap(wellnessActivity);
        await tester.pumpAndSettle();
      }

      // Tap Continue button to proceed to final screen
      await tester.tap(find.text('Continue >'));
      await tester.pumpAndSettle();

      // Verify final check-in screen is displayed
      expect(find.text('Add more details'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Voice Memo'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Test text input
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'Had a great day!');
      await tester.pumpAndSettle();

      // Test photo buttons
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      // Test voice memo
      await tester.tap(find.text('Tap to Record'));
      await tester.pumpAndSettle();
      expect(find.text('Stop Recording'), findsOneWidget);

      // Tap record again to stop
      await tester.tap(find.text('Stop Recording'));
      await tester.pumpAndSettle();
      expect(find.text('Tap to Record'), findsOneWidget);

      // Test save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should return to home screen
      expect(find.text('Hi, Emma!'), findsOneWidget);
    });

    testWidgets('Exit button double-tap functionality', (WidgetTester tester) async {
      // Start from mood depth screen
      await tester.pumpWidget(MaterialApp(
        home: MoodDepthScreen(
          selectedMood: MoodOption(
            emoji: '😊',
            name: 'Happy',
            color: Colors.yellow,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Find the exit button
      final exitButton = find.byIcon(Icons.close);
      expect(exitButton, findsOneWidget);

      // First tap - should show confirmation
      await tester.tap(exitButton);
      await tester.pumpAndSettle();

      // Should show confirmation text
      expect(find.text("That's it for today?"), findsOneWidget);

      // Second tap - should exit
      await tester.tap(exitButton);
      await tester.pumpAndSettle();
    });

    testWidgets('Mood selection circular slider interaction', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CheckInScreen(),
      ));
      await tester.pumpAndSettle();

      // Find the circular selector
      final circularSelector = find.byType(CustomPaint);
      expect(circularSelector, findsOneWidget);

      // Test different drag directions
      await tester.drag(circularSelector, const Offset(100, 0));
      await tester.pumpAndSettle();

      await tester.drag(circularSelector, const Offset(-50, 50));
      await tester.pumpAndSettle();

      await tester.drag(circularSelector, const Offset(0, -100));
      await tester.pumpAndSettle();

      // Verify Set Mood button is still present
      expect(find.text('Set Mood >'), findsOneWidget);
    });

    testWidgets('Mood depth screen tag selection', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MoodDepthScreen(
          selectedMood: MoodOption(
            emoji: '😊',
            name: 'Happy',
            color: Colors.yellow,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Test mood tag selection
      final moodTags = [
        'Ecstatic', 'Optimistic', 'Confident', 'Joyful', 'Loving',
        'Strong', 'Playful', 'Generous', 'Inspired', 'Delighted'
      ];

      for (final tag in moodTags) {
        final tagWidget = find.text(tag);
        if (tagWidget.evaluate().isNotEmpty) {
          await tester.tap(tagWidget);
          await tester.pumpAndSettle();
          
          // Tap again to deselect
          await tester.tap(tagWidget);
          await tester.pumpAndSettle();
        }
      }

      // Test wellness activity selection
      final wellnessActivities = ['Therapy', 'Exercise', 'Meditation', 'Journaling'];
      for (final activity in wellnessActivities) {
        final activityWidget = find.text(activity);
        if (activityWidget.evaluate().isNotEmpty) {
          await tester.tap(activityWidget);
          await tester.pumpAndSettle();
        }
      }

      // Test social activity selection
      final socialActivities = ['Coffee with friends', 'Family dinner', 'Team meeting'];
      for (final activity in socialActivities) {
        final activityWidget = find.text(activity);
        if (activityWidget.evaluate().isNotEmpty) {
          await tester.tap(activityWidget);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Final screen input and interactions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CheckinFinalScreen(
          selectedMood: MoodOption(
            emoji: '😊',
            name: 'Happy',
            color: Colors.yellow,
          ),
          selectedMoodTags: ['Confident', 'Joyful'],
          selectedWellness: ['Meditation'],
          selectedSocial: ['Coffee with friends'],
        ),
      ));
      await tester.pumpAndSettle();

      // Test text input
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'This is a test entry');
      await tester.pumpAndSettle();

      // Test camera button
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();

      // Test gallery button
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      // Test voice memo recording
      await tester.tap(find.text('Tap to Record'));
      await tester.pumpAndSettle();
      expect(find.text('Stop Recording'), findsOneWidget);

      // Test stopping recording
      await tester.tap(find.text('Stop Recording'));
      await tester.pumpAndSettle();
      expect(find.text('Tap to Record'), findsOneWidget);

      // Test save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
    });

    testWidgets('Navigation flow integrity', (WidgetTester tester) async {
      // Start from home
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate through the entire flow
      await tester.tap(find.text('Check-in: How are you feeling?'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Set Mood >'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue >'));
      await tester.pumpAndSettle();

      // Test exit from final screen
      final exitButton = find.byIcon(Icons.close);
      await tester.tap(exitButton);
      await tester.pumpAndSettle();

      // Should show confirmation
      expect(find.text("That's it for today?"), findsOneWidget);

      // Second tap to exit
      await tester.tap(exitButton);
      await tester.pumpAndSettle();

      // Should return to home
      expect(find.text('Hi, Emma!'), findsOneWidget);
    });

    testWidgets('Auto-hide exit confirmation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MoodDepthScreen(
          selectedMood: MoodOption(
            emoji: '😊',
            name: 'Happy',
            color: Colors.yellow,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // First tap to show confirmation
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text("That's it for today?"), findsOneWidget);

      // Wait for auto-hide (3 seconds)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Confirmation should be hidden
      expect(find.text("That's it for today?"), findsNothing);
    });
  });
}
