import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsLoggedInUseCase {
  CurrentUserStore currentUserStore;

  IsLoggedInUseCase(this.currentUserStore);

  Future<bool> execute() async {
    return currentUserStore.isLoggedIn;
  }
}
