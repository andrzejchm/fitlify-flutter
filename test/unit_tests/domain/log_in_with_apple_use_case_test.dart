import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_with_apple_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  LogInWithAppleUseCase useCase;
  CurrentUserStore userStore;

  group("LogInWithAppleUseCase", () {
    //
    test("refreshes workout list after success login", () async {
      when(Mocks.authService.logInWithApple()).thenAnswer((_) => Future.value(right(Stubs.user)));

      await useCase.execute();

      verify(Mocks.getWorkoutsListUseCase.execute());
    });

    test("does nothing if logged in", () async {
      userStore.user = Stubs.user;

      await useCase.execute();

      verifyNever(Mocks.authService.logInWithApple());
    });

    test("logs in if anonymous", () async {
      userStore.user = Stubs.anonymousUser;
      when(Mocks.authService.logInWithApple()).thenAnswer((_) => Future.value(right(Stubs.user)));

      await useCase.execute();

      verify(Mocks.authService.logInWithApple());
      expect(userStore.user, Stubs.user);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    userStore = CurrentUserStore();
    useCase = LogInWithAppleUseCase(userStore, Mocks.authService, Mocks.getWorkoutsListUseCase);
  });
}
