import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_rest.g.dart';

@JsonSerializable()
class FirestoreRest {
  final int start;
  final int end;
  final String type;

  FirestoreRest({
    @required this.start,
    @required this.end,
    @required this.type,
  });

  factory FirestoreRest.fromJson(Map<String, dynamic> json) => _$FirestoreRestFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreRestToJson(this);

  factory FirestoreRest.fromRest(Rest rest) {
    if (rest == null) {
      return null;
    }
    final prop = rest.map(
      timeDuration: (rest) => rest.timeDuration,
      heartRate: (rest) => rest.heartRate,
    );
    return FirestoreRest(
      start: prop.start,
      end: prop.end,
      type: rest.type.stringVal,
    );
  }

  Rest toDomain() {
    final type = RestType.values.firstWhere((element) => element.stringVal == this.type);
    switch (type) {
      case RestType.timeDuration:
        return Rest.timeDuration(timeDuration: MeasurableProperty.timeDuration(start: start, end: end) as MeasurablePropertyTimeDuration);
      case RestType.heartRate:
        return Rest.heartRate(heartRate: MeasurableProperty.heartRate(start: start, end: end) as MeasurablePropertyHeartRate);
    }
    throw StateError("Cannot parse $type into Rest");
  }
}
