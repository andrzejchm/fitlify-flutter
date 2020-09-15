import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/duration_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/heart_rate_selector.dart';
import 'package:flutter/material.dart';

class RestParamsSelector extends StatefulWidget {
  final Rest rest;
  final void Function(Rest rest) onChanged;

  const RestParamsSelector({
    Key key,
    @required this.rest,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _RestParamsSelectorState createState() => _RestParamsSelectorState();
}

class _RestParamsSelectorState extends State<RestParamsSelector> {
  bool _indefiniteDuration = false;

  Rest _rest;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rest ??= widget.rest;
    _indefiniteDuration = _rest.isIndefinite;
  }

  @override
  Widget build(BuildContext context) {
    return widget.rest.map(
      timeDuration: (rest) => Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _indefiniteDuration,
                onChanged: (checked) => _indefinitelyChanged(checked),
              ),
              Text(S.of(context).indefinitelyCheckbox),
            ],
          ),
          DurationSelector(
            enabled: !_indefiniteDuration,
            durationProp: rest.timeDuration,
            showRange: false,
            onChanged: (prop) => _valueChanged(rest.copyWith(timeDuration: prop as MeasurablePropertyTimeDuration)),
          ),
        ],
      ),
      heartRate: (rest) => HeartRateSelector(
        heartRateProp: rest.heartRate,
        showRange: false,
        onChanged: (prop) => _valueChanged(rest.copyWith(heartRate: prop as MeasurablePropertyHeartRate)),
      ),
    );
  }

  void _indefinitelyChanged(bool checked) {
    setState(() {
      _indefiniteDuration = checked;
      if (_indefiniteDuration) {
        widget.onChanged(Rest.indefiniteTimeDuration);
      } else {
        widget.onChanged(_rest);
      }
    });
  }

  void _valueChanged(Rest rest) {
    _rest = rest;
    widget.onChanged(rest);
  }
}
