import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  WorkoutsStore store;
  group("WorkoutsStore", () {
    test("workouts list is empty on start", () async {
      expect(store.workouts, isEmpty);
    });

    test("updating a workout adds it to the list if it does not exist", () async {
      //
      store.updateWorkout(Stubs.workout);

      expect(store.workouts, hasLength(equals(1)));
      expect(store.workouts[0], equals(Stubs.workout));
    });

    test("updating a workout updates it on the list", () async {
      //
      store.updateWorkout(Stubs.workout.copyWith(id: "1"));
      store.updateWorkout(Stubs.workout.copyWith(id: "2"));
      store.updateWorkout(Stubs.workout.copyWith(id: "3"));

      expect(store.workouts.firstWhere((element) => element.id == "1").name, isNot(equals("updated")));
      expect(store.workouts, hasLength(equals(3)));

      store.updateWorkout(Stubs.workout.copyWith(id: "1", name: "updated"));

      expect(store.workouts, hasLength(equals(3)));
      expect(store.workouts[2].id, equals("1"));
      expect(store.workouts[2].name, equals("updated"));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    store = WorkoutsStore();
  });
}
