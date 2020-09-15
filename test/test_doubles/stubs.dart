import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:kt_dart/kt.dart';

Future<Either<L, R>> successFuture<L, R>(R result) => Future.value(right(result));

Future<Either<L, R>> failFuture<L, R>(L result) => Future.value(left(result));

// ignore: avoid_classes_with_only_static_members
class Stubs {
  //
  static final workoutsPaginatedList = PaginatedList(null, KtList.of(Stubs.workout));

  static final rest = Rest.timeDuration(
    timeDuration: const MeasurableProperty.timeDuration(
      start: 600,
      end: 720,
    ) as MeasurablePropertyTimeDuration,
  );
  static final exercise = Exercise(
    id: "exerciseId",
    name: "name",
    properties: KtList.of(const MeasurableProperty.weight()),
    type: ExerciseType.exercise,
    rest: rest,
    notes: "note",
  );

  static final section = Section(
    id: "sectionId",
    name: "Section Name",
    description: "Short description",
    type: const SectionType.normal(),
    exercises: KtList.of(exercise),
  );

  static final workout = Workout(
    id: "workoutId",
    name: "name",
    description: "description",
    sections: KtList.of(section),
    createdAt: DateTime.now(),
  );

  static const user = User(
    id: "testUserId",
    isAnonymous: false,
    displayName: 'Test User',
    avatarUrl: 'https://i.picsum.photos/id/10/200/200.jpg?hmac=Pal2P4G4LRZVjNnjESvYwti2SuEi-LJQqUKkQUoZq_g',
  );

  static const anonymousUser = User(
    id: "testUserId",
    isAnonymous: true,
    displayName: null,
    avatarUrl: null,
  );
}
