import 'package:flutter_test/flutter_test.dart';
import 'package:wiom_partner_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WiomPartnerApp());
    await tester.pumpAndSettle();
  });
}
