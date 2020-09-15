import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'rest.freezed.dart';

enum RestType { timeDuration, heartRate }

@freezed
abstract class Rest implements _$Rest {
  const Rest._();

  @Assert("type == RestType.timeDuration")
  const factory Rest.timeDuration({
    @Default(MeasurableProperty.timeDuration()) MeasurablePropertyTimeDuration timeDuration,
    @Default(RestType.timeDuration) RestType type,
  }) = RestTimeDuration;

  @Assert("type == RestType.heartRate")
  const factory Rest.heartRate({
    @Default(MeasurableProperty.heartRate()) MeasurablePropertyHeartRate heartRate,
    @Default(RestType.heartRate) RestType type,
  }) = RestHeartRate;

  MeasurableProperty get property => map(
        timeDuration: (prop) => prop.timeDuration,
        heartRate: (prop) => prop.heartRate,
      );

  bool get isIndefinite => map(
        timeDuration: (prop) => prop.timeDuration.isIndefinite,
        heartRate: (prop) => false,
      );

  static RestTimeDuration get indefiniteTimeDuration =>
      Rest.timeDuration(timeDuration: MeasurableProperty.indefiniteTimeDuration) as RestTimeDuration;
}

extension RestTypeResources on RestType {
  String get stringVal {
    switch (this) {
      case RestType.timeDuration:
        return "duration";
      case RestType.heartRate:
        return "heartRate";
    }
    throw StateError("Cannot convert $this to stringVal");
  }

  String get title {
    switch (this) {
      case RestType.timeDuration:
        return S.current.propertyNameTimeDuration;
      case RestType.heartRate:
        return S.current.propertyTypeHeartRate;
    }
    throw StateError("Cannot convert $this to title");
  }
}

extension RestAvailableValues on Rest {
  static KtList<Rest> get list => RestType.values.map((e) {
        switch (e) {
          case RestType.timeDuration:
            return Rest.timeDuration();
          case RestType.heartRate:
            return Rest.heartRate();
        }
      }).toImmutableList();
}
