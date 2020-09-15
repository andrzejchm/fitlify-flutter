import 'package:flutter/material.dart';

class FitlifyRangeSlider extends StatelessWidget {
  final RangeLabels labels;
  final ValueChanged<RangeValues> onChanged;
  final RangeValues values;
  final double min;
  final double max;

  const FitlifyRangeSlider({
    Key key,
    @required this.labels,
    @required this.onChanged,
    @required this.values,
    @required this.min,
    @required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: colorScheme.primary,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.2),
        showValueIndicator: ShowValueIndicator.always,
        rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
      ),
      child: RangeSlider(
        values: values,
        min: min,
        max: max,
        labels: labels,
        onChanged: onChanged,
      ),
    );
  }
}
