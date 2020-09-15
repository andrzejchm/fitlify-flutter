import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/time_duration.dart';
import 'package:fitlify_flutter/pages/edit_property/duration_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../integration_tests/utils/test_app.dart';

void main() {
  final startMinutesPicker = find.byKey(const ValueKey("StartMinPicker"));
  final startSecondsPicker = find.byKey(const ValueKey("StartSecPicker"));
  final endMinutesPicker = find.byKey(const ValueKey("EndMinPicker"));
  final endSecondsPicker = find.byKey(const ValueKey("EndSecPicker"));

  var value = const MeasurableProperty.timeDuration(start: 0, end: 0);

  Future<void> _pumpWidget(WidgetTester tester, {bool showRange = false}) async {
    final widget = TestWidgetFrame(
      embedInScaffold: true,
      child: DurationSelector(
        durationProp: value as MeasurablePropertyTimeDuration,
        onChanged: (prop) => value = prop,
        showRange: showRange,
      ),
    );

    await tester.pumpWidget(widget);
  }

  group("DurationSelectorTestPage", () {
    //
    testWidgets("set minutes and seconds", (tester) async {
      //
      await _pumpWidget(tester);
      await tester.pump(const Duration(milliseconds: 200));

      await _dragUpBy(tester, startMinutesPicker, steps: 1);
      await _dragUpBy(tester, startSecondsPicker, steps: 1);
      expect(TimeDuration(value.start).minutes, 1);
      expect(TimeDuration(value.start).seconds, 5);
    });

    testWidgets("set minutes and seconds in range", (tester) async {
      //
      value = const MeasurableProperty.timeDuration(start: 0, end: 0, isRange: true);
      await _pumpWidget(tester, showRange: true);
      await tester.pump(const Duration(milliseconds: 200));

      await _dragUpBy(tester, startMinutesPicker, steps: 1);
      await _dragUpBy(tester, startSecondsPicker, steps: 1);
      await _dragUpBy(tester, endMinutesPicker, steps: 2);
      await _dragUpBy(tester, endSecondsPicker, steps: 2);
      expect(TimeDuration(value.start).minutes, 1);
      expect(TimeDuration(value.start).seconds, 5);
      expect(TimeDuration(value.end).minutes, 2);
      expect(TimeDuration(value.end).seconds, 10);
    });
  });
  //
}

Future<void> _dragUpBy(WidgetTester tester, Finder finder, {@required int steps}) async {
  final rect = _getWidgetRect(tester, finder);
  await tester.dragFrom(rect.center, Offset(0, steps * -rect.height / 4));
}

Rect _getWidgetRect(WidgetTester tester, Finder finder) => tester.getRect(finder);
