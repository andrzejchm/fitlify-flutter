import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/initialize_app_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  InitializeAppUseCase useCase;
  CurrentUserStore userStore;

  group("InitializeAppUseCase", () {
    //
    test("not logged in users do not fetch workouts", () async {
      //
      when(Mocks.authService.getCurrentUser()).thenAnswer((_) => failFuture(const AuthFailure.notLoggedIn()));
      when(Mocks.workoutsRepository.getWorkouts(any, any)).thenAnswer((_) => successFuture(Stubs.workoutsPaginatedList));

      await useCase.execute();

      verifyNever(Mocks.workoutsRepository.getWorkouts(any, any));
      expect(userStore.user, null);
    });
    //
    test("logging out nulls user", () async {});
    //
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    userStore = CurrentUserStore();
    useCase = InitializeAppUseCase(Mocks.authService, userStore, Mocks.getWorkoutsListUseCase);
  });
}
