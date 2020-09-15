import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import '../../test_doubles/mocks.dart';

void main() {
  group("Workout", () {
    test("Workout can have null id", () async {
      //given
      final workout = Workout(
        createdAt: DateTime.now(),
        name: "Name",
        sections: const KtList.empty(),
        description: "description",
        id: null,
      );
      expect(workout.id, isNull);
      //when
      //then
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
