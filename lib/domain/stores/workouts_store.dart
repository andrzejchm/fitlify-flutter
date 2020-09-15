import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/extensions.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'workouts_store.g.dart';

@lazySingleton
class WorkoutsStore = WorkoutsStoreBase with _$WorkoutsStore;

abstract class WorkoutsStoreBase with Store {
  Pagination nextPage = Pagination.firstPage();

  @observable
  // ignore: prefer_final_fields
  ObservableList<Workout> _workouts = ObservableList();

  @observable
  ObservableFuture<Either<SaveWorkoutFailure, PaginatedList<Workout>>> _loadingFuture;

  @computed
  bool get isLoading => _loadingFuture != null && _loadingFuture.status == FutureStatus.pending;

  @computed
  ObservableList<Workout> get workouts => _workouts;

  @computed
  ObservableMap<String, Workout> get workoutsMap => workouts //
      .toImmutableList()
      .associateBy((it) => it.id)
      .asMap()
      .asObservable();

  WorkoutsStoreBase();

  @action
  void setLoadingFuture(Future<Either<SaveWorkoutFailure, PaginatedList<Workout>>> future) {
    _loadingFuture = future.asObservable();
  }

  @action
  void addNewWorkout(Workout newWorkout) {
    workouts.insert(0, newWorkout);
  }

  @action
  void updateWorkout(Workout updatedWorkout) {
    final isListUpdated = workouts.updateWhere((item) => item.id == updatedWorkout.id, to: updatedWorkout);
    if (!isListUpdated) {
      workouts.insert(0, updatedWorkout);
    }
  }
}
