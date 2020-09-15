import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/presentation/edit_exercise/edit_exercise_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_doubles/mocks.dart';

void main() {
  EditExercisePresenter presenter;
  EditExercisePresentationModel model;
  EditExerciseInitialParams initParams;

  void _initMvp({Exercise exercise}) {
    initParams = EditExerciseInitialParams(exercise: exercise);
    model = EditExercisePresentationModel(initParams);
    presenter = EditExercisePresenter(model, Mocks.appNavigator);
  }

  group("EditExercisePresenter", () {});

  group("EditExercisePresentationModel", () {
    test("cannot create model with rest type", () async {
      //
      expect(
        () => _initMvp(
            exercise: Exercise.rest(Rest.timeDuration(
                timeDuration: const MeasurableProperty.timeDuration(start: 1200, end: 1200) as MeasurablePropertyTimeDuration))),
        throwsA(allOf(isAssertionError.having(
            (it) => it.message, "message", equals("Cannot edit exercise with 'rest' type. use edit_rest_page for that")))),
      );
    });

    test("adds property", () async {
      _initMvp();
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditMeasurableProperty>())))
          .thenAnswer((_) => Future.value(const MeasurableProperty.timeDuration()));

      expect(model.properties.length, 0);
      await presenter.onViewInteraction(const Interaction.addPropertyClicked());
      expect(model.properties.length, 1);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
