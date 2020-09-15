import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:kt_dart/kt.dart';
import 'package:mockito/mockito.dart';

import 'mock_classes.dart';
import 'stubs.dart';

// ignore: avoid_classes_with_only_static_members
class Mocks {
  static MockAppNavigator appNavigator;
  static MockAuthService authService;
  static MockLogInAnonymouslyUseCase logInAnonymouslyUseCase;
  static MockIsLoggedInUseCase isLoggedInUseCase;
  static MockSaveWorkoutUseCase saveWorkoutUseCase;
  static MockLogInWithAppleUseCase appleLogInUseCase;
  static MockLogOutUseCase logOutUseCase;
  static MockGetWorkoutsListUseCase getWorkoutsListUseCase;
  static MockInitializeAppUseCase initializeAppUseCase;
  static MockWorkoutsRepository workoutsRepository;
  static MockWorkoutsStore workoutsStore;
  static MockCurrentUserStore currentUserStore;
  static MockAppRestarter appRestarter;

  static void setUpDefaultMocks() {
    appNavigator = MockAppNavigator();
    authService = MockAuthService();
    logInAnonymouslyUseCase = MockLogInAnonymouslyUseCase();
    isLoggedInUseCase = MockIsLoggedInUseCase();
    saveWorkoutUseCase = MockSaveWorkoutUseCase();
    appleLogInUseCase = MockLogInWithAppleUseCase();
    logOutUseCase = MockLogOutUseCase();
    getWorkoutsListUseCase = MockGetWorkoutsListUseCase();
    initializeAppUseCase = MockInitializeAppUseCase();
    workoutsRepository = MockWorkoutsRepository();
    workoutsStore = MockWorkoutsStore();
    currentUserStore = MockCurrentUserStore();
    appRestarter = MockAppRestarter();
    when(Mocks.workoutsRepository.saveWorkout(any, any)).thenAnswer((invocation) {
      final workout = invocation.positionalArguments[1] as Workout;
      return Future.value(right(workout.copyWith(id: workout.id ?? "workoutId")));
    });

    when(Mocks.workoutsRepository.getWorkouts(any, any)).thenAnswer(
      (_) => Future.value(right(PaginatedList(null, const KtList.empty()))),
    );
    when(Mocks.currentUserStore.user).thenAnswer((realInvocation) => Stubs.user);
  }
}
