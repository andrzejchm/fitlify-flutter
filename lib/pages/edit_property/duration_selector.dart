import 'package:fitlify_flutter/core/widgets/fitlify_carousel_picker.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/time_duration.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/range_checkbox_row.dart';
import 'package:flutter/material.dart';

class DurationSelector extends StatefulWidget {
  final MeasurablePropertyTimeDuration durationProp;
  final void Function(MeasurableProperty) onChanged;
  final bool showRange;
  final bool showSeconds;
  final bool enabled;

  const DurationSelector({
    Key key,
    @required this.durationProp,
    this.showRange = true,
    this.showSeconds = true,
    @required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  TimeDuration _start;
  TimeDuration _end;
  bool _isRange;

  FixedExtentScrollController _startMinScrollController;
  FixedExtentScrollController _startSecScrollController;
  FixedExtentScrollController _endMinScrollController;
  FixedExtentScrollController _endSecScrollController;

  static const PICKER_WIDTH = 60.0;
  static const SEC_ITEM_COUNT = 12;
  static const MIN_ITEM_COUNT = 200;

  @override
  void initState() {
    _start = TimeDuration(widget.durationProp.start);
    _end = TimeDuration(widget.durationProp.end);
    if (!widget.showSeconds) {
      _start.updateSeconds(0);
      _end.updateSeconds(0);
    }
    _isRange = widget.durationProp.isRange;
    _startMinScrollController = FixedExtentScrollController(initialItem: _start.minutes);
    _startSecScrollController = FixedExtentScrollController(initialItem: _start.seconds ~/ 5);
    _endMinScrollController = FixedExtentScrollController(initialItem: _end.minutes);
    _endSecScrollController = FixedExtentScrollController(initialItem: _end.seconds ~/ 5);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final minutesUnitText = Text(widget.showSeconds ? "m" : 'min', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    const secondsUnitText = Text("s", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.3,
        child: Column(
          children: [
            if (widget.showRange) _rangeCheckbox(context),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox.shrink()),
                _startMinPicker(),
                minutesUnitText,
                if (widget.showSeconds) ...[_startSecPicker(), secondsUnitText],
                if (_isRange) ...[
                  const Expanded(child: SizedBox.shrink()),
                  const Text("―", style: TextStyle(fontWeight: FontWeight.w600)),
                  const Expanded(child: SizedBox.shrink()),
                  _endMinPicker(),
                  minutesUnitText,
                  if (widget.showSeconds) ...[_endSecPicker(), secondsUnitText],
                ],
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _startMinPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        key: const ValueKey("StartMinPicker"),
        scrollController: _startMinScrollController,
        onSelectedItemChanged: (value) => _updateValue(startMin: value),
        textBuilder: (index) => "$index",
        childCount: MIN_ITEM_COUNT,
      ),
    );
  }

  SizedBox _startSecPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        key: const ValueKey("StartSecPicker"),
        scrollController: _startSecScrollController,
        onSelectedItemChanged: (value) => _updateValue(startSec: value),
        textBuilder: (index) => "${index * 5}",
        childCount: SEC_ITEM_COUNT,
      ),
    );
  }

  SizedBox _endMinPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        key: const ValueKey("EndMinPicker"),
        onSelectedItemChanged: (value) => _updateValue(endMin: value),
        scrollController: _endMinScrollController,
        childCount: MIN_ITEM_COUNT,
        textBuilder: (int index) => "$index",
      ),
    );
  }

  SizedBox _endSecPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        key: const ValueKey("EndSecPicker"),
        scrollController: _endSecScrollController,
        onSelectedItemChanged: (value) => _updateValue(endSec: value),
        textBuilder: (index) => "${index * 5}",
        childCount: SEC_ITEM_COUNT,
      ),
    );
  }

  Widget _rangeCheckbox(BuildContext context) {
    return CheckboxRow(
      text: S.of(context).specifyRangeCheckbox,
      checked: _isRange,
      onChanged: (value) {
        setState(() {
          _isRange = value;
          if (_isRange) {
            _syncEndPicker();
          }
        });
        _notifyChanged();
      },
    );
  }

  void _updateValue({int startMin, int startSec, int endMin, int endSec}) {
    setState(() {
      _start.updateMinutes(startMin);
      _start.updateSeconds(startSec != null ? startSec * 5 : null);

      if (_isRange) {
        _end.updateMinutes(endMin);
        _end.updateSeconds(endSec != null ? endSec * 5 : null);
      } else {
        _end.updateMinutes(_start.minutes);
        _end.updateSeconds(_start.seconds);
      }
      _notifyChanged();
    });
  }

  void _notifyChanged() {
    final startSecs = _start.totalSeconds;
    final endSecs = _end.totalSeconds;
    final inverse = startSecs > endSecs;
    final start = inverse ? endSecs : startSecs;
    final end = inverse ? startSecs : endSecs;
    widget.onChanged(MeasurableProperty.timeDuration(start: start, end: end, isRange: _isRange));
  }

  void _syncEndPicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _endMinScrollController.jumpToItem(_end.minutes);
      _endSecScrollController.jumpToItem(_end.seconds ~/ 5);
    });
  }
}
