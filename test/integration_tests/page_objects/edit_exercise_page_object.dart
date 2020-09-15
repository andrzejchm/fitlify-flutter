import 'package:fitlify_flutter/core/widgets/gray_button.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_classes_with_only_static_members
class EditExercisePageObject {
  Finder get addPropertyButton => find.byWidgetPredicate((widget) => widget is GrayButton && widget.text == S.current.addPropertyAction);

  Finder pageTitle(String text) =>
      find.byWidgetPredicate((widget) => widget is Text && widget.data == text && widget.key == const ValueKey("pageTitle"));

  Finder measurablePropertyTile({MeasurablePropertyType type, String text}) =>
      find.ancestor(of: find.text(text), matching: find.byKey(ValueKey(type)));
}
