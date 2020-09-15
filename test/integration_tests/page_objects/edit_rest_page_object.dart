import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EditRestPageObject {
  Finder indefiniteCheckbox({bool checked}) => find.byWidgetPredicate((widget) => widget is Checkbox && widget.value == checked);
}
