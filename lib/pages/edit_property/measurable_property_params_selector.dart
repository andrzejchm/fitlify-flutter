import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/pages/edit_property/distance_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/duration_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/heart_rate_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/reps_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/weight_selector.dart';
import 'package:flutter/material.dart';

class MeasurablePropertyParamsSelector extends StatelessWidget {
  final MeasurableProperty property;
  final void Function(MeasurableProperty) onChanged;
  static const PICKER_HEIGHT = 160.0;

  const MeasurablePropertyParamsSelector({
    Key key,
    @required this.property,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return property.map(
      weight: (prop) => WeightSelector(weightProp: prop, onChanged: onChanged),
      timeDuration: (prop) => DurationSelector(durationProp: prop, onChanged: onChanged),
      distance: (prop) => DistanceSelector(distanceProp: prop, onChanged: onChanged),
      sets: (prop) => RepsSelector(setsProp: prop, onChanged: onChanged),
      repetitions: (prop) => RepsSelector(repsProp: prop, onChanged: onChanged),
      heartRate: (prop) => HeartRateSelector(heartRateProp: prop, onChanged: onChanged),
    );
  }
}
