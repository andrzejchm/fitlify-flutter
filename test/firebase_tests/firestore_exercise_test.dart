import 'package:fitlify_flutter/data/firebase/model/firestore_exercise.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_doubles/mocks.dart';
import '../test_doubles/stubs.dart';

void main() {
  group("FirestoreExercise", () {
    test("missing type is treated as exercise", () async {
      //
      final ex = FirestoreExercise.fromJson({"name": "name", "id": "id", "properties": []}).toDomain();

      expect(ex.type, ExerciseType.exercise);
    });

    test("id is created if missing", () {
      //
      final ex = FirestoreExercise.fromExercise(Stubs.exercise.copyWith(id: null));

      expect(ex.id, allOf(isNotNull, isNotEmpty));
    });

    test("null exercise is mapped to null", () {
      expect(FirestoreExercise.fromExercise(null), isNull);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
