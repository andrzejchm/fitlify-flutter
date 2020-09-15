import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_presenter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../test_doubles/mocks.dart';

void main() {
  EditSectionTypeInitialParams initParams;
  EditSectionTypePresentationModel presentationModel;
  EditSectionTypePresenter presenter;

  void _createPresenter({@required SectionType type}) {
    initParams = EditSectionTypeInitialParams(type);
    presentationModel = EditSectionTypePresentationModel(initParams);
    presenter = EditSectionTypePresenter(presentationModel, Mocks.appNavigator);
  }

  group("EditSectionTypePresenter", () {
    test("should populate initial params correctly", () async {
      //given
      _createPresenter(type: const SectionType.emom());
      //when
      //then
      expect(presentationModel.type.type, equals(SectionTypeEnum.emom));
      expect(presentationModel.availableTypes, equals(SectionTypeEnum.values));
    });

    test("should change type when selected", () async {
      //given
      _createPresenter(type: const SectionType.emom());
      //when
      presenter.onViewInteraction(const Interaction.onTypeSelected(SectionTypeEnum.normal));
      //then
      expect(presentationModel.type.type, equals(SectionTypeEnum.normal));
    });

    test("should remember selected values for given type", () async {
      //given
      const emomDuration = MeasurablePropertyTimeDuration(start: 720, end: 720, isRange: false);
      const amrapDuration = MeasurablePropertyTimeDuration(start: 700, end: 700, isRange: false);
      _createPresenter(type: const SectionType.emom(duration: emomDuration));
      //when
      presenter.onViewInteraction(
        const Interaction.onTypeSelected(SectionTypeEnum.amrap),
      );
      presenter.onViewInteraction(
        const Interaction.onTypeChanged(
          SectionType.amrap(duration: amrapDuration),
        ),
      );
      presenter.onViewInteraction(
        const Interaction.onTypeSelected(SectionTypeEnum.emom),
      );
      //then
      expect(presentationModel.type, isA<SectionTypeEmom>());
      expect(
        (presentationModel.type as SectionTypeEmom).duration,
        equals(emomDuration),
      );

      //when
      presenter.onViewInteraction(const Interaction.onTypeSelected(SectionTypeEnum.amrap));
      //then
      expect(presentationModel.type, isA<SectionTypeAmrap>());
      expect(
        (presentationModel.type as SectionTypeAmrap).duration,
        equals(amrapDuration),
      );
    });

    test("clicking 'save' pops screen with SectionType", () async {
      //given
      _createPresenter(type: const SectionType.emom());
      //when
      presenter.onViewInteraction(
        const Interaction.saveClicked(),
      );
      //then
      verify(
        Mocks.appNavigator.closeWithResult(
          argThat(equals(const SectionType.emom())),
        ),
      );
    });

    test("all types are non null", () async {
      //given
      _createPresenter(type: null);
      //when

      //then
      expect(presentationModel.types.values, everyElement(isNotNull));
    });

    test("default type is 'normal'", () async {
      //given
      _createPresenter(type: null);
      //when
      //then
      expect(presentationModel.typeEnum, equals(SectionTypeEnum.normal));
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
    _createPresenter(type: null);
  });
}
