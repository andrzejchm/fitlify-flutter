import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/log_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  LogOutUseCase useCase;
  CurrentUserStore userStore;

  group("LogOutUseCase", () {
    test("restarts app on logout", () async {
      when(Mocks.authService.logOut()).thenAnswer((_) => Future.value(right(unit)));
      await useCase.execute();

      verify(Mocks.appRestarter.restartApp());
    });

    test("logging out nulls user", () async {
      userStore.user = Stubs.user;
      when(Mocks.authService.logOut()).thenAnswer((_) => Future.value(right(unit)));
      await useCase.execute();

      expect(userStore.user, isNull);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    userStore = CurrentUserStore();
    useCase = LogOutUseCase(userStore, Mocks.appRestarter, Mocks.authService);
  });
}
