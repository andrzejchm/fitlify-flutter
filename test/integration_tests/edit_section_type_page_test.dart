import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/pages/edit_section_type/edit_section_type_page.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_doubles/mocks.dart';
import 'page_objects/edit_section_type_page_object.dart';
import 'utils/test_app.dart';

void main() {
  EditSectionTypeInitialParams initParams;
  EditSectionTypePresentationModel model;
  EditSectionTypePresenter presenter;
  EditSectionTypePage page;
  EditSectionTypePageObject pageObject;

  void _initMvp({SectionType type}) {
    initParams = EditSectionTypeInitialParams(type);
    model = EditSectionTypePresentationModel(initParams);
    presenter = EditSectionTypePresenter(model, Mocks.appNavigator);
    page = EditSectionTypePage(initialParams: initParams);

    pageObject = EditSectionTypePageObject();
  }

  group("EditSectionTypePage", () {
    testWidgets("selecting different types in dropdown", (tester) async {
      _initMvp();
      await TestApp.pumpPage(tester, presenter, () => page);
      expect(pageObject.selectedMenuItem(SectionTypeEnum.normal), findsOneWidget);
      await tester.pumpAndSettle();
      expect(pageObject.typesDropdownButton, findsOneWidget);
      await tester.tap(pageObject.typesDropdownButton);
      await tester.pump();
      await tester.tap(pageObject.typeMenuItem(SectionTypeEnum.circuit));
      await tester.pump();
      expect(pageObject.selectedMenuItem(SectionTypeEnum.circuit), findsOneWidget);
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
