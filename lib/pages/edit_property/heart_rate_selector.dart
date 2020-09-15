import 'package:fitlify_flutter/core/widgets/fitlify_carousel_picker.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/range_checkbox_row.dart';
import 'package:flutter/material.dart';

class HeartRateSelector extends StatefulWidget {
  final MeasurablePropertyHeartRate heartRateProp;
  final void Function(MeasurableProperty) onChanged;
  final bool showRange;

  const HeartRateSelector({
    Key key,
    @required this.heartRateProp,
    this.showRange = true,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _HeartRateSelectorState createState() => _HeartRateSelectorState();
}

class _HeartRateSelectorState extends State<HeartRateSelector> {
  int _start;
  int _end;
  bool _isRange;

  FixedExtentScrollController _startScrollController;
  FixedExtentScrollController _endScrollController;

  static const PICKER_WIDTH = 60.0;
  static const ITEM_COUNT = 21;
  static const MIN_VALUE = 40;

  @override
  void initState() {
    _start = widget.heartRateProp.start;
    _end = widget.heartRateProp.end;
    _isRange = widget.heartRateProp.isRange;
    _startScrollController = FixedExtentScrollController(initialItem: (_start - 40) ~/ 10);
    _endScrollController = FixedExtentScrollController(initialItem: (_end - 40) ~/ 10);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const unitText = Text("bpm", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    return Column(
      children: [
        if (widget.showRange) _rangeCheckbox(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox.shrink()),
            _startPicker(),
            unitText,
            if (_isRange) ...[
              const Expanded(child: SizedBox.shrink()),
              const Text("―", style: TextStyle(fontWeight: FontWeight.w600)),
              const Expanded(child: SizedBox.shrink()),
              _endPicker(),
              unitText,
            ],
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  SizedBox _startPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        scrollController: _startScrollController,
        onSelectedItemChanged: (value) => _updateValue(newStart: value),
        textBuilder: (index) => "${index * 10 + MIN_VALUE}",
        childCount: ITEM_COUNT,
      ),
    );
  }

  SizedBox _endPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        scrollController: _endScrollController,
        onSelectedItemChanged: (value) => _updateValue(newEnd: value),
        textBuilder: (index) => "${index * 10 + MIN_VALUE}",
        childCount: ITEM_COUNT,
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

  void _updateValue({int newStart, int newEnd}) {
    setState(() {
      _start = newStart != null ? newStart * 10 + MIN_VALUE : _start;

      if (_isRange) {
        _end = newEnd != null ? newEnd * 10 + MIN_VALUE : _end;
      } else {
        _end = _start;
      }
      _notifyChanged();
    });
  }

  void _notifyChanged() {
    widget.onChanged(MeasurableProperty.heartRate(start: _start, end: _end, isRange: _isRange));
  }

  void _syncEndPicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _endScrollController.jumpToItem((_end - MIN_VALUE) ~/ 10);
    });
  }
}
