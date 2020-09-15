import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'edit_rest_presenter.g.dart';

part 'edit_rest_presentation_model.dart';

part 'edit_rest_presenter.freezed.dart';

@injectable
class EditRestPresenter {
  final EditRestPresentationModel presentationModel;
  final AppNavigator _appNavigator;

  EditRestViewModel get viewModel => presentationModel;

  EditRestPresenter(@factoryParam this.presentationModel, this._appNavigator);

  @action
  void onViewInteraction(Interaction viewInteraction) {
    viewInteraction.when(
      onTypeSelected: (type) => presentationModel.type = type,
      onRestChanged: (rest) => presentationModel.types[rest.type] = rest,
      saveClicked: () => _appNavigator.closeWithResult(presentationModel.rest),
    );
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.onTypeSelected(RestType type) = InteractionOnTypeSelected;

  const factory Interaction.onRestChanged(Rest rest) = InteractionOnRestChanged;

  const factory Interaction.saveClicked() = InteractionSaveClicked;
}
