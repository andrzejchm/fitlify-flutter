import 'package:fitlify_flutter/core/widgets/fitlify_dropdown_button.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_menu_item.dart';
import 'package:fitlify_flutter/pages/edit_property/rest_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/src/finders.dart';
import 'package:flutter_test/src/widget_tester.dart';

import '../utils/widget_test_utils.dart';
import 'page_robot.dart';
import 'widget_robot.dart';

class EditMeasurablePropertyRobot extends PageRobot {
  EditMeasurablePropertyRobot(WidgetTester tester) : super(tester);

  WidgetRobot get typesDropdownButton => find.byType(typeOf<FitlifyDropdownButton<MeasurablePropertyType>>()).robot(tester);

  WidgetRobot typeMenuItem(MeasurablePropertyType type) => find
      .byWidgetPredicate(
        (widget) => widget is MeasurablePropertyMenuItem && widget.value == type,
        description: "'${type.name}' Dropdown menu item",
      )
      .last
      .robot(tester);

  WidgetRobot get addRestButton => find
      .byWidgetPredicate(
        (widget) => widget is Text && widget.data == S.current.restBetweenSetsAction,
        description: "Add rest button",
      )
      .robot(tester);

  WidgetRobot get restBadge => find.byWidgetPredicate((widget) => widget is RestListItem).robot(tester);

  WidgetRobot selectedMenuItem(MeasurablePropertyType type) => find
      .byWidgetPredicate(
        (widget) => widget is FitlifyDropdownButton<MeasurablePropertyType> && widget.value == type,
        description: "Dropdown button with '${type.name}' selected",
      )
      .robot(tester);
}
