import 'package:fitlify_flutter/core/widgets/fitlify_carousel_picker.dart';
import 'package:fitlify_flutter/domain/entities/distance.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/range_checkbox_row.dart';
import 'package:flutter/material.dart';

class DistanceSelector extends StatefulWidget {
  final MeasurablePropertyDistance distanceProp;
  final void Function(MeasurableProperty) onChanged;

  const DistanceSelector({
    Key key,
    @required this.distanceProp,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _DistanceSelectorState createState() => _DistanceSelectorState();
}

class _DistanceSelectorState extends State<DistanceSelector> {
  Distance _start;
  Distance _end;
  bool _isRange;

  FixedExtentScrollController _startKmScrollController;
  FixedExtentScrollController _startMeterScrollController;
  FixedExtentScrollController _endKmScrollController;
  FixedExtentScrollController _endMeterScrollController;

  static const METER_PICKER_WIDTH = 65.0;
  static const KILOMETER_PICKER_WIDTH = 50.0;
  static const SEC_ITEM_COUNT = 100;
  static const MIN_ITEM_COUNT = 200;

  @override
  void initState() {
    _start = Distance(widget.distanceProp.start);
    _end = Distance(widget.distanceProp.end);
    _isRange = widget.distanceProp.isRange;
    _startKmScrollController = FixedExtentScrollController(initialItem: _start.kilometers);
    _startMeterScrollController = FixedExtentScrollController(initialItem: _start.meters ~/ 10);
    _endKmScrollController = FixedExtentScrollController(initialItem: _end.kilometers);
    _endMeterScrollController = FixedExtentScrollController(initialItem: _end.meters ~/ 10);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const kilometersUnitText = Text("km", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    const metersUnitText = Text("m", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22));
    return Column(
      children: [
        _rangeCheckbox(context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox.shrink()),
            _startKmPicker(),
            kilometersUnitText,
            _startMeterPicker(),
            metersUnitText,
            if (_isRange) ...[
              const Expanded(child: SizedBox.shrink()),
              const Text("―", style: TextStyle(fontWeight: FontWeight.w600)),
              const Expanded(child: SizedBox.shrink()),
              _endKmPicker(),
              kilometersUnitText,
              _endSecPicker(),
              metersUnitText,
            ],
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  SizedBox _startKmPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: KILOMETER_PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        scrollController: _startKmScrollController,
        onSelectedItemChanged: (value) => _updateValue(startKm: value),
        textBuilder: (index) => "$index",
        childCount: MIN_ITEM_COUNT,
      ),
    );
  }

  SizedBox _startMeterPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: METER_PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        scrollController: _startMeterScrollController,
        onSelectedItemChanged: (value) => _updateValue(startMeter: value),
        textBuilder: (index) => "${index * 10}",
        childCount: SEC_ITEM_COUNT,
      ),
    );
  }

  SizedBox _endKmPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: KILOMETER_PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        onSelectedItemChanged: (value) => _updateValue(endKm: value),
        scrollController: _endKmScrollController,
        childCount: MIN_ITEM_COUNT,
        textBuilder: (int index) => "$index",
      ),
    );
  }

  SizedBox _endSecPicker() {
    return SizedBox(
      height: MeasurablePropertyParamsSelector.PICKER_HEIGHT,
      width: METER_PICKER_WIDTH,
      child: FitlifyCarouselPicker(
        scrollController: _endMeterScrollController,
        onSelectedItemChanged: (value) => _updateValue(endMeter: value),
        textBuilder: (index) => "${index * 10}",
        childCount: SEC_ITEM_COUNT,
      ),
    );
  }

  Widget _rangeCheckbox(BuildContext context) {
    return CheckboxRow(
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
      text: S.of(context).specifyRangeCheckbox,
    );
  }

  void _updateValue({int startKm, int startMeter, int endKm, int endMeter}) {
    setState(() {
      _start.updateKilometers(startKm);
      _start.updateMeters(startMeter != null ? startMeter * 10 : null);

      if (_isRange) {
        _end.updateKilometers(endKm);
        _end.updateMeters(endMeter != null ? endMeter * 10 : null);
      } else {
        _end.updateKilometers(_start.kilometers);
        _end.updateMeters(_end.meters);
      }
      _notifyChanged();
    });
  }

  void _notifyChanged() {
    final startSecs = _start.totalMeters;
    final endSecs = _end.totalMeters;
    final inverse = startSecs > endSecs;
    final start = inverse ? endSecs : startSecs;
    final end = inverse ? startSecs : endSecs;
    widget.onChanged(MeasurableProperty.distance(start: start, end: end, isRange: _isRange));
  }

  void _syncEndPicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _endKmScrollController.jumpToItem(_end.kilometers);
      _endMeterScrollController.jumpToItem(_end.meters ~/ 10);
    });
  }
}
