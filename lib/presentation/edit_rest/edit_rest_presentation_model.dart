part of 'edit_rest_presenter.dart';

abstract class EditRestViewModel {
  RestType get type;

  ObservableList<RestType> get availableTypes;

  Rest get rest;
}

class EditRestPresentationModel = EditRestPresentationModelBase with _$EditRestPresentationModel;

abstract class EditRestPresentationModelBase with Store implements EditRestViewModel {
  final EditRestInitialParams initialParams;

  @observable
  @override
  RestType type = RestType.timeDuration;

  @observable
  ObservableMap<RestType, Rest> types;

  @override
  ObservableList<RestType> availableTypes = RestType.values.asObservable();

  @computed
  @override
  Rest get rest => types[type];

  EditRestPresentationModelBase(this.initialParams) {
    type = initialParams.rest?.type ?? RestType.timeDuration;
    types = RestAvailableValues.list.associateBy((it) => it.type).asMap().asObservable();
    if (initialParams.rest != null) {
      types[initialParams.rest.type] = initialParams.rest;
    }
  }
}
