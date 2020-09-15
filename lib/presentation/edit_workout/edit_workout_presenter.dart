import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:fitlify_flutter/domain/use_cases/save_workout_use_case.dart';
import 'package:fitlify_flutter/presentation/edit_section/edit_section_presenter.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/model/editable.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'edit_workout_presenter.g.dart';

part 'edit_workout_presentation_model.dart';

part 'edit_workout_presenter.freezed.dart';

@injectable
class EditWorkoutPresenter {
  final EditWorkoutPresentationModel presentationModel;
  final AppNavigator appNavigator;
  final SaveWorkoutUseCase saveWorkoutUseCase;

  EditWorkoutViewModel get viewModel => presentationModel;

  EditWorkoutPresenter(@factoryParam this.presentationModel, this.appNavigator, this.saveWorkoutUseCase);

  Future<void> onViewInteraction(Interaction viewInteraction) async {
    viewInteraction.when(
      nameChanged: (text) => presentationModel.name = text,
      descriptionChanged: (text) => presentationModel.description = text,
      sectionReordered: (oldIndex, newIndex) => _reorderSections(oldIndex, newIndex),
      addSectionClicked: (index) => _createNewSection(index),
      saveClicked: () => _saveWorkout(),
      sectionClicked: (index) => _editSection(index),
      editSectionsClicked: () => presentationModel.editSectionsMode = !presentationModel.editSectionsMode,
      expandAllClicked: () => _expandAll(),
      deleteSelectedSectionsClicked: () => _deleteSelectedSections(),
      onSectionSelectClicked: (index) => presentationModel.sections[index] = presentationModel.sections[index].byTogglingSelected(),
      onSectionExpandClicked: (index) => presentationModel.sections[index] = presentationModel.sections[index].byTogglingExpanded(),
    );
  }

  void _deleteSelectedSections() {
    presentationModel.sections = presentationModel.sections.where((it) => !it.selected).toList().asObservable();
    presentationModel.editSectionsMode = false;
  }

  void _expandAll() {
    final expand = !presentationModel.allSectionsExpanded;
    for (var i = 0; i < presentationModel.sections.length; i += 1) {
      presentationModel.sections[i] = presentationModel.sections[i].copyWith(expanded: expand);
    }
  }

  Future<void> _createNewSection(int index) async {
    final section = await appNavigator.openPage(
      AppPageRoute.editSection(
        initialParams: EditSectionInitialParams(Section.newSection()),
      ),
    );
    if (section != null) {
      presentationModel.sections.insert(index, Editable(data: section as Section));
    }
  }

  Future<void> close() async {}

  void _reorderSections(int oldIndex, int newIndex) {
    final temp = presentationModel.sections[oldIndex];
    presentationModel.sections
      ..removeAt(oldIndex)
      ..insert(newIndex, temp);
  }

  Future<void> _editSection(int index) async {
    final expandable = presentationModel.sections[index];
    final section = await appNavigator.openPage(AppPageRoute.editSection(initialParams: EditSectionInitialParams(expandable.data)));
    if (section != null) {
      presentationModel.sections[index] = Editable(data: section as Section, expanded: expandable.expanded);
    }
  }

  Future<void> _saveWorkout() async {
    if (presentationModel.workoutSaveProgress) {
      return;
    }
    final future = presentationModel.workoutSaveFuture = saveWorkoutUseCase.execute(presentationModel.workout).asObservable();
    final result = await future;
    if (result.isRight()) {
      appNavigator.close();
    }
  }
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.nameChanged(String text) = InteractionNameChanged;

  const factory Interaction.descriptionChanged(String text) = InteractionDescriptionChanged;

  const factory Interaction.sectionReordered(int oldIndex, int newIndex) = InteractionSectionReordered;

  const factory Interaction.addSectionClicked(int atIndex) = InteractionAddSexctionClicked;

  const factory Interaction.saveClicked() = InteractionSaveClicked;

  const factory Interaction.sectionClicked(int index) = InteractionSectionClicked;

  const factory Interaction.editSectionsClicked() = InteractionEditSectionsClicked;

  const factory Interaction.expandAllClicked() = InteractionExpandAllClicked;

  const factory Interaction.deleteSelectedSectionsClicked() = InteractionDeleteSelectedSectionsClicked;

  const factory Interaction.onSectionSelectClicked(int index) = InteractionOnSectionSelected;

  const factory Interaction.onSectionExpandClicked(int index) = InteractionOnSectionExpandClicked;
}
