import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/edit_measurable_property_page.dart';
import 'package:flutter_test/flutter_test.dart';

class EditPropertyPageObject {
  Finder get saveButton => find.descendant(
        of: find.byType(EditMeasurablePropertyPage),
        matching: find.byWidgetPredicate((widget) => widget is AccentButton && widget.text == S.current.saveAction),
        matchRoot: true,
      );
}
