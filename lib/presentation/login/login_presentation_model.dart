part of 'login_presenter.dart';

abstract class LoginViewModel {
  bool get logInProgress;
}

class LoginPresentationModel = LoginPresentationModelBase with _$LoginPresentationModel;

abstract class LoginPresentationModelBase with Store implements LoginViewModel {
  final LoginInitialParams initialParams;

  @observable
  ObservableFuture<Either<AuthFailure, Unit>> logInFuture;

  @computed
  @override
  bool get logInProgress => logInFuture != null && logInFuture.status == FutureStatus.pending;

  LoginPresentationModelBase(this.initialParams);
}
