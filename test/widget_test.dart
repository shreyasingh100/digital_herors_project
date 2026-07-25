import 'package:flutter_test/flutter_test.dart';
import 'package:order_tracker/main.dart';

void main() {
  testWidgets('App renders OrderListScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const OrderTrackerApp());
    expect(find.text('My Orders'), findsOneWidget);
  });
}
