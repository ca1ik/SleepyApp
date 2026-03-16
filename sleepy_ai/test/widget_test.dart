// Basic widget smoke test.
// Full integration tests require Firebase + Hive init — skipped here.
// Run: flutter test test/unit/ for unit tests.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Text('SleepyApp')))),
    );
    expect(find.text('SleepyApp'), findsOneWidget);
  });
}
