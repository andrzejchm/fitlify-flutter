import 'package:fitlify_flutter/data/firebase/model/firestore_measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_doubles/mocks.dart';

void main() {
  final setsProp = MeasurableProperty.sets(
    start: 10,
    end: 20,
    isRange: false,
    restBetweenSets: Rest.timeDuration(
      timeDuration: const MeasurableProperty.timeDuration() as MeasurablePropertyTimeDuration,
    ),
  ) as MeasurablePropertySets;

  group("FirestoreMeasurableProperty", () {
    test("rest in sets is included in firestore object", () {
      //
      expect(
        FirestoreMeasurableProperty.fromProperty(setsProp).toDomain().rest,
        allOf(isNotNull, equals(setsProp.rest)),
      );
      expect(
        FirestoreMeasurableProperty.fromProperty(setsProp).toDomain(),
        setsProp,
      );
    });

    test("indefinite duration rest is parsed correctly", () {
      //
      final indefiniteRestProp = setsProp.copyWith(restBetweenSets: Rest.indefiniteTimeDuration);
      expect(
        FirestoreMeasurableProperty.fromProperty(indefiniteRestProp).toDomain().rest,
        allOf(isNotNull, equals(Rest.indefiniteTimeDuration)),
      );
      expect(
        FirestoreMeasurableProperty.fromProperty(indefiniteRestProp).toDomain(),
        indefiniteRestProp,
      );
    });
  });

  setUp(() {
    Mocks.setUpDefaultMocks();
  });
}
