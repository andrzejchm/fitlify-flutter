import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/use_cases/log_out_use_case.dart';
import 'package:fitlify_flutter/presentation/profile/profile_initial_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'profile_presenter.g.dart';

part 'profile_presentation_model.dart';

part 'profile_presenter.freezed.dart';

@injectable
class ProfilePresenter {
  final ProfilePresentationModel _model;
  final LogOutUseCase _logOutUseCase;

  ProfileViewModel get viewModel => _model;

  ProfilePresenter(@factoryParam this._model, this._logOutUseCase);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        logOutClicked: () => _logOut(),
      );

  Future<void> _logOut() async {
    _model.logOutFuture = _logOutUseCase.execute().asObservable();
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.logOutClicked() = InteractionLogOutClicked;
}
