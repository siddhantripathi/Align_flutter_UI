import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/main.dart';

// Simplified UI Tests focusing on core functionality and structure
// These tests avoid hardcoded content and focus on behavior

void main() {
  group('Core App Functionality Tests', () {
    
    testWidgets('App launches and displays main structure', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test core structural elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Test main sections exist
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Your AI Coach'), findsOneWidget);
      
      // Test bottom navigation
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Check-in navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Find and tap check-in
      final checkinFinder = find.textContaining('Check-in');
      expect(checkinFinder, findsOneWidget);
      
      await tester.tap(checkinFinder);
      await tester.pumpAndSettle();

      // Should navigate to mood selection
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.textContaining('mood'), findsOneWidget);
    });

    testWidgets('Wellness navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test Practice Wellness
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      expect(find.text('Practice Wellness'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      
      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Test Learn Wellness
      await tester.tap(find.text('Learn Wellness'));
      await tester.pumpAndSettle();

      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('AI Coach navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to AI Coach
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();

      expect(find.text('AI Coach'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('Wellness modules display content', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();

      // Should show category sections
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(find.text('Mindfulness'), findsOneWidget);
      expect(find.text('Self-Alignment'), findsOneWidget);
      
      // Should have some module content
      // Should have some grid content
      final gridViews = find.byType(GridView);
      expect(gridViews.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Back navigation works from all screens', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test from wellness screen
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);

      // Test from AI Coach
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('Bottom navigation maintains structure', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Navigate to different sections and verify bottom nav persists
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();
      
      // Bottom nav should still exist
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      
      // Tap home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('Text input fields work', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Test AI Coach input
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      
      await tester.enterText(textField, 'Test message');
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('Animations render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Let any animations settle
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      
      // App should still be functional
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Your AI Coach'), findsOneWidget);
    });

    testWidgets('App handles navigation state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pumpAndSettle();

      // Multiple navigation actions
      await tester.tap(find.text('Practice Wellness'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start Chatting'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should be back on home
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Your AI Coach'), findsOneWidget);
    });
  });
}
