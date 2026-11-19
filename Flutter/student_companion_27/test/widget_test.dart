import 'package:flutter_test/flutter_test.dart' as flutter_test show WidgetTester, expect, find, findsOneWidget, testWidgets;
import 'package:material_ui/material_ui.dart';
import 'package:student_companion_27/student_companion.dart';

void main() {
  flutter_test.testWidgets('Student Companion app launches', (flutter_test.WidgetTester tester) async {
    await tester.pumpWidget(const StudentCompanion());

    flutter_test.expect(flutter_test.find.byType(MaterialApp), flutter_test.findsOneWidget);
  });
}