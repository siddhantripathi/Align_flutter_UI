import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:align_app/shared/widgets/custom_button.dart';
import 'package:align_app/shared/widgets/custom_card.dart';
import 'package:align_app/shared/widgets/checkin_completion_overlay.dart';
import 'package:align_app/core/animations/earth_animation.dart';
import 'package:align_app/core/animations/exit_confirmation_animation.dart';

// Widget Component Tests
// Tests individual reusable components for proper structure and behavior

void main() {
  group('Custom Button Component Tests', () {
    
    testWidgets('CustomButton renders with correct structure', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () => wasPressed = true,
              type: ButtonType.primary,
            ),
          ),
        ),
      );

      // Test button structure
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
      
      // Test button press
      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('CustomButton handles different types correctly', (WidgetTester tester) async {
      for (final type in ButtonType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                text: 'Test',
                type: type,
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      }
    });

    testWidgets('CustomButton shows loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('CustomButton handles disabled state', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled',
              enabled: false,
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(wasPressed, isFalse);
    });

    testWidgets('CheckinButton is properly configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckinButton(
              text: 'Check In',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Check In'), findsOneWidget);
    });
  });

  group('Custom Card Component Tests', () {
    
    testWidgets('CustomCard renders with proper structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsAtLeastOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('CustomCard handles tap events', (WidgetTester tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCard(
              onTap: () => wasTapped = true,
              child: Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      expect(wasTapped, isTrue);
    });

    testWidgets('CheckinCard has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckinCard(
              child: Text('Checkin Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CustomCard), findsOneWidget);
      expect(find.text('Checkin Content'), findsOneWidget);
    });

    testWidgets('WellnessCard displays progress correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WellnessCard(
              title: 'Test Wellness',
              description: 'Test Description',
              progress: 0.5,
              completed: 5,
              total: 10,
              icon: Icons.favorite,
            ),
          ),
        ),
      );

      expect(find.text('Test Wellness'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('5/10 modules'), findsOneWidget);
      expect(find.text('50% completed'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });
  });

  group('Animation Component Tests', () {
    
    testWidgets('EarthAnimationWidget renders and animates', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EarthAnimationWidget(
              size: 50,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedBuilder), findsOneWidget);
      expect(find.byIcon(Icons.public), findsOneWidget);
      
      // Let animation run
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 100));
      
      // Animation should still be present
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('ExitConfirmationWidget shows confirmation on first tap', (WidgetTester tester) async {
      bool exitCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExitConfirmationWidget(
              onExit: () => exitCalled = true,
            ),
          ),
        ),
      );

      // First tap should show confirmation
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      expect(find.textContaining("That's it for today?"), findsOneWidget);
      expect(exitCalled, isFalse);

      // Second tap should trigger exit
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      expect(exitCalled, isTrue);
    });

    testWidgets('ExitConfirmationWidget auto-hides confirmation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExitConfirmationWidget(
              onExit: () {},
            ),
          ),
        ),
      );

      // Show confirmation
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      expect(find.textContaining("That's it for today?"), findsOneWidget);

      // Wait for auto-hide
      await tester.pump(Duration(seconds: 4));
      await tester.pumpAndSettle();
      
      expect(find.textContaining("That's it for today?"), findsNothing);
    });
  });

  group('Overlay Component Tests', () {
    
    testWidgets('CheckinCompletionOverlay displays correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CheckinCompletionOverlay.show(context),
                child: Text('Show Overlay'),
              ),
            ),
          ),
        ),
      );

      // Show overlay
      await tester.tap(find.text('Show Overlay'));
      await tester.pumpAndSettle();

      // Test overlay structure
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      expect(find.textContaining('Thanks for checking in today!'), findsOneWidget);
      expect(find.textContaining('amazing'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Test close functionality
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('CheckinCompletionOverlay handles different user names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CheckinCompletionOverlay.show(context, userName: 'TestUser'),
                child: Text('Show Overlay'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Overlay'));
      await tester.pumpAndSettle();

      expect(find.textContaining('TestUser'), findsOneWidget);
    });

    testWidgets('CheckinCompletionOverlay close button works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CheckinCompletionOverlay.show(context),
                child: Text('Show Overlay'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Overlay'));
      await tester.pumpAndSettle();

      // Test X button close
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('CheckinCompletionOverlay is not dismissible by tapping outside', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CheckinCompletionOverlay.show(context),
                child: Text('Show Overlay'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Overlay'));
      await tester.pumpAndSettle();

      // Try to tap outside (on barrier)
      await tester.tapAt(Offset(10, 10));
      await tester.pumpAndSettle();
      
      // Overlay should still be present
      expect(find.byType(Dialog), findsOneWidget);
    });
  });

  group('Component Integration Tests', () {
    
    testWidgets('Components work together in complex layouts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomCard(
                  child: Column(
                    children: [
                      EarthAnimationWidget(size: 30),
                      CustomButton(
                        text: 'Test Integration',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                WellnessCard(
                  title: 'Integration Test',
                  description: 'Testing components together',
                  progress: 0.7,
                  completed: 7,
                  total: 10,
                  icon: Icons.star,
                ),
              ],
            ),
          ),
        ),
      );

      // All components should render
      expect(find.byType(CustomCard), findsAtLeastOneWidget); // WellnessCard extends CustomCard
      expect(find.byType(EarthAnimationWidget), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Test Integration'), findsOneWidget);
      expect(find.text('Integration Test'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('Component themes are consistent', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomButton(text: 'Primary', type: ButtonType.primary, onPressed: () {}),
                CustomButton(text: 'Secondary', type: ButtonType.secondary, onPressed: () {}),
                CustomButton(text: 'Accent', type: ButtonType.accent, onPressed: () {}),
                CustomButton(text: 'Outline', type: ButtonType.outline, onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      // All button types should render
      expect(find.byType(ElevatedButton), findsExactly(4));
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Accent'), findsOneWidget);
      expect(find.text('Outline'), findsOneWidget);
    });

    testWidgets('Components handle state changes gracefully', (WidgetTester tester) async {
      bool isLoading = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: CustomButton(
                text: 'Toggle Loading',
                isLoading: isLoading,
                onPressed: () => setState(() => isLoading = !isLoading),
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Toggle Loading'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Toggle loading
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Toggle Loading'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
