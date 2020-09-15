part of 'edit_exercise_presenter.dart';

abstract class EditExerciseViewModel {
  String get name;

  String get notes;

  ObservableList<MeasurableProperty> get sortedProperties;

  String get id;

  bool get canAddMoreProperties;

  bool get showNotesTextField;
}

class EditExercisePresentationModel = EditExercisePresentationModelBase with _$EditExercisePresentationModel;

abstract class EditExercisePresentationModelBase with Store implements EditExerciseViewModel {
  final EditExerciseInitialParams initialParams;

  @observable
  @override
  String name;

  @observable
  @override
  String notes;

  @observable
  @override
  String id;

  @observable
  ObservableList<MeasurableProperty> properties;

  @computed
  @override
  ObservableList<MeasurableProperty> get sortedProperties => properties..sort((a, b) => a.type.index.compareTo(b.type.index));

  @computed
  @override
  bool get canAddMoreProperties => availablePropertyTypes.isNotEmpty();

  @observable
  Rest rest;

  @override
  @observable
  bool showNotesTextField;

  @computed
  KtList<MeasurablePropertyType> get availablePropertyTypes => KtMutableList.from(MeasurablePropertyTypeExerciseValues.exerciseValues) //
      .filter((type) => properties.every((prop) => prop.type != type)); //

  Exercise get exercise => Exercise(
        id: id,
        properties: properties.toImmutableList(),
        name: name,
        type: ExerciseType.exercise,
        rest: rest,
        notes: notes,
      );

  EditExercisePresentationModelBase(this.initialParams)
      : assert(initialParams.exercise?.type != ExerciseType.rest, "Cannot edit exercise with 'rest' type. use edit_rest_page for that") {
    id = initialParams.exercise?.id ?? "";
    name = initialParams.exercise?.name ?? "";
    notes = initialParams.exercise?.notes ?? "";
    properties = initialParams.exercise?.properties?.asList()?.asObservable() ?? ObservableList();
    rest = initialParams.exercise?.rest;
    showNotesTextField = notes.isNotEmpty;
  }
}

class EditExerciseInitialParams {
  final Exercise exercise;

  EditExerciseInitialParams({@required this.exercise});
}
