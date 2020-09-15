import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'current_user_store.g.dart';

@lazySingleton
class CurrentUserStore = CurrentUserStoreBase with _$CurrentUserStore;

abstract class CurrentUserStoreBase with Store {
  @observable
  User user;

  CurrentUserStoreBase();

  @computed
  bool get isLoggedIn => user != null;

  bool isCurrentUser(String id) => id == null || id == user?.id;
}
