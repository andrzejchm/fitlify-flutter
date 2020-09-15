import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'edit_section_type_presenter.g.dart';

part 'edit_section_type_presentation_model.dart';

part 'edit_section_type_presenter.freezed.dart';

@injectable
class EditSectionTypePresenter {
  final EditSectionTypePresentationModel presentationModel;
  final AppNavigator _appNavigator;

  EditSectionTypeViewModel get viewModel => presentationModel;

  EditSectionTypePresenter(
    @factoryParam this.presentationModel,
    this._appNavigator,
  );

  void onViewInteraction(Interaction viewInteraction) {
    viewInteraction.when(
        onTypeSelected: (type) => presentationModel.typeEnum = type,
        onTypeChanged: (type) => presentationModel.types[type.type] = type,
        saveClicked: () => _appNavigator.closeWithResult(presentationModel.type));
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.onTypeSelected(SectionTypeEnum typeEnum) = InteractionOnTypeSelected;

  const factory Interaction.onTypeChanged(SectionType type) = InteractionTypeChanged;

  const factory Interaction.saveClicked() = InteractionSaveClicked;
}
