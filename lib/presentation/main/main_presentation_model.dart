part of 'main_presenter.dart';

abstract class MainViewModel {
  User get user;
}

class MainPresentationModel = MainPresentationModelBase with _$MainPresentationModel;

abstract class MainPresentationModelBase with Store implements MainViewModel {
  MainPresentationModelBase(this._userStore);

  @computed
  @override
  User get user => _userStore.user;

  final CurrentUserStore _userStore;
}
