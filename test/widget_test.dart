import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_crm/main.dart';

void main() {
  testWidgets('Comercia app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ComerciaApp());
    expect(find.text('Comercia.'), findsOneWidget);
  });
}
