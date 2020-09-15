import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/pages/login/login_page.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:fitlify_flutter/presentation/login/login_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_doubles/mocks.dart';
import 'robots/login_page_robot.dart';
import 'utils/test_app.dart';

void main() {
  LoginPage page;
  LoginInitialParams initParams;
  LoginPresentationModel model;
  LoginPresenter presenter;
  LoginPageRobot robot;

  void _initMvp() {
    initParams = LoginInitialParams();
    model = LoginPresentationModel(initParams);
    presenter = LoginPresenter(model, Mocks.appleLogInUseCase, Mocks.appNavigator, Mocks.logInAnonymouslyUseCase);
    page = LoginPage(initialParams: initParams);
  }

  group("LoginPage", () {
    testWidgets("signs in with Apple", (tester) async {
      _initMvp();
      final completer = Completer<Either<AuthFailure, Unit>>();
      when(Mocks.appleLogInUseCase.execute()).thenAnswer((_) => completer.future);
      robot = LoginPageRobot(tester);

      await TestApp.pumpPage(tester, presenter, () => page);
      await robot.appleButton.tap();
      expect(model.logInProgress, true);
      verify(Mocks.appleLogInUseCase.execute());
      completer.complete(right(unit));
      await completer.future;
      await tester.pumpAndSettle();
      expect(model.logInProgress, false);
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteRouting>())));
    });

    testWidgets("signs in anonymously", (tester) async {
      _initMvp();
      when(Mocks.logInAnonymouslyUseCase.execute()).thenAnswer((_) => Future.value(right(unit)));
      robot = LoginPageRobot(tester);

      await TestApp.pumpPage(tester, presenter, () => page);
      await robot.anonymousLogInButton.tap();
      verify(Mocks.logInAnonymouslyUseCase.execute());
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteRouting>())));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
