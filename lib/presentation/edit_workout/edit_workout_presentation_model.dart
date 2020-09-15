part of 'edit_workout_presenter.dart';

abstract class EditWorkoutViewModel {
  String get name;

  String get description;

  ObservableList<Editable<Section>> get sections;

  bool get editSectionsMode;

  bool get allSectionsExpanded;

  int get selectedSectionsCount;

  int get sectionsCount;

  bool get workoutSaveProgress;

  bool get saveError;
}

class EditWorkoutPresentationModel = EditWorkoutPresentationModelBase with _$EditWorkoutPresentationModel;

abstract class EditWorkoutPresentationModelBase with Store implements EditWorkoutViewModel {
  @observable
  @override
  String name;

  @observable
  @override
  String description;

  @observable
  @override
  bool editSectionsMode = false;

  @override
  @observable
  ObservableList<Editable<Section>> sections;

  @computed
  @override
  bool get allSectionsExpanded => sections.where((it) => !it.expanded).isEmpty;

  @computed
  @override
  int get selectedSectionsCount => sections.where((it) => it.selected).length;

  @computed
  @override
  int get sectionsCount => sections.length;

  @computed
  @override
  bool get workoutSaveProgress => workoutSaveFuture?.status == FutureStatus.pending;

  @computed
  @override
  bool get saveError => workoutSaveFuture?.status == FutureStatus.rejected || (workoutSaveFuture.value?.isLeft() ?? false);

  @computed
  Workout get workout => Workout(
        id: workoutId,
        name: name,
        description: description,
        sections: sections.toImmutableList().map((it) => it.data),
        createdAt: createdAt,
      );

  @observable
  ObservableFuture<Either<SaveWorkoutFailure, Workout>> workoutSaveFuture;

  final EditWorkoutInitialParams initialParams;
  final String workoutId;
  final DateTime createdAt;

  EditWorkoutPresentationModelBase(this.initialParams) //
      : workoutId = initialParams.workout?.id,
        createdAt = initialParams.workout?.createdAt {
    name = initialParams.workout?.name ?? "";
    description = initialParams.workout?.description ?? "";
    sections = initialParams.workout?.sections?.map((it) => Editable(data: it))?.asList()?.asObservable() ?? ObservableList();
  }
}
