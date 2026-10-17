import 'package:flutter_test/flutter_test.dart';

import 'package:rentory/app/app.dart';

void main() {
  testWidgets('shell switches between sections', (tester) async {
    await tester.pumpWidget(const RentoryApp());

    expect(find.text('Orders'), findsWidgets);
    await tester.tap(find.text('Assets').last);
    await tester.pumpAndSettle();
    expect(find.text('Assets'), findsWidgets);
  });
}
