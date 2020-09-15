import 'package:fitlify_flutter/domain/use_cases/initialize_app_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/is_logged_in_use_case.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'routing_presenter.g.dart';

part 'routing_presentation_model.dart';

part 'routing_presenter.freezed.dart';

@injectable
class RoutingPresenter {
  final RoutingPresentationModel _model;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final InitializeAppUseCase _initializeAppUseCase;

  RoutingViewModel get viewModel => _model;
  final AppNavigator _appNavigator;

  RoutingPresenter(
    this._model,
    this._appNavigator,
    this._isLoggedInUseCase,
    this._initializeAppUseCase,
  );

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        appOpened: () => _route(),
      );

  Future<void> _route() async {
    await _initializeAppUseCase.execute();
    if (!(await _isLoggedInUseCase.execute())) {
      _appNavigator.openPage(AppPageRoute.loginPage(
          fadeIn: true, initialParams: LoginInitialParams(), settings: const AppPageRouteSettings(popUntilRoot: true)));
    } else {
      _appNavigator.openPage(const AppPageRoute.main(settings: AppPageRouteSettings(popUntilRoot: true)));
    }
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.appOpened() = InteractionButtonClicked;
}
