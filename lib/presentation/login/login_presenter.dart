import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_anonymously_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_with_apple_use_case.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'login_presenter.g.dart';

part 'login_presentation_model.dart';

part 'login_presenter.freezed.dart';

@injectable
class LoginPresenter {
  final LoginPresentationModel _model;
  final LogInWithAppleUseCase appleLogInUseCase;
  final LogInAnonymouslyUseCase logInAnonymouslyUseCase;
  final AppNavigator _appNavigator;

  LoginViewModel get viewModel => _model;

  LoginPresenter(@factoryParam this._model, this.appleLogInUseCase, this._appNavigator, this.logInAnonymouslyUseCase);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        appleLogInClicked: () => _logInWithApple(),
        anonymousLogInClicked: () => _logInAnonymously(),
      );

  Future<void> close() async {}

  Future<void> _logInWithApple() async {
    if (_model.logInProgress) {
      return;
    }
    _model.logInFuture = appleLogInUseCase.execute().asObservable();
    final result = await _model.logInFuture;
    result.fold(
      (fail) => _appNavigator.openPage(AppPageRoute.errorDialog(error: fail.toDisplayableError())),
      (r) => _appNavigator.openPage(const AppPageRoute.routing()),
    );
  }

  Future<void> _logInAnonymously() async {
    final result = await logInAnonymouslyUseCase.execute();
    if (result.isRight()) {
      _appNavigator.openPage(const AppPageRoute.routing());
    }
  }
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.appleLogInClicked() = InteractionAppleLogInClicked;

  const factory Interaction.anonymousLogInClicked() = InteractionAnonymousLogInClicked;
}
