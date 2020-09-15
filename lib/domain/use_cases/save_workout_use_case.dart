import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:fitlify_flutter/domain/repositories/workouts_repository.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveWorkoutUseCase {
  final WorkoutsStore _workoutsStore;
  final WorkoutsRepository _workoutsRepository;
  final CurrentUserStore _currentUserStore;

  SaveWorkoutUseCase(this._workoutsStore, this._workoutsRepository, this._currentUserStore);

  Future<Either<SaveWorkoutFailure, Workout>> execute(Workout workout) async {
    if (!_currentUserStore.isLoggedIn) {
      return left(const SaveWorkoutFailure.notLoggedIn());
    }
    if (workout.id != null && workout.id.isNotEmpty) {
      return _updateWorkout(workout);
    } else {
      return _createWorkout(workout);
    }
  }

  Future<Either<SaveWorkoutFailure, Workout>> _updateWorkout(Workout workout) async {
    final result = await _workoutsRepository.saveWorkout(_currentUserStore.user.id, workout);
    result.fold(
      (fail) => logError(fail, null, "while updating existing workout ${workout.id}"),
      (updatedWorkout) {
        _workoutsStore.updateWorkout(updatedWorkout);
      },
    );
    return result;
  }

  Future<Either<SaveWorkoutFailure, Workout>> _createWorkout(Workout workout) async {
    final result = await _workoutsRepository.saveWorkout(_currentUserStore.user.id, workout);
    result.fold(
      (fail) => logError(fail, null, "while creating new workout ${workout.id}"),
      (newWorkout) => _workoutsStore.addNewWorkout(newWorkout),
    );
    return result;
  }
}
