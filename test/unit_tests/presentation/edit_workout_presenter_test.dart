import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  EditWorkoutInitialParams initParams;
  EditWorkoutPresentationModel presentationModel;
  EditWorkoutPresenter presenter;
  Completer<Either<SaveWorkoutFailure, Workout>> completer;

  void _initMvp({Workout workout}) {
    initParams = EditWorkoutInitialParams(workout);
    presentationModel = EditWorkoutPresentationModel(initParams);
    presenter = EditWorkoutPresenter(presentationModel, Mocks.appNavigator, Mocks.saveWorkoutUseCase);
  }

  group("editWorkoutPresenter", () {
    test("saves workout in backend", () async {
      //given
      when(Mocks.saveWorkoutUseCase.execute(any)).thenAnswer((_) => completer.future);
      _initMvp(workout: Stubs.workout);
      //when
      presenter.onViewInteraction(const Interaction.saveClicked());
      //then
      expect(presentationModel.workoutSaveProgress, isTrue);
      completer.complete(right(Stubs.workout));
      await completer.future;
      verify(Mocks.saveWorkoutUseCase.execute(Stubs.workout));
      expect(presentationModel.workoutSaveProgress, isFalse);
      expect(presentationModel.saveError, isFalse);
    });

    test("shows error when saving fails", () async {
      //given
      when(Mocks.saveWorkoutUseCase.execute(any)).thenAnswer((_) => completer.future);
      _initMvp(workout: Stubs.workout);
      //when
      presenter.onViewInteraction(const Interaction.saveClicked());
      //then
      expect(presentationModel.workoutSaveProgress, isTrue);

      completer.complete(left(SaveWorkoutFailure.unknown("ExpectedError", StackTrace.current)));
      await presentationModel.workoutSaveFuture;

      verify(Mocks.saveWorkoutUseCase.execute(Stubs.workout));
      expect(presentationModel.saveError, isTrue);
      expect(presentationModel.workoutSaveProgress, isFalse);
    });

    test("presentation model is populated with workout values", () async {
      _initMvp(workout: Stubs.workout);

      expect(presentationModel.workout, equals(Stubs.workout));
      expect(presentationModel.workoutId, allOf(equals(Stubs.workout.id), isNotNull));
      expect(presentationModel.name, allOf(equals(Stubs.workout.name), isNotNull));
      expect(presentationModel.description, allOf(equals(Stubs.workout.description), isNotNull));
      expect(presentationModel.description, allOf(equals(Stubs.workout.description), isNotNull));
      expect(presentationModel.sections.toList().map((e) => e.data.id),
          allOf(equals(Stubs.workout.sections.asList().map((e) => e.id)), isNotNull));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    completer = Completer();
    _initMvp();
  });
}
