import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';

abstract class WorkoutsRepository {
  Future<Either<SaveWorkoutFailure, Workout>> saveWorkout(String userId, Workout workout);

  Future<Either<SaveWorkoutFailure, PaginatedList<Workout>>> getWorkouts(String userId, Pagination page);
}
