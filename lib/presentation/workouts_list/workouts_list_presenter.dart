import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/workout_details/workout_details_initial_params.dart';
import 'package:fitlify_flutter/presentation/workouts_list/workouts_list_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'workouts_list_presenter.g.dart';

part 'workouts_list_presentation_model.dart';

part 'workouts_list_presenter.freezed.dart';

@injectable
class WorkoutsListPresenter {
  final WorkoutsListPresentationModel presentationModel;
  final AppNavigator _appNavigator;

  WorkoutsListViewModel get viewModel => presentationModel;

  WorkoutsListPresenter(@factoryParam this.presentationModel, this._appNavigator);

  void onViewInteraction(Interaction viewInteraction) {
    viewInteraction.when(
      createWorkoutClicked: () => _appNavigator.openPage(AppPageRoute.editWorkout(
        initialParams: EditWorkoutInitialParams(null),
      )),
      onWorkoutClicked: (Workout workout) => _appNavigator.openPage(AppPageRoute.workoutDetails(
        initialParams: WorkoutDetailsInitialParams(workout),
      )),
    );
  }

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.createWorkoutClicked() = InteractionCreateWorkoutClicked;

  const factory Interaction.onWorkoutClicked(Workout workout) = InteractionOnWorkoutClicked;
}
