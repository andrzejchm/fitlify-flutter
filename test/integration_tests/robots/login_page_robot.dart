import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/widget_tester.dart';

import '../utils/widget_test_utils.dart';
import 'page_robot.dart';
import 'widget_robot.dart';

class LoginPageRobot extends PageRobot {
  LoginPageRobot(WidgetTester tester) : super(tester);

  WidgetRobot get appleButton => find.text(S.current.logInWithAppleAction).robot(tester);

  WidgetRobot get anonymousLogInButton => find.text(S.current.anonymousLoginAction).robot(tester);
}
