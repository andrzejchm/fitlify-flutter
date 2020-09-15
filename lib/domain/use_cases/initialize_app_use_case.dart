import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/get_workouts_list_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAppUseCase {
  final AuthService _authService;
  final CurrentUserStore _currentUserStore;
  final GetWorkoutsListUseCase _getWorkoutsListUseCase;

  InitializeAppUseCase(this._authService, this._currentUserStore, this._getWorkoutsListUseCase);

  Future<void> execute() async {
    if (_currentUserStore.isLoggedIn) {
      debugLog("App already initialized.", this);
      return;
    }
    debugLog("Initializing App...", this);
    final result = await _authService.getCurrentUser();
    result.fold(
      (fail) => fail.map(
        //that's totally fine.
        notLoggedIn: (_) => null,
        unknown: (unknown) => logError(unknown.error, null, unknown.reason),
        credentialAlreadyInUse: (value) => logError(value),
      ),
      (user) async {
        _currentUserStore.user = user;
        await _getWorkoutsListUseCase.execute();
      },
    );
    debugLog("CurrentUserStore initialized with user: ${_currentUserStore.user}", this);
  }
}
