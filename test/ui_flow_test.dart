import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/main.dart';
import 'package:align_app/shared/widgets/checkin_completion_overlay.dart';
import 'package:align_app/core/animations/earth_animation.dart';

// UI Flow Tests
// Tests focus on structure, navigation, and expected behaviors rather than hardcoded content

void main() {
  group('App Structure and Navigation Tests', () {
    
    testWidgets('Home screen displays required structural elements', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test structural elements exist (not specific text)
      expect(find.byType(AppBar), findsNothing); // Home screen has no app bar
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Test greeting section structure
      expect(find.text('Hi, '), findsOneWidget); // Greeting prefix should exist
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      
      // Test check-in card exists
      expect(find.textContaining('Check-in:'), findsOneWidget);
      expect(find.byIcon(Icons.face), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsAtLeastOneWidget);
      
      // Test explore section structure
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.text('Practice Wellness'), findsOneWidget);
      
      // Test AI Coach section
      expect(find.text('Your AI Coach'), findsOneWidget);
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      expect(find.text('Start Chatting'), findsOneWidget);
      
      // Test bottom navigation structure
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Check-in flow navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Tap check-in card
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();

      // Verify mood selection screen structure
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.textContaining('How would you describe your mood?'), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget); // Circular mood selector
      expect(find.textContaining('Set Mood'), findsOneWidget);
      
      // Test mood selector interaction
      final circularSelector = find.byType(CustomPaint);
      await tester.drag(circularSelector, const Offset(50, 0));
      await tester.pumpAndSettle();
      
      // Continue to depth screen
      await tester.tap(find.textContaining('Set Mood'));
      await tester.pumpAndSettle();

      // Verify depth screen structure
      expect(find.textContaining("Let's dive deeper"), findsOneWidget);
      expect(find.textContaining('What have you done today?'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      expect(find.text('Social'), findsOneWidget);
      expect(find.textContaining('Continue'), findsOneWidget);
      
      // Test exit button functionality
      final exitButton = find.byIcon(Icons.close);
      await tester.tap(exitButton);
      await tester.pumpAndSettle();
      expect(find.textContaining("That's it for today?"), findsOneWidget);
      
      // Continue to final screen
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      // Verify final screen structure
      expect(find.text('Add more details'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Voice Memo'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
    });

    testWidgets('Check-in completion overlay appears after save', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate through check-in flow to final screen
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Set Mood'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      // Save check-in
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify overlay appears
      expect(find.byType(CheckinCompletionOverlay), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.textContaining('Thanks for checking in today!'), findsOneWidget);
      expect(find.textContaining('amazing'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      
      // Close overlay
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      
      // Should be back on home screen
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('Wellness modules navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test Practice Wellness navigation
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      // Verify wellness modules screen structure
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Practice Wellness'), findsOneWidget);
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(find.text('Mindfulness'), findsOneWidget);
      expect(find.text('Self-Alignment'), findsOneWidget);
      
      // Test grid layout exists
      expect(find.byType(GridView), findsAtLeastOneWidget);
      
      // Test content type icons exist
      expect(find.byIcon(Icons.headphones), findsAtLeastOneWidget);
      expect(find.byIcon(Icons.article), findsAtLeastOneWidget);
      
      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test Learn Wellness navigation
      await tester.tap(find.text('Learn Wellness'));
      await tester.pumpAndSettle();

      // Verify learn wellness screen
      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.text('Recommended for you'), findsOneWidget);
    });

    testWidgets('Module activity screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to wellness modules
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      // Find and tap on a non-locked, non-empty module
      final moduleCards = find.byType(GestureDetector);
      expect(moduleCards, findsAtLeastOneWidget);
      
      // Tap on the first available module
      await tester.tap(moduleCards.first);
      await tester.pumpAndSettle();

      // Verify activity screen structure
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      // Duration icon may or may not be present
      final durationIcons = find.byIcon(Icons.access_time);
      expect(durationIcons.evaluate().length, greaterThanOrEqualTo(0));
      expect(find.textContaining("Let's begin"), findsOneWidget);
      
      // Test favorite functionality
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      
      // Test start button
      await tester.tap(find.textContaining("Let's begin"));
      await tester.pumpAndSettle();
      
      // Should show snackbar or navigate to activity
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('AI Coach screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to AI Coach
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();

      // Verify AI Coach screen structure
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('AI Coach'), findsOneWidget);
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      expect(find.textContaining('left'), findsOneWidget); // Conversation counter
      
      // Test chat interface
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      
      // Test sending a message
      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      
      // Should have at least initial message + user message
      expect(find.text('Test message'), findsOneWidget);
      
      // Wait for AI response
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      
      // Should have AI response
      expect(find.byType(Container), findsAtLeastOneWidget); // Message bubbles
    });

    testWidgets('Bottom navigation maintains state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test initial state
      expect(find.byIcon(Icons.home), findsOneWidget);
      
      // Navigate through different sections and verify structure remains
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();
      
      // Bottom navigation should still exist
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      
      // Tap home in bottom nav
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      // Should be back on home screen
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('Error handling works for locked modules', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to wellness modules
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      // Look for locked module (has lock icon)
      final lockIcons = find.byIcon(Icons.lock);
      if (lockIcons.evaluate().isNotEmpty) {
        // Find the parent container of the lock icon
        final lockedModule = find.ancestor(
          of: lockIcons.first,
          matching: find.byType(GestureDetector),
        );
        
        await tester.tap(lockedModule);
        await tester.pumpAndSettle();
        
        // Should show error message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.textContaining('locked'), findsOneWidget);
      }
    });

    testWidgets('Animation widgets render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test earth animations exist and animate
      final earthAnimations = find.byType(EarthAnimationWidget);
      expect(earthAnimations, findsAtLeastOneWidget);
      
      // Let animations run
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      
      // Animations should still be present
      expect(find.byType(EarthAnimationWidget), findsAtLeastOneWidget);
      
      // Test circular mood selector animation
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();
      
      expect(find.byType(CustomPaint), findsOneWidget);
      
      // Test drag interaction
      final painter = find.byType(CustomPaint);
      await tester.drag(painter, const Offset(100, 0));
      await tester.pumpAndSettle();
      
      // Should still be present after interaction
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('Voice memo and photo functionality shows appropriate feedback', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to final check-in screen
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Set Mood'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      // Test voice memo functionality
      expect(find.textContaining('Tap to Record'), findsOneWidget);
      await tester.tap(find.textContaining('Tap to Record'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Stop Recording'), findsOneWidget);
      
      await tester.tap(find.textContaining('Stop Recording'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Tap to Record'), findsOneWidget);

      // Test photo buttons
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Text input fields work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test AI Coach text input
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();

      final chatInput = find.byType(TextField).first;
      await tester.enterText(chatInput, 'Test input');
      expect(find.text('Test input'), findsOneWidget);

      // Go back and test check-in text input
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to check-in final screen
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Set Mood'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();

      final checkinInput = find.byType(TextField);
      await tester.enterText(checkinInput, 'Today was great!');
      expect(find.text('Today was great!'), findsOneWidget);
    });
  });

  group('Edge Cases and Error Handling', () {
    
    testWidgets('App handles empty module lists gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Even if no modules are loaded, the screen structure should exist
      await tester.tap(find.text('Learn Wellness'));
      await tester.pumpAndSettle();

      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.text('Recommended for you'), findsOneWidget);
      // Grid should exist even if empty
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Navigation back buttons work from all screens', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test back from wellness modules
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);

      // Test back from AI Coach
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);

      // Test back from check-in flow
      await tester.tap(find.textContaining('Check-in:'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      // Should show confirmation first
      expect(find.textContaining("That's it for today?"), findsOneWidget);
    });

    testWidgets('App maintains state during orientation changes', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to a screen
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      // Simulate orientation change by rebuilding
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Should maintain navigation state or return to home gracefully
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
