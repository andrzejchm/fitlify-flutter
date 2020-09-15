part of 'edit_measurable_property_presenter.dart';

abstract class EditMeasurablePropertyViewModel {
  MeasurablePropertyType get type;

  MeasurableProperty get property;

  KtList<MeasurablePropertyType> get availableTypes;

  bool get showAddRestButton;

  Rest get rest;
}

class EditMeasurablePropertyPresentationModel = EditMeasurablePropertyPresentationModelBase with _$EditMeasurablePropertyPresentationModel;

abstract class EditMeasurablePropertyPresentationModelBase with Store implements EditMeasurablePropertyViewModel {
  final EditMeasurablePropertyInitialParams initialParams;

  @observable
  @override
  MeasurablePropertyType type;

  @override
  KtList<MeasurablePropertyType> availableTypes;

  @computed
  @override
  MeasurableProperty get property => propertiesByType[type];

  @observable
  ObservableMap<MeasurablePropertyType, MeasurableProperty> propertiesByType;

  @override
  @computed
  bool get showAddRestButton => type == MeasurablePropertyType.sets && rest == null;

  @override
  @computed
  Rest get rest => property.rest;

  EditMeasurablePropertyPresentationModelBase(this.initialParams) {
    availableTypes = initialParams.availableTypes;
    type = initialParams.property?.type ?? availableTypes[0];
    propertiesByType = KtList.from(MeasurablePropertyType.values)
        .associate((type) => KtPair(type, MeasurableProperty.ofType(type)))
        .asMap()
        .asObservable();
    if (initialParams.property != null) {
      propertiesByType[type] = initialParams.property;
    }
  }
}
