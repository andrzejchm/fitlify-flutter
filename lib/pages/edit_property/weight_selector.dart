import 'package:fitlify_flutter/core/widgets/fitlify_carousel_picker.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/range_checkbox_row.dart';
import 'package:flutter/material.dart';

class WeightSelector extends StatefulWidget {
  final MeasurablePropertyWeight weightProp;
  final void Function(MeasurableProperty) onChanged;

  const WeightSelector({
    Key key,
    @required this.weightProp,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _WeightSelectorState createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  int _start;
  int _end;
  bool _isRange;

  FixedExtentScrollController _startScrollController;
  FixedExtentScrollController _endScrollController;

  int get _endIndex => _end - _start;

  @override
  void initState() {
    _start = widget.weightProp.start;
    _end = widget.weightProp.end;
    _isRange = widget.weightProp.isRange;
    _startScrollController = FixedExtentScrollController(initialItem: _start);
    _endScrollController = FixedExtentScrollController(initialItem: _endIndex);

    super.initState();
    debugPrint("new values: $_start - $_end");
  }

  @override
  Widget build(BuildContext context) {
    const unitText = Text("kg", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    return Column(
      children: [
        _rangeCheckbox(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
              width: 120,
              child: FitlifyCarouselPicker(
                scrollController: _startScrollController,
                onSelectedItemChanged: (value) => _updateRangeValue(startIndex: value),
                textBuilder: (index) => "$index",
                childCount: 201,
              ),
            ),
            const SizedBox(width: 10),
            unitText,
            if (_isRange) ...[
              const Expanded(child: SizedBox.shrink()),
              const Text("―", style: TextStyle(fontWeight: FontWeight.w600)),
              const Expanded(child: SizedBox.shrink()),
              SizedBox(
                height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
                width: 120,
                child: FitlifyCarouselPicker(
                  onSelectedItemChanged: (value) => _updateRangeValue(endIndex: value),
                  scrollController: _endScrollController,
                  childCount: 101,
                  textBuilder: (int index) => _endText(index),
                ),
              ),
              unitText,
            ],
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  Widget _rangeCheckbox(BuildContext context) {
    return CheckboxRow(
      text: S.of(context).specifyRangeCheckbox,
      checked: _isRange,
      onChanged: (value) {
        setState(() => _isRange = value);
        _notifyChanged();
      },
    );
  }

  void _updateRangeValue({int startIndex, int endIndex}) {
    setState(() {
      _start = startIndex ?? _start;
      _end = endIndex == null ? _end : _endValue(endIndex);
      if (_end < _start) {
        if (startIndex != null) {
          _end = _start;
        } else if (endIndex != null) {
          _start = _end;
        }
      }
      if (!_isRange) {
        _end = _start;
      }
    });
    if (_isRange && _endScrollController.selectedItem != _endIndex) {
      _endScrollController.jumpToItem(_endIndex);
    }
    _notifyChanged();
  }

  void _notifyChanged() {
    widget.onChanged(MeasurableProperty.weight(start: _start, end: _end, isRange: _isRange));
  }

  String _endText(int index) {
    return _endValue(index).toString();
  }

  int _endValue(int endIndex) {
    return _start + endIndex;
  }
}
