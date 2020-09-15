import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_anonymously_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  CurrentUserStore userStore;
  LogInAnonymouslyUseCase useCase;
  group("logInAnonymouslyUseCase", () {
    test("does nothing if already logged in", () async {
      //given
      userStore.user = Stubs.user;
      //when
      await useCase.execute();
      //then
      verifyNever(Mocks.authService.logInAnonymously());
    });

    test("logs user in anonymously", () async {
      //given
      userStore.user = null;
      when(Mocks.authService.logInAnonymously()).thenAnswer((_) => Future.value(right(Stubs.anonymousUser)));
      //when
      await useCase.execute();
      //then
      verify(Mocks.authService.logInAnonymously());
      expect(userStore.user, Stubs.anonymousUser);
    });

    test("after successful login, fetches workouts", () async {
      userStore.user = null;
      when(Mocks.authService.logInAnonymously()).thenAnswer((_) => Future.value(right(Stubs.anonymousUser)));
      //when
      await useCase.execute();
      //then
      verify(Mocks.authService.logInAnonymously());
      verify(Mocks.getWorkoutsListUseCase.execute());
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    userStore = CurrentUserStore();
    useCase = LogInAnonymouslyUseCase(userStore, Mocks.authService, Mocks.getWorkoutsListUseCase);
  });
}
