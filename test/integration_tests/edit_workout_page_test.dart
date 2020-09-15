import 'package:fitlify_flutter/pages/edit_workout/edit_workout_page.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_doubles/mocks.dart';
import 'utils/test_app.dart';

void main() {
  EditWorkoutPresentationModel model;
  EditWorkoutPage page;
  EditWorkoutInitialParams initParams;
  EditWorkoutPresenter presenter;

  group("Edit Workout Page", () {
    testWidgets("Page starts", (tester) async {
      //given
      await TestApp.pumpPage(tester, presenter, () => page);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    initParams = EditWorkoutInitialParams(null);
    model = EditWorkoutPresentationModel(initParams);
    page = EditWorkoutPage(initialParams: initParams);
    presenter = EditWorkoutPresenter(model, Mocks.appNavigator, Mocks.saveWorkoutUseCase);
  });
}
