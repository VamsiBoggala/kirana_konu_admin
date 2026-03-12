// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:kirana_admin_web/main.dart';

void main() {
  testWidgets('Admin app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdminApp());

    // Verify that login screen elements are present
    expect(find.text('Admin Panel'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
