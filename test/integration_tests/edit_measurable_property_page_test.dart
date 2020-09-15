import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/pages/edit_property/edit_measurable_property_page.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_presenter.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/kt.dart';
import 'package:mockito/mockito.dart';

import '../test_doubles/mocks.dart';
import 'robots/edit_measurable_property_robot.dart';
import 'utils/test_app.dart';

void main() {
  EditMeasurablePropertyInitialParams initParams;
  EditMeasurablePropertyPresentationModel model;
  EditMeasurablePropertyPresenter presenter;
  EditMeasurablePropertyPage page;
  EditMeasurablePropertyRobot robot;

  void _initMvp(WidgetTester tester, {MeasurableProperty property, KtList<MeasurablePropertyType> availableTypes}) {
    initParams = EditMeasurablePropertyInitialParams(
      property,
      availableTypes ?? KtList.from(MeasurablePropertyTypeExerciseValues.exerciseValues),
    );
    model = EditMeasurablePropertyPresentationModel(initParams);
    presenter = EditMeasurablePropertyPresenter(model, Mocks.appNavigator);
    page = EditMeasurablePropertyPage(initialParams: initParams);
    robot = EditMeasurablePropertyRobot(tester);
  }

  group("EditMeasurablePropertyPage", () {
    testWidgets("sets property allows selecting rest", (tester) async {
      when(Mocks.appNavigator.openPage(argThat(isA<AppPageRouteEditRest>()))).thenAnswer((_) => Future.value(Rest.indefiniteTimeDuration));

      _initMvp(tester);
      await TestApp.pumpPage(tester, presenter, () => page);
      await robot.addRestButton.expectOneWidget();
      await robot.restBadge.expectNotPresent();
      await robot.typesDropdownButton.tap();
      await robot.typeMenuItem(MeasurablePropertyType.repetitions).tap();
      await robot.addRestButton.expectNotPresent();
      await robot.typesDropdownButton.tap();
      await robot.typeMenuItem(MeasurablePropertyType.sets).tap();
      await robot.addRestButton.expectOneWidget();
      await robot.addRestButton.tap();
      await robot.restBadge.expectOneWidget();
    });

    testWidgets("displays badge with rest specs for 'sets' type, if specified", (tester) async {
      _initMvp(tester, property: const MeasurableProperty.sets(start: 4, end: 4, isRange: false));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
