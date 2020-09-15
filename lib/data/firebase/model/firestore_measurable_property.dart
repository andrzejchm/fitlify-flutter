import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'firestore_rest.dart';

part 'firestore_measurable_property.g.dart';

@JsonSerializable()
class FirestoreMeasurableProperty {
  final int start;
  final int end;
  final bool isRange;
  final String type;
  final FirestoreRest rest;

  const FirestoreMeasurableProperty({
    @required this.start,
    @required this.end,
    @required this.isRange,
    @required this.type,
    @required this.rest,
  });

  factory FirestoreMeasurableProperty.fromProperty(MeasurableProperty property) {
    if (property == null) {
      return null;
    }
    return FirestoreMeasurableProperty(
        start: property.start,
        end: property.end,
        isRange: property.isRange,
        type: _type(property),
        rest: FirestoreRest.fromRest(property.rest));
  }

  static String _type(MeasurableProperty property) {
    return property.map(
      weight: (_) => "weight",
      timeDuration: (_) => "timeDuration",
      distance: (_) => "distance",
      sets: (_) => "sets",
      repetitions: (_) => "repetitions",
      heartRate: (_) => "heartRate",
    );
  }

  factory FirestoreMeasurableProperty.fromJson(Map<String, dynamic> json) => _$FirestoreMeasurablePropertyFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreMeasurablePropertyToJson(this);

  MeasurableProperty toDomain() {
    final typeEnum = MeasurablePropertyType.values.firstWhere((element) => element.stringVal == type);
    switch (typeEnum) {
      case MeasurablePropertyType.sets:
        return MeasurableProperty.sets(start: start, end: end, isRange: isRange, restBetweenSets: rest?.toDomain());
      case MeasurablePropertyType.repetitions:
        return MeasurableProperty.repetitions(start: start, end: end, isRange: isRange);
      case MeasurablePropertyType.weight:
        return MeasurableProperty.weight(start: start, end: end, isRange: isRange);
      case MeasurablePropertyType.timeDuration:
        return MeasurableProperty.timeDuration(start: start, end: end, isRange: isRange);
      case MeasurablePropertyType.distance:
        return MeasurableProperty.distance(start: start, end: end, isRange: isRange);
      case MeasurablePropertyType.heartRate:
        return MeasurableProperty.heartRate(start: start, end: end, isRange: isRange);
    }
    throw StateError("Cannot parse $type to MeasurableProperty");
  }
}
