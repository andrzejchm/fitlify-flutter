import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlify_flutter/data/firebase/firebase_workouts_repository.dart';
import 'package:fitlify_flutter/data/firebase/firestore_paths.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:kt_dart/kt.dart';
import 'package:test/test.dart';

import '../utils/test_firebase.dart';
import 'test_result.dart';

final workout = Workout(
  id: "workoutId",
  name: "name",
  description: "description",
  sections: KtList.of(Section(
    id: "sectionId",
    name: "Section Name",
    description: "Short description",
    type: const SectionType.normal(),
    exercises: KtList.of(Exercise(
      id: "exerciseId",
      name: "name",
      properties: KtList.of(const MeasurableProperty.weight()),
      rest: null,
      type: ExerciseType.exercise,
      notes: "notes",
    )),
  )),
  createdAt: DateTime.now(),
);

final workout2 = workout.copyWith(id: "workout2");
final workout3 = workout.copyWith(id: "workout3");
final workout4 = workout.copyWith(id: "workout4");

class FirebaseWorkoutsRepositoryTests {
  TestFirebase testFirebase;
  UserCredential user;
  FirebaseWorkoutsRepository repo;

  FirebaseWorkoutsRepositoryTests() {
    test1 = TestSetup(
      () async {
        try {
          final res = await repo.saveWorkout(user.user.uid, workout);
          return res.fold(
            (fail) => TestResult.failure(fail),
            (r) => TestResult.success(),
          );
        } catch (e, stack) {
          return TestResult.failure(e, stack);
        }
      },
      setUp: setUp,
      tearDown: tearDown,
    );
    test2 = TestSetup(
      () async {
        String id;
        try {
          final res = await repo.saveWorkout(user.user.uid, workout.copyWith(id: null));
          return res.fold(
            (fail) => TestResult.failure(fail),
            (workout) {
              id = workout.id;
              return TestResult.allOf([
                TestResult.expect(id, isNotNull),
                TestResult.expect(id, isNotEmpty),
              ]);
            },
          );
        } catch (e, stack) {
          return TestResult.failure(e, stack);
        } finally {
          await testFirebase.firestore.doc(workoutDoc(user.user.uid, id)).delete();
        }
      },
      setUp: setUp,
      tearDown: tearDown,
    );
    test3 = TestSetup(
      () async {
        try {
          final res = await repo.saveWorkout(user.user.uid, workout.copyWith(createdAt: null));
          return res.fold(
            (fail) => TestResult.failure(fail),
            (workout) => TestResult.expect(workout.createdAt, isNotNull),
          );
        } catch (e, stack) {
          return TestResult.failure(e, stack);
        }
      },
      setUp: setUp,
      tearDown: tearDown,
    );
    test4 = TestSetup(
      () async {
        try {
          await repo.saveWorkout(user.user.uid, workout);
          await repo.saveWorkout(user.user.uid, workout2);
          await repo.saveWorkout(user.user.uid, workout3);
          await repo.saveWorkout(user.user.uid, workout4);
          final res = await repo.getWorkouts(user.user.uid, Pagination.firstPage());
          return res.fold(
            (fail) => TestResult.failure(fail),
            (paginated) {
              return TestResult.allOf([
                TestResult.expect(paginated.nextPage, isNull),
                TestResult.expect(paginated.list, isNotNull),
                TestResult.expect(paginated.list?.size, equals(4)),
                TestResult.expect(paginated.list?.asList(), containsAll([workout, workout2, workout3, workout4])),
              ]);
            },
          );
        } catch (e, stack) {
          return TestResult.failure(e, stack);
        }
      },
      setUp: setUp,
      tearDown: tearDown,
    );
  }

  TestSetup test1;
  TestSetup test2;
  TestSetup test3;
  TestSetup test4;

  Future<void> setUp() async {
    await Firebase.initializeApp();
    repo = FirebaseWorkoutsRepository(testFirebase.firestore);
  }

  Future<void> initialize() async {
    testFirebase = await TestFirebase.initialize();
    user = await testFirebase.auth.signInAnonymously();
  }

  Future<void> tearDownAll() async {
    await testFirebase.auth.currentUser.delete();
  }

  Future<void> tearDown() async {
    await testFirebase.firestore.doc(workoutDoc(user.user.uid, workout.id)).delete();
    await testFirebase.firestore.doc(workoutDoc(user.user.uid, workout2.id)).delete();
    await testFirebase.firestore.doc(workoutDoc(user.user.uid, workout3.id)).delete();
    await testFirebase.firestore.doc(workoutDoc(user.user.uid, workout4.id)).delete();
  }
}

class TestSetup {
  final Future<TestResult> Function() test;
  final Future<void> Function() setUp;
  final Future<void> Function() tearDown;

  TestSetup(
    this.test, {
    this.setUp,
    this.tearDown,
  });
}
