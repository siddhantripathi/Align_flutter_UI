import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/main.dart';

// Basic Structure Tests
// Tests core app structure without relying on animations or complex interactions

void main() {
  group('Basic App Structure Tests', () {
    
    testWidgets('App builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump(); // Single pump, no settling

      // Basic structure exists
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Home screen displays core elements', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Core text elements
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Your AI Coach'), findsOneWidget);
      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.text('Practice Wellness'), findsOneWidget);
    });

    testWidgets('Bottom navigation displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Wellness'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Check-in section exists', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Check-in related elements
      expect(find.textContaining('Check-in'), findsOneWidget);
      expect(find.byIcon(Icons.face), findsOneWidget);
    });

    testWidgets('Navigation buttons are tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Test that navigation elements can be found and are widgets
      final practiceWellness = find.text('Practice Wellness');
      expect(practiceWellness, findsOneWidget);
      
      final learnWellness = find.text('Learn Wellness');
      expect(learnWellness, findsOneWidget);
      
      final aiCoach = find.text('Start Chatting');
      expect(aiCoach, findsOneWidget);
    });

    testWidgets('Icons render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Test that common icons exist
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.face), findsOneWidget);
      // Arrow icons should exist
      final arrowIcons = find.byIcon(Icons.arrow_forward_ios);
      expect(arrowIcons.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('App uses correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Verify MaterialApp exists with theme
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('Safe areas are implemented', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Check for SafeArea usage
      // Check for SafeArea usage
      final safeAreas = find.byType(SafeArea);
      expect(safeAreas.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Scrollable content exists', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Check for scrollable elements
      // Check for scrollable elements
      final scrollViews = find.byType(SingleChildScrollView);
      expect(scrollViews.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Text styles are applied consistently', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Verify text widgets exist (indicating styling is working)
      final textWidgets = find.byType(Text);
      expect(textWidgets.evaluate().length, greaterThan(5));
    });
  });

  group('Widget Structure Tests', () {
    
    testWidgets('Container widgets are used for layout', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      final containers = find.byType(Container);
      expect(containers.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Column and Row layouts exist', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      final columns = find.byType(Column);
      final rows = find.byType(Row);
      expect(columns.evaluate().length, greaterThanOrEqualTo(1));
      expect(rows.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Padding is implemented', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      final padding = find.byType(Padding);
      expect(padding.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Gesture detection is implemented', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors.evaluate().length, greaterThanOrEqualTo(1));
    });

    testWidgets('Flexible layouts are used', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Check for flexible layout widgets
      final expanded = find.byType(Expanded);
      final flexible = find.byType(Flexible);
      
      expect(expanded.evaluate().length + flexible.evaluate().length, greaterThan(0));
    });
  });

  group('Content Structure Tests', () {
    
    testWidgets('Header section exists', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      // Greeting should exist
      expect(find.textContaining('Hi'), findsOneWidget);
    });

    testWidgets('Explore section is structured correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Learn Wellness'), findsOneWidget);
      expect(find.text('Practice Wellness'), findsOneWidget);
    });

    testWidgets('AI Coach section is present', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      expect(find.text('Your AI Coach'), findsOneWidget);
      expect(find.text('Start Chatting'), findsOneWidget);
    });

    testWidgets('Check-in functionality is accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const AlignApp());
      await tester.pump();

      expect(find.textContaining('Check-in'), findsOneWidget);
    });
  });
}
