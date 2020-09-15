import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/get_workouts_list_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogInWithAppleUseCase {
  final CurrentUserStore _userStore;
  final AuthService _authService;
  final GetWorkoutsListUseCase _getWorkoutsListUseCase;

  LogInWithAppleUseCase(this._userStore, this._authService, this._getWorkoutsListUseCase);

  Future<Either<AuthFailure, Unit>> execute() async {
    if (_userStore.isLoggedIn && !_userStore.user.isAnonymous) {
      return right(unit);
    }
    final result = await _authService.logInWithApple();
    if (result.isRight()) {
      _userStore.user = result.getOrElse(() => null);
      _getWorkoutsListUseCase.execute();
    }
    return result.map((r) => unit);
  }
}
