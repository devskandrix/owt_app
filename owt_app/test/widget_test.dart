import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:owt/core/di/injection_container.dart';
import 'package:owt/main.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await initDependencies(onSessionExpired: () async {});
  });

  testWidgets('adds a new todo to the list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('No todos yet'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('No todos yet'), findsNothing);
  });
}
