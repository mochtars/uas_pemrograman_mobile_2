import 'package:flutter_test/flutter_test.dart';

import 'package:latihan/main.dart';

void main() {
  testWidgets('WisataApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WisataApp());
    expect(find.text('Aplikasi Wisata'), findsNothing);
  });
}
