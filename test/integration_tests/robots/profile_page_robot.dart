import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/widget_tester.dart';

import '../utils/widget_test_utils.dart';
import 'page_robot.dart';
import 'widget_robot.dart';

class ProfilePageRobot extends PageRobot {
  ProfilePageRobot(WidgetTester tester) : super(tester);

  WidgetRobot get logOutButton => find.text(S.current.logOutAction).robot(tester);

  WidgetRobot get progressBar => find.byType(CircularProgressIndicator).robot(tester);
}
