import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/main.dart';

void main() {
  testWidgets('KaloriApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KaloriApp());
    await tester.pumpAndSettle();

    // Verify that our home view displays the welcome text.
    expect(find.text('Welcome to Kalori!'), findsOneWidget);
  });
}
