import 'package:fitlify_flutter/domain/entities/distance.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/domain/entities/time_duration.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurable_property.freezed.dart';

enum MeasurablePropertyType {
  sets,
  repetitions,
  weight,
  timeDuration,
  distance,
  heartRate,
}

extension MeasurablePropertyTypeExerciseValues on MeasurablePropertyType {
  static List<MeasurablePropertyType> exerciseValues = [...MeasurablePropertyType.values]..remove(MeasurablePropertyType.heartRate);
}

@freezed
abstract class MeasurableProperty implements _$MeasurableProperty {
  const MeasurableProperty._();

  const factory MeasurableProperty.weight({
    @Default(MeasurablePropertyType.weight) MeasurablePropertyType type,
    @Default(10) int start,
    @Default(12) int end,
    @Default(false) bool isRange,
  }) = MeasurablePropertyWeight;

  const factory MeasurableProperty.timeDuration({
    @Default(MeasurablePropertyType.timeDuration) MeasurablePropertyType type,
    @Default(0) int start,
    @Default(60) int end,
    @Default(false) bool isRange,
  }) = MeasurablePropertyTimeDuration;

  const factory MeasurableProperty.distance({
    @Default(MeasurablePropertyType.distance) MeasurablePropertyType type,
    @Default(1000) int start,
    @Default(1200) int end,
    @Default(false) bool isRange,
  }) = MeasurablePropertyDistance;

  const factory MeasurableProperty.sets({
    @Default(MeasurablePropertyType.sets) MeasurablePropertyType type,
    @Default(4) int start,
    @Default(5) int end,
    @Default(false) bool isRange,
    Rest restBetweenSets,
  }) = MeasurablePropertySets;

  const factory MeasurableProperty.repetitions({
    @Default(MeasurablePropertyType.repetitions) MeasurablePropertyType type,
    @Default(10) int start,
    @Default(12) int end,
    @Default(false) bool isRange,
  }) = MeasurablePropertyRepetitions;

  const factory MeasurableProperty.heartRate({
    @Default(MeasurablePropertyType.heartRate) MeasurablePropertyType type,
    @Default(100) int start,
    @Default(100) int end,
    @Default(false) bool isRange,
  }) = MeasurablePropertyHeartRate;

  bool get isIndefinite => maybeMap(timeDuration: (prop) => prop.start == -1, orElse: () => false);

  static MeasurablePropertyTimeDuration get indefiniteTimeDuration {
    return const MeasurableProperty.timeDuration(start: -1, end: -1, isRange: false) as MeasurablePropertyTimeDuration;
  }

  Rest get rest => maybeMap(sets: (prop) => prop.restBetweenSets, orElse: () => null);

  // ignore: prefer_constructors_over_static_methods
  static MeasurableProperty ofType(MeasurablePropertyType type, {MeasurableProperty previous}) {
    switch (type) {
      case MeasurablePropertyType.weight:
        return previous == null
            ? const MeasurableProperty.weight()
            : MeasurableProperty.weight(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
      case MeasurablePropertyType.timeDuration:
        return previous == null
            ? const MeasurableProperty.timeDuration()
            : MeasurableProperty.timeDuration(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
      case MeasurablePropertyType.distance:
        return previous == null
            ? const MeasurableProperty.distance()
            : MeasurableProperty.distance(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
      case MeasurablePropertyType.sets:
        return previous == null
            ? const MeasurableProperty.sets()
            : MeasurableProperty.sets(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
      case MeasurablePropertyType.repetitions:
        return previous == null
            ? const MeasurableProperty.repetitions()
            : MeasurableProperty.repetitions(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
      case MeasurablePropertyType.heartRate:
        return previous == null
            ? const MeasurableProperty.heartRate()
            : MeasurableProperty.heartRate(start: previous?.start, end: previous?.end, isRange: previous?.isRange);
        break;
    }
    throw StateError("Can't convert $type to MeasurableProperty");
  }
}

extension MeasurablePropertyResources on MeasurableProperty {
  String formatValue() => map(
        weight: (prop) => prop.isRange ? "${prop.start} kg - ${prop.end} kg" : "${prop.start} kg",
        timeDuration: (prop) => prop.isRange
            ? "${TimeDuration(prop.start).formatShort()} - ${TimeDuration(prop.end).formatShort()}"
            : TimeDuration(prop.start).formatShort(),
        distance: (prop) => prop.isRange
            ? "${Distance(prop.start).formatShort()} - ${Distance(prop.end).formatShort()}"
            : Distance(prop.start).formatShort(),
        sets: (prop) => prop.isRange ? "${prop.start} - ${prop.end}x" : "${prop.start}x",
        repetitions: (prop) => prop.isRange ? "${prop.start} - ${prop.end}" : "${prop.start}",
        heartRate: (prop) => prop.isRange ? S.current.formatHeartRateRange(prop.start, prop.end) : S.current.formatHeartRate(prop.start),
      );
}

extension MeasurablePropertyTypeResources on MeasurablePropertyType {
  IconData get icon {
    switch (this) {
      case MeasurablePropertyType.weight:
        return Icons.fitness_center;
      case MeasurablePropertyType.timeDuration:
        return Icons.timelapse;
      case MeasurablePropertyType.distance:
        return Icons.add_road;
      case MeasurablePropertyType.sets:
        return Icons.format_list_numbered;
      case MeasurablePropertyType.repetitions:
        return Icons.autorenew;
      case MeasurablePropertyType.heartRate:
        return Icons.favorite;
        break;
    }
    throw StateError("Cannot convert $this to icon");
  }

  String get name {
    switch (this) {
      case MeasurablePropertyType.weight:
        return S.current.propertyNameWeight;
      case MeasurablePropertyType.timeDuration:
        return S.current.propertyNameTimeDuration;
      case MeasurablePropertyType.distance:
        return S.current.propertyNameDistance;
      case MeasurablePropertyType.sets:
        return S.current.propertyNameSets;
      case MeasurablePropertyType.repetitions:
        return S.current.propertyNameRepetitions;
      case MeasurablePropertyType.heartRate:
        return S.current.propertyTypeHeartRate;
    }
    throw StateError("Cannot convert $this to string");
  }

  String get stringVal {
    switch (this) {
      case MeasurablePropertyType.weight:
        return "weight";
      case MeasurablePropertyType.timeDuration:
        return "timeDuration";
      case MeasurablePropertyType.distance:
        return "distance";
      case MeasurablePropertyType.sets:
        return "sets";
      case MeasurablePropertyType.repetitions:
        return "repetitions";
      case MeasurablePropertyType.heartRate:
        return "heartRate";
    }
    throw StateError("Cannot convert $this to string");
  }
}
