import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:fitlify_flutter/presentation/edit_section/edit_section_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  group("EditSectionPresenter", () {
    EditSectionPresenter presenter;
    EditSectionPresentationModel model;
    EditSectionInitialParams initParams;

    void _createMvp({Section section}) {
      initParams = EditSectionInitialParams(section);
      model = EditSectionPresentationModel(initParams);
      presenter = EditSectionPresenter(model, Mocks.appNavigator);
    }

    test("opens edit rest screen on click", () async {
      //given
      _createMvp();
      final rest = Stubs.rest;
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditRest>()))) //
          .thenAnswer((_) => Future.value(rest));
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteChooseExerciseTypeDialog>()))) //
          .thenAnswer((_) => Future.value(ExerciseType.rest));
      //when
      await presenter.onViewInteraction(const Interaction.addButtonClicked(0));
      //then
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditRest>())));
      expect(model.exercises.length, 1);
      expect(model.exercises[0].data.type, ExerciseType.rest);
      expect(model.exercises[0].data.rest, rest);
    });

    test("opens edit exercise screen on click", () async {
      //given
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditExercise>()))) //
          .thenAnswer((_) => Future.value(Stubs.exercise));
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteChooseExerciseTypeDialog>()))) //
          .thenAnswer((_) => Future.value(ExerciseType.exercise));
      _createMvp();
      //when
      await presenter.onViewInteraction(const Interaction.addButtonClicked(0));
      //then
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditExercise>())));
      expect(model.exercises.length, 1);
      expect(model.exercises[0].data.type, ExerciseType.exercise);
      expect(model.exercises[0].data.id, "exerciseId");
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
