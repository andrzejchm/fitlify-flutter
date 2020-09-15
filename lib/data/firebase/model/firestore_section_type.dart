import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'firestore_measurable_property.dart';

part 'firestore_section_type.g.dart';

@JsonSerializable()
class FirestoreSectionType {
  final String type;
  final FirestoreMeasurableProperty property;

  FirestoreSectionType({
    @required this.type,
    @required this.property,
  });

  factory FirestoreSectionType.fromType(SectionType sectionType) {
    if (sectionType == null) {
      return null;
    }
    return FirestoreSectionType(
      type: sectionType.type.stringVal,
      property: FirestoreMeasurableProperty.fromProperty(sectionType.map(
        circuit: (prop) => prop.sets,
        emom: (prop) => prop.duration,
        amrap: (prop) => prop.duration,
        normal: (prop) => null,
      )),
    );
  }

  factory FirestoreSectionType.fromJson(Map<String, dynamic> json) => _$FirestoreSectionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreSectionTypeToJson(this);

  SectionType toDomain() {
    final typeEnum = SectionTypeEnum.values.firstWhere((element) => element.stringVal == type);
    switch (typeEnum) {
      case SectionTypeEnum.circuit:
        return SectionType.circuit(sets: property.toDomain() as MeasurablePropertySets);
      case SectionTypeEnum.emom:
        return SectionType.emom(duration: property.toDomain() as MeasurablePropertyTimeDuration);
      case SectionTypeEnum.amrap:
        return SectionType.amrap(duration: property.toDomain() as MeasurablePropertyTimeDuration);
      case SectionTypeEnum.normal:
        return const SectionType.normal();
    }
    throw StateError("Cannot parse $type to SectionType");
  }
}
