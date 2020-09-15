import 'package:fitlify_flutter/data/firebase/model/firestore_workout.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_doubles/mocks.dart';
import '../test_doubles/stubs.dart';

void main() {
  group("FirestoreWorkout", () {
    test("maps from Workout", () async {
      //given
      //when
      final workout = FirestoreWorkout.fromWorkout(Stubs.workout);
      //then
      expect(
        workout.name,
        allOf(isNotNull, equals(Stubs.workout.name)),
      );
      expect(
        workout.description,
        allOf(isNotNull, equals(Stubs.workout.description)),
      );
      expect(
        workout.sections.length,
        allOf(isNotNull, equals(Stubs.workout.sections.size)),
      );
      expect(
        workout.sections[0].id,
        allOf(isNotNull, equals(Stubs.workout.sections[0].id)),
      );
      expect(
        workout.sections[0].name,
        allOf(isNotNull, equals(Stubs.workout.sections[0].name)),
      );
      expect(
        workout.sections[0].description,
        allOf(isNotNull, equals(Stubs.workout.sections[0].description)),
      );
      expect(
        workout.sections[0].exercises.length,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises.size)),
      );
      expect(
        workout.sections[0].exercises[0].id,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].id)),
      );
      expect(
        workout.sections[0].exercises[0].name,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].name)),
      );
      expect(
        workout.sections[0].exercises[0].properties.length,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].properties.size)),
      );
      expect(
        workout.sections[0].exercises[0].properties[0].start,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].properties[0].start)),
      );
      expect(
        workout.sections[0].exercises[0].properties[0].end,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].properties[0].end)),
      );
      expect(
        workout.sections[0].exercises[0].properties[0].isRange,
        allOf(isNotNull, equals(Stubs.workout.sections[0].exercises[0].properties[0].isRange)),
      );
    });

    test("maps to null from null", () async {
      //given
      //when
      final workout = FirestoreWorkout.fromWorkout(null);
      //then
      expect(workout, isNull);
    });

    test("generates deep json", () async {
      //given
      //when
      final json = FirestoreWorkout.fromWorkout(Stubs.workout).toJson();
      //then
      expect(json["sections"][0]["exercises"][0]["id"], equals(Stubs.workout.sections[0].exercises[0].id));
    });

    test("parses back to domain object", () async {
      //given
      //when
      final json = FirestoreWorkout.fromWorkout(Stubs.workout).toJson();
      final parsed = FirestoreWorkout.fromJson(json).toDomain(Stubs.workout.id);
      //then
      expect(parsed, equals(Stubs.workout));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
