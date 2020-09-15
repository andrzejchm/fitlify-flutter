import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:fitlify_flutter/presentation/profile/profile_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'main_presenter.g.dart';

part 'main_presentation_model.dart';

part 'main_presenter.freezed.dart';

@injectable
class MainPresenter {
  final MainPresentationModel presentationModel;
  final AppNavigator _appNavigator;
  final CurrentUserStore _userStore;

  MainViewModel get viewModel => presentationModel;

  MainPresenter(@factoryParam this.presentationModel, this._appNavigator, this._userStore);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        profileClicked: () => _openProfile(),
      );

  Future<void> _openProfile() async {
    if (_userStore.user.isAnonymous) {
      return _appNavigator.openPage(AppPageRoute.loginPage(initialParams: LoginInitialParams()));
    } else {
      return _appNavigator.openPage(AppPageRoute.profilePage(initialParams: ProfileInitialParams.currentUser()));
    }
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.profileClicked() = InteractionHistoryClicked;
}
