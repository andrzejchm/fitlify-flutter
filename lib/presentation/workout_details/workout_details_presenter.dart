import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/workout_details/workout_details_initial_params.dart';
import 'package:fitlify_flutter/presentation/workout_pdf_preview/workout_pdf_preview_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'workout_details_presenter.g.dart';

part 'workout_details_presentation_model.dart';

part 'workout_details_presenter.freezed.dart';

@injectable
class WorkoutDetailsPresenter {
  final WorkoutDetailsPresentationModel _model;
  final AppNavigator _appNavigator;

  WorkoutDetailsViewModel get viewModel => _model;

  WorkoutDetailsPresenter(@factoryParam this._model, this._appNavigator);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(
        editClicked: () => _editWorkout(),
        exportToPdfClicked: () =>
            _appNavigator.openPage(AppPageRoute.workoutPdfPreview(initialParams: WorkoutPdfPreviewInitialParams(_model.workout))),
      );

  Future<void> _editWorkout() {
    return _appNavigator.openPage(
      AppPageRoute.editWorkout(initialParams: EditWorkoutInitialParams(_model.workout)),
    );
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.editClicked() = InteractionEditClicked;

  const factory Interaction.exportToPdfClicked() = InteractionExportToPdfClicked;
}
