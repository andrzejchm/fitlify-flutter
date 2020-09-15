part of 'workouts_list_presenter.dart';

abstract class WorkoutsListViewModel {
  ObservableList<Workout> get workouts;

  int get workoutsCount;

  bool get isLoading;

  bool get isWorkoutsListEmpty;
}

class WorkoutsListPresentationModel = WorkoutsListPresentationModelBase with _$WorkoutsListPresentationModel;

abstract class WorkoutsListPresentationModelBase with Store implements WorkoutsListViewModel {
  final WorkoutsStore _workoutsStore;
  final WorkoutsListInitialParams initialParams;

  @computed
  @override
  ObservableList<Workout> get workouts => _workoutsStore.workouts;

  @computed
  @override
  int get workoutsCount => workouts?.length ?? 0;

  @computed
  @override
  bool get isWorkoutsListEmpty => workouts?.isEmpty ?? true;

  @computed
  @override
  bool get isLoading => _workoutsStore.isLoading;

  WorkoutsListPresentationModelBase(this.initialParams, this._workoutsStore);
}
