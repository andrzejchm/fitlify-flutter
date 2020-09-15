import 'package:flutter_test/flutter_test.dart';

class WidgetRobot {
  final WidgetTester tester;
  final Finder finder;

  WidgetRobot(this.tester, {this.finder});

  Future<void> tap() async {
    assert(finder != null, "you cant perform actions on robot without 'finder'");
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> expectNotPresent() {
    assert(finder != null, "you cant perform actions on robot without 'finder'");
    return expectLater(finder, findsNothing);
  }

  Future<void> expectOneWidget() {
    assert(finder != null, "you cant perform actions on robot without 'finder'");
    return expectLater(finder, findsOneWidget);
  }
}
