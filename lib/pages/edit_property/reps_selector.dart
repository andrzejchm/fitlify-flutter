import 'package:fitlify_flutter/core/widgets/fitlify_carousel_picker.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/range_checkbox_row.dart';
import 'package:flutter/material.dart';

class RepsSelector extends StatefulWidget {
  final MeasurablePropertyRepetitions repsProp;
  final MeasurablePropertySets setsProp;
  final void Function(MeasurableProperty) onChanged;
  final bool showRange;

  const RepsSelector({
    Key key,
    this.repsProp,
    this.setsProp,
    this.showRange = true,
    @required this.onChanged,
  })  : assert((repsProp != null) != (setsProp != null), 'you  can specify either setsProp or repsProp, not both'),
        super(key: key);

  @override
  _RepsSelectorState createState() => _RepsSelectorState();
}

class _RepsSelectorState extends State<RepsSelector> {
  int _start;
  int _end;
  bool _isRange;

  FixedExtentScrollController _startScrollController;
  FixedExtentScrollController _endScrollController;

  static const PICKER_WIDTH = 60.0;
  static const ITEMS_COUNT = 200;

  @override
  void initState() {
    _start = (widget.repsProp ?? widget.setsProp).start;
    _end = (widget.repsProp ?? widget.setsProp).end;
    _isRange = (widget.repsProp ?? widget.setsProp).isRange;
    _startScrollController = FixedExtentScrollController(initialItem: _start - 1);
    _endScrollController = FixedExtentScrollController(initialItem: _end - 1);

    super.initState();
    debugPrint("new values: $_start - $_end");
  }

  @override
  Widget build(BuildContext context) {
    const unitText = Text("x", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    return Column(
      children: [
        if (widget.showRange) _rangeCheckbox(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox.shrink()),
            _startPicker(),
            const SizedBox(width: 10),
            if (widget.setsProp != null) unitText,
            if (_isRange) ...[
              const Expanded(child: SizedBox.shrink()),
              const Text("―", style: TextStyle(fontWeight: FontWeight.w600)),
              const Expanded(child: SizedBox.shrink()),
              _endPicker(),
              if (widget.setsProp != null) unitText,
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
        onSelectedItemChanged: (value) => _updateRangeValue(startIndex: value),
        textBuilder: (index) => "${index + 1}",
        childCount: ITEMS_COUNT,
      ),
    );
  }

  SizedBox _endPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        onSelectedItemChanged: (value) => _updateRangeValue(endIndex: value),
        scrollController: _endScrollController,
        childCount: ITEMS_COUNT,
        textBuilder: (int index) => "${index + 1}",
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

  void _updateRangeValue({int startIndex, int endIndex}) {
    setState(() {
      _start = startIndex != null ? startIndex + 1 : _start;
      _end = _isRange ? (endIndex != null ? endIndex + 1 : _end) : _start;
    });
    _notifyChanged();
  }

  void _notifyChanged() {
    final inverse = _start > _end;
    final start = inverse ? _end : _start;
    final end = inverse ? _start : _end;
    if (widget.setsProp != null) {
      widget.onChanged(MeasurableProperty.sets(
        start: start,
        end: end,
        isRange: _isRange,
        restBetweenSets: widget.setsProp.restBetweenSets,
      ));
    } else {
      widget.onChanged(MeasurableProperty.repetitions(
        start: start,
        end: end,
        isRange: _isRange,
      ));
    }
  }

  void _syncEndPicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _endScrollController.jumpToItem(_end - 1);
    });
  }
}
