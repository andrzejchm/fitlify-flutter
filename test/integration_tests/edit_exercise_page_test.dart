import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_exercise/edit_exercise_page.dart';
import 'package:fitlify_flutter/presentation/edit_exercise/edit_exercise_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/mockito.dart';

import '../test_doubles/mocks.dart';
import 'page_objects/edit_exercise_page_object.dart';
import 'utils/test_app.dart';

void main() {
  EditExercisePresentationModel model;
  EditExercisePresenter presenter;
  EditExercisePage page;
  EditExerciseInitialParams initParams;
  final editExercisePage = EditExercisePageObject();

  void _createMvp({Exercise exercise}) {
    initParams = EditExerciseInitialParams(exercise: exercise);
    model = EditExercisePresentationModel(initParams);
    presenter = EditExercisePresenter(model, Mocks.appNavigator);
    page = EditExercisePage(initialParams: initParams);
  }

  Future<void> _pumpPage(WidgetTester tester) async {
    await TestApp.pumpPage(tester, presenter, () => page);
  }

  group("editExercisePage", () {
    testWidgets("Add property not visible if no available property types", (tester) async {
      //given
      _createMvp(
          exercise: Exercise(
        id: "id",
        name: "name",
        properties: KtList.of(
          const MeasurableProperty.weight(),
          const MeasurableProperty.timeDuration(),
          const MeasurableProperty.distance(),
          const MeasurableProperty.sets(),
          const MeasurableProperty.repetitions(),
        ),
        type: ExerciseType.exercise,
        rest: null,
        notes: '10x per side',
      ));
      await _pumpPage(tester);
      //when
      expect(model.availablePropertyTypes, equals(const KtList.empty()));
      expect(editExercisePage.addPropertyButton, findsNothing);
      //then
    });

    testWidgets("Exercise properties do not include heart rate", (tester) async {
      _createMvp();
      expect(model.availablePropertyTypes.asList(), isNot(contains(MeasurablePropertyType.heartRate)));
    });

    testWidgets("Title is 'Add Exercise' for adding exercise case", (tester) async {
      //given
      _createMvp();
      await _pumpPage(tester);
      //when
      expect(editExercisePage.pageTitle(S.current.addExerciseTitle), findsOneWidget);
      //then
    });

    testWidgets("Title is 'Edit Exercise' for editing exercise case", (tester) async {
      //given
      _createMvp(exercise: Exercise.newExercise());
      await _pumpPage(tester);
      //when
      expect(editExercisePage.pageTitle(S.current.editExerciseTitle), findsOneWidget);
      //then
    });

    testWidgets("Adding property flow", (tester) async {
      // GIVEN
      _createMvp();
      when(Mocks.appNavigator.openPage(any))
          .thenAnswer((realInvocation) => Future<MeasurableProperty>.value(const MeasurableProperty.weight()));
      await _pumpPage(tester);

      //THEN
      await tester.tap(editExercisePage.addPropertyButton);
      await tester.pumpAndSettle();

      expect(model.availablePropertyTypes.isEmpty(), equals(false));
      verify(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditMeasurableProperty>())));
      expect(model.properties.length, equals(1));
      expect(model.properties[0].type, equals(MeasurablePropertyType.weight));
      expect(editExercisePage.measurablePropertyTile(type: MeasurablePropertyType.weight, text: "10 kg"), findsOneWidget);
    });

    setUp(() {
      Mocks.setUpDefaultMocks();
    });
  });
}
