// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:align_app/main.dart';

void main() {
  testWidgets('Align app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlignApp());

    // Verify that our app loads with the greeting.
    expect(find.text('Hi,'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Your AI Coach'), findsOneWidget);
  });
}
