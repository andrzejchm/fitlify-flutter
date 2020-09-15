import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'edit_exercise_presenter.g.dart';

part 'edit_exercise_presentation_model.dart';

part 'edit_exercise_presenter.freezed.dart';

@injectable
class EditExercisePresenter {
  final EditExercisePresentationModel presentationModel;

  final AppNavigator _appNavigator;

  EditExerciseViewModel get viewModel => presentationModel;

  EditExercisePresenter(@factoryParam this.presentationModel, this._appNavigator);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        saveClicked: () => _appNavigator.closeWithResult(presentationModel.exercise),
        nameChanged: (text) => presentationModel.name = text,
        addPropertyClicked: () => _addNewProperty(),
        onPropertyClicked: (property) => _editProperty(property),
        deletePropertyClicked: (property) => _deleteProperty(property),
        notesChanged: (notes) => presentationModel.notes = notes,
        addNotesClicked: () => presentationModel.showNotesTextField = true,
      );

  Future<void> close() async {}

  Future<void> _addNewProperty() async {
    final newProperty = await _appNavigator.openPage(
      AppPageRoute.editMeasurableProperty(
          initialParams: EditMeasurablePropertyInitialParams(null, presentationModel.availablePropertyTypes)),
    );
    if (newProperty != null) {
      presentationModel.properties.add(newProperty as MeasurableProperty);
    }
  }

  Future<void> _editProperty(MeasurableProperty property) async {
    final prop = await _appNavigator.openPage(
      AppPageRoute.editMeasurableProperty(
        initialParams: EditMeasurablePropertyInitialParams(
          property,
          presentationModel.availablePropertyTypes.toMutableList()..addAt(0, property.type),
        ),
      ),
    ) as MeasurableProperty;
    if (prop != null) {
      final index = presentationModel.properties.indexWhere((element) => element.type == property.type);
      presentationModel.properties[index] = prop;
    }
  }

  void _deleteProperty(MeasurableProperty property) {
    presentationModel.properties.removeWhere((element) => element.type == property.type);
  }
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.saveClicked() = InteractionSaveClicked;

  const factory Interaction.nameChanged(String text) = InteractionNameChanged;

  const factory Interaction.addPropertyClicked() = InteractionAddPropertyClicked;

  const factory Interaction.onPropertyClicked(MeasurableProperty property) = InteractionOnPropertyClicked;

  const factory Interaction.deletePropertyClicked(MeasurableProperty element) = InteractionDeletePropertyClicked;

  const factory Interaction.notesChanged(String notes) = InteractionNotesChanged;

  const factory Interaction.addNotesClicked() = InteractionAddNotesClicked;
}
