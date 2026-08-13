import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_soap_practice/main.dart';

void main() {
  testWidgets('Patient search screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Patient Records'), findsOneWidget);
    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('Search by name or patient ID'), findsOneWidget);
  });
}
