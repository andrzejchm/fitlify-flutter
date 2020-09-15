import 'package:fitlify_flutter/core/widgets/fitlify_dropdown_button.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/pages/edit_section_type/section_type_menu_item.dart';
import 'package:flutter_test/src/finders.dart';

import '../utils/widget_test_utils.dart';

class EditSectionTypePageObject {
  Finder get typesDropdownButton => find.byType(typeOf<FitlifyDropdownButton<SectionTypeEnum>>());

  Finder typeMenuItem(SectionTypeEnum type) => find
      .byWidgetPredicate(
        (widget) => widget is SectionTypeMenuItem && widget.value == type,
        description: "'${type.title}' Dropdown Menu Item",
      )
      .last;

  Finder selectedMenuItem(SectionTypeEnum type) => find.byWidgetPredicate(
        (widget) => widget is FitlifyDropdownButton<SectionTypeEnum> && widget.value == type,
        description: "Dropdown button with '${type.title}' selected",
      );
}
