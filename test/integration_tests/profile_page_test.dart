import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/pages/profile/profile_page.dart';
import 'package:fitlify_flutter/presentation/profile/profile_initial_params.dart';
import 'package:fitlify_flutter/presentation/profile/profile_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_doubles/mocks.dart';
import '../test_doubles/stubs.dart';
import 'robots/profile_page_robot.dart';
import 'utils/test_app.dart';

void main() {
  ProfilePage page;
  ProfileInitialParams initParams;
  ProfilePresentationModel model;
  ProfilePresenter presenter;
  ProfilePageRobot robot;

  void _initMvp({User user}) {
    initParams = ProfileInitialParams(user ?? Stubs.user);
    model = ProfilePresentationModel(initParams, Mocks.currentUserStore);
    presenter = ProfilePresenter(model, Mocks.logOutUseCase);
    page = ProfilePage(initialParams: initParams);
  }

  group("ProfilePage", () {
    testWidgets("logs user out", (tester) async {
      _initMvp();
      final completer = Completer<Either<AuthFailure, Unit>>();
      when(Mocks.currentUserStore.isCurrentUser(any)).thenReturn(true);
      when(Mocks.logOutUseCase.execute()).thenAnswer((_) => completer.future);
      robot = ProfilePageRobot(tester);
      await TestApp.pumpPage(tester, presenter, () => page);

      await robot.logOutButton.tap();
      await tester.pump(const LongDuration());
      await robot.progressBar.expectOneWidget();
      await robot.logOutButton.expectNotPresent();
      expect(model.logOutProgress, true);
      verify(Mocks.logOutUseCase.execute());
      completer.complete(right(unit));
      await completer.future;
      expect(model.logOutProgress, false);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
