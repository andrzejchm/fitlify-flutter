import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/pages/edit_rest/edit_rest_page.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_doubles/mocks.dart';
import 'page_objects/edit_rest_page_object.dart';
import 'utils/test_app.dart';

void main() {
  EditRestInitialParams initialParams;
  EditRestPresentationModel model;
  EditRestPresenter presenter;
  EditRestPage page;

  EditRestPageObject pageObject;

  void _initMvp({Rest rest}) {
    initialParams = rest == null ? const EditRestInitialParams.newRest() : EditRestInitialParams.editRest(rest: rest);
    model = EditRestPresentationModel(initialParams);
    presenter = EditRestPresenter(model, Mocks.appNavigator);
    page = EditRestPage(initialParams: initialParams);
    pageObject = EditRestPageObject();
  }

  group("EditRestPage", () {
    testWidgets("Indefinitely checkbox is checked when editing indefinite duration rest", (tester) async {
      _initMvp(rest: Rest.indefiniteTimeDuration);
      await TestApp.pumpPage(tester, presenter, () => page);
      expect(pageObject.indefiniteCheckbox(checked: true), findsOneWidget);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
