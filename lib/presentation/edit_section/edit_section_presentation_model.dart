part of 'edit_section_presenter.dart';

abstract class EditSectionViewModel {
  String get name;

  String get description;

  ObservableList<Editable<Exercise>> get exercises;

  String get sectionId;

  bool get editExercisesMode;

  int get exercisesCount;

  int get selectedExercisesCount;

  SectionType get sectionType;
}

class EditSectionPresentationModel = EditSectionPresentationModelBase with _$EditSectionPresentationModel;

abstract class EditSectionPresentationModelBase with Store implements EditSectionViewModel {
  @override
  @observable
  String name;

  @override
  @observable
  String description;

  @override
  @observable
  ObservableList<Editable<Exercise>> exercises;

  @override
  @observable
  SectionType sectionType;

  @override
  @observable
  String sectionId;

  @override
  @observable
  bool editExercisesMode = false;

  @computed
  @override
  int get exercisesCount => exercises.length;

  @computed
  @override
  int get selectedExercisesCount => exercises.where((it) => it.selected).length;

  @computed
  Section get section => Section(
        id: sectionId,
        description: description,
        exercises: exercises.toImmutableList().map((it) => it.data),
        type: sectionType,
        name: name,
      );

  final EditSectionInitialParams initialParams;

  EditSectionPresentationModelBase(this.initialParams) {
    sectionId = initialParams.section?.id ?? "";
    name = initialParams.section?.name ?? "";
    description = initialParams.section?.description ?? "";
    exercises = initialParams.section?.exercises?.map((it) => Editable(data: it))?.asList()?.asObservable() ?? ObservableList();
    sectionType = initialParams.section?.type ?? const SectionType.normal();
  }
}

class EditSectionInitialParams {
  final Section section;

  EditSectionInitialParams(this.section);
}
