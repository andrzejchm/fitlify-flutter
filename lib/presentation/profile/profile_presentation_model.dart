part of 'profile_presenter.dart';

abstract class ProfileViewModel {
  User get user;
  bool get logOutProgress;
}

class ProfilePresentationModel = ProfilePresentationModelBase with _$ProfilePresentationModel;

abstract class ProfilePresentationModelBase with Store implements ProfileViewModel {
  final ProfileInitialParams initialParams;
  final CurrentUserStore _userStore;

  @computed
  @override
  bool get logOutProgress => logOutFuture != null && logOutFuture.status == FutureStatus.pending;

  @computed
  bool get isCurrentUser => _userStore.isCurrentUser(initialParams.user?.id);

  @computed
  @override
  User get user => isCurrentUser ? _userStore.user : initialParams.user;

  @observable
  ObservableFuture<Either<AuthFailure, Unit>> logOutFuture;

  ProfilePresentationModelBase(this.initialParams, this._userStore);
}
