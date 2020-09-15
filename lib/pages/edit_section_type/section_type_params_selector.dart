import 'package:fitlify_flutter/core/widgets/caption_text.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/duration_selector.dart';
import 'package:fitlify_flutter/pages/edit_property/reps_selector.dart';
import 'package:flutter/material.dart';

class SectionTypeParamsSelector extends StatelessWidget {
  final SectionType type;
  final void Function(SectionType) onChanged;

  const SectionTypeParamsSelector({
    Key key,
    @required this.type,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...type.map(
            circuit: (type) => [
              CaptionText(S.of(context).circuitRationaleMessage),
              RepsSelector(
                setsProp: type.sets,
                showRange: false,
                onChanged: (prop) => onChanged(type.copyWith(sets: prop as MeasurablePropertySets)),
              )
            ],
            emom: (type) => [
              CaptionText(S.of(context).emomRationaleMessage),
              DurationSelector(
                key: const ValueKey("emomDurationSelector"),
                showSeconds: false,
                durationProp: type.duration,
                showRange: false,
                onChanged: (prop) => onChanged(type.copyWith(duration: prop as MeasurablePropertyTimeDuration)),
              )
            ],
            amrap: (type) => [
              CaptionText(S.of(context).amrapRationaleMessage),
              DurationSelector(
                key: const ValueKey("amrapDurationSelector"),
                showSeconds: false,
                durationProp: type.duration,
                showRange: false,
                onChanged: (prop) => onChanged(type.copyWith(duration: prop as MeasurablePropertyTimeDuration)),
              )
            ],
            normal: (type) => [],
          ),
        ],
      );
}
