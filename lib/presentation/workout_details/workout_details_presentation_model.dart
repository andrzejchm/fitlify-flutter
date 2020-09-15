part of 'workout_details_presenter.dart';

abstract class WorkoutDetailsViewModel {
  Workout get workout;
}

class WorkoutDetailsPresentationModel = WorkoutDetailsPresentationModelBase with _$WorkoutDetailsPresentationModel;

abstract class WorkoutDetailsPresentationModelBase with Store implements WorkoutDetailsViewModel {
  final WorkoutDetailsInitialParams initialParams;
  final WorkoutsStore _workoutsStore;

  @computed
  @override
  Workout get workout => _workoutsStore.workoutsMap[initialParams.workout.id] ?? initialParams.workout;

  WorkoutDetailsPresentationModelBase(this.initialParams, this._workoutsStore);
}
