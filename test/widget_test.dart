import 'package:flutter_test/flutter_test.dart';

import 'package:task1/main.dart';

void main() {
  testWidgets('YZ Accessories app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const YZAccessoriesApp());

    expect(find.text('YZ Accessories'), findsOneWidget);

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
