import 'package:flutter_test/flutter_test.dart';

import '../robots/widget_robot.dart';

Type typeOf<T>() => T;

extension RobotExtensions on Finder {
  WidgetRobot robot(WidgetTester tester) => WidgetRobot(tester, finder: this);
}
