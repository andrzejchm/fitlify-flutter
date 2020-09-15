part of 'edit_section_type_presenter.dart';

abstract class EditSectionTypeViewModel {
  SectionType get type;

  ObservableList<SectionTypeEnum> get availableTypes;
}

class EditSectionTypePresentationModel = EditSectionTypePresentationModelBase with _$EditSectionTypePresentationModel;

abstract class EditSectionTypePresentationModelBase with Store implements EditSectionTypeViewModel {
  final EditSectionTypeInitialParams initialParams;

  @computed
  @override
  SectionType get type => types[typeEnum];

  @observable
  SectionTypeEnum typeEnum;

  @computed
  @override
  ObservableList<SectionTypeEnum> get availableTypes => SectionTypeEnum.values.asObservable();

  @observable
  ObservableMap<SectionTypeEnum, SectionType> types = SectionTypes.availableTypes.associateBy((it) => it.type).asMap().asObservable();

  EditSectionTypePresentationModelBase(this.initialParams) {
    typeEnum = initialParams?.type?.type ?? SectionTypeEnum.normal;
    if (initialParams?.type != null) {
      types[typeEnum] = initialParams?.type;
    }
  }
}
