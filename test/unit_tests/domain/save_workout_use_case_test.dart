import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:fitlify_flutter/domain/use_cases/save_workout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';
import '../../test_utils.dart';

void main() {
  //
  CurrentUserStore userStore;
  WorkoutsStore workoutsStore;
  SaveWorkoutUseCase useCase;

  group("saveWorkoutUseCase", () {
    //
    test("saves workout in workouts repository", () async {
      //
      userStore.user = Stubs.user;
      when(Mocks.workoutsRepository.saveWorkout(any, any))
          .thenAnswer((invocation) => successFuture(invocation.positionalArguments[1] as Workout));
      expect(workoutsStore.workouts, isEmpty);

      await useCase.execute(Stubs.workout);

      expect(workoutsStore.workouts[0], Stubs.workout);
    });

    test("not logged in users return failure", () async {
      userStore.user = null;

      when(Mocks.workoutsRepository.getWorkouts(any, any)).thenAnswer((_) => successFuture(Stubs.workoutsPaginatedList));
      final result = await useCase.execute(Stubs.workout);
      expectEither(result, const SaveWorkoutFailure.notLoggedIn());
      verifyNever(Mocks.workoutsRepository.saveWorkout(any, any));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    userStore = CurrentUserStore();
    workoutsStore = WorkoutsStore();
    useCase = SaveWorkoutUseCase(workoutsStore, Mocks.workoutsRepository, userStore);
  });
}
