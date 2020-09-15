import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:injectable/injectable.dart';

import 'get_workouts_list_use_case.dart';

@injectable
class LogInAnonymouslyUseCase {
  final AuthService _authService;
  final CurrentUserStore _currentUserStore;
  final GetWorkoutsListUseCase _getWorkoutsListUseCase;

  LogInAnonymouslyUseCase(
    this._currentUserStore,
    this._authService,
    this._getWorkoutsListUseCase,
  );

  Future<Either<AuthFailure, Unit>> execute() async {
    if (_currentUserStore.isLoggedIn) {
      debugLog("User is already logged in, aborting anonymous login");
      return right(unit);
    }

    debugLog("User is not logged in. Logging in anonymously...");

    final result = await _authService.logInAnonymously();
    result.fold(
      (fail) => logError(fail, null, 'while logging in anonymously'),
      (user) => _currentUserStore.user = user,
    );

    if (result.isRight()) {
      _getWorkoutsListUseCase.execute();
    }
    return result.map((r) => unit);
  }
}
