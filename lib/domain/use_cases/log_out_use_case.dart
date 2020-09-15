import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/services/app_restarter.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogOutUseCase {
  final CurrentUserStore _currentUserStore;
  final AppRestarter appRestarter;
  final AuthService _authService;

  LogOutUseCase(this._currentUserStore, this.appRestarter, this._authService);

  Future<Either<AuthFailure, Unit>> execute() async {
    final result = await _authService.logOut();
    if (result.isRight()) {
      _currentUserStore.user = null;
      appRestarter.restartApp();
    }
    return result;
  }
}
