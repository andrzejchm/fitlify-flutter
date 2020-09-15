import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:fitlify_flutter/domain/repositories/workouts_repository.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWorkoutsListUseCase {
  final CurrentUserStore _currentUserStore;
  final WorkoutsStore _workoutsStore;
  final WorkoutsRepository _workoutsRepository;

  GetWorkoutsListUseCase(this._currentUserStore, this._workoutsStore, this._workoutsRepository);

  Future<void> execute({bool fromScratch = true}) async {
    if (!_currentUserStore.isLoggedIn) {
      return;
    }
    debugLog("Loading workouts. from scratch: $fromScratch");
    final future = _workoutsRepository.getWorkouts(_currentUserStore.user.id, _workoutsStore.nextPage);
    _workoutsStore.setLoadingFuture(future);
    final result = await future;
    result.fold(
      (fail) => logError(fail, null, "while getting workouts list"),
      (workouts) {
        _workoutsStore.nextPage = workouts.nextPage;
        if (fromScratch) {
          _workoutsStore.workouts.clear();
        }
        _workoutsStore.workouts.addAll(workouts.list.asList());
      },
    );
  }
}
