import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:fitlify_flutter/pages/edit_section/choose_exercise_type_dialog.dart';
import 'package:fitlify_flutter/presentation/edit_exercise/edit_exercise_presenter.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/presentation/model/editable.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:mobx/mobx.dart';

part 'edit_section_presenter.g.dart';

part 'edit_section_presentation_model.dart';

part 'edit_section_presenter.freezed.dart';

@injectable
class EditSectionPresenter {
  final EditSectionPresentationModel presentationModel;

  EditSectionViewModel get viewModel => presentationModel;
  final AppNavigator appNavigator;

  EditSectionPresenter(@factoryParam this.presentationModel, this.appNavigator);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        nameChanged: (text) {
          presentationModel.name = text;
        },
        descriptionChanged: (text) {
          presentationModel.description = text;
        },
        addButtonClicked: (index) => _addNewItem(index),
        saveClicked: () => appNavigator.closeWithResult(presentationModel.section),
        editExercisesClicked: () => presentationModel.editExercisesMode = !presentationModel.editExercisesMode,
        exerciseClicked: (index) => _editListItem(index),
        onExerciseReordered: (prevIndex, nextIndex) => _reorderExercises(prevIndex, nextIndex),
        onExerciseSelected: (index, selected) =>
            presentationModel.exercises[index] = presentationModel.exercises[index].byTogglingSelected(),
        deleteSelectedClicked: () {
          presentationModel.exercises = presentationModel.exercises.where((it) => !it.selected).toList().asObservable();
          presentationModel.editExercisesMode = false;
        },
        specifyTypeClicked: () => _editType(),
      );

  Future<void> _addNewItem(int index) async {
    final result = await appNavigator.openPage(AppPageRoute.chooseExerciseTypeDialog(initialParams: ChooseExerciseTypeInitialParams()));
    switch (result as ExerciseType) {
      case ExerciseType.rest:
        return _addNewRest(index);
      case ExerciseType.exercise:
        return _addNewExercise(index);
    }
  }

  Future<void> _editType() async {
    final newType = await appNavigator
        .openPage(AppPageRoute.editSectionType(initialParams: EditSectionTypeInitialParams(presentationModel.sectionType)));
    if (newType != null) {
      presentationModel.sectionType = newType as SectionType;
    }
  }

  Future<void> _addNewExercise(int index) async {
    final exercise = await appNavigator.openPage(AppPageRoute.editExercise(initialParams: EditExerciseInitialParams(exercise: null)));
    if (exercise != null) {
      presentationModel.exercises.insert(index, Editable(data: exercise as Exercise));
    }
  }

  Future<void> _addNewRest(int index) async {
    final rest = await appNavigator.openPage(const AppPageRoute.editRest(initialParams: EditRestInitialParams.newRest()));
    if (rest != null) {
      presentationModel.exercises.insert(index, Editable(data: Exercise.rest(rest as Rest)));
    }
  }

  Future<void> _editListItem(int index) async {
    final oldEx = presentationModel.exercises[index];
    if (oldEx.data.isRest) {
      return _editRest(index);
    } else {
      return _editExercise(index);
    }
  }

  Future<void> _editExercise(int index) async {
    final oldEx = presentationModel.exercises[index];
    final editedExercise =
        await appNavigator.openPage(AppPageRoute.editExercise(initialParams: EditExerciseInitialParams(exercise: oldEx.data)));
    if (editedExercise != null) {
      presentationModel.exercises[index] = oldEx.byUpdatingData(editedExercise as Exercise);
    }
  }

  Future<void> _editRest(int index) async {
    final oldEx = presentationModel.exercises[index];
    final editedRest =
        await appNavigator.openPage(AppPageRoute.editRest(initialParams: EditRestInitialParams.editRest(rest: oldEx.data.rest)));
    if (editedRest != null) {
      presentationModel.exercises[index] = oldEx.byUpdatingData(oldEx.data.copyWith(rest: editedRest as Rest));
    }
  }

  Future<void> close() async {}

  void _reorderExercises(int prevIndex, int nextIndex) {
    final temp = presentationModel.exercises[prevIndex];
    presentationModel.exercises
      ..removeAt(prevIndex)
      ..insert(nextIndex, temp);
  }
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.nameChanged(String text) = InteractionNameChanged;

  const factory Interaction.descriptionChanged(String text) = InteractionDescriptionChanged;

  const factory Interaction.saveClicked() = InteractionSaveClicked;

  const factory Interaction.addButtonClicked(int index) = InteractionAddButtonClicked;

  const factory Interaction.editExercisesClicked() = InteractionEditExercisesClicked;

  const factory Interaction.exerciseClicked(int index) = InteractionExerciseClicked;

  const factory Interaction.onExerciseReordered(int prevIndex, int nextIndex) = InteractionOnExerciseReordered;

  // ignore: avoid_positional_boolean_parameters
  const factory Interaction.onExerciseSelected(int index, bool selected) = InteractionOnExerciseSelected;

  const factory Interaction.deleteSelectedClicked() = InteractionDeleteSelectedClicked;

  const factory Interaction.specifyTypeClicked() = InteractionSpecifyTypeClicked;
}
