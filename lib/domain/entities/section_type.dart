import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:kt_dart/kt.dart' hide nullable;

part 'section_type.freezed.dart';

enum SectionTypeEnum { circuit, emom, amrap, normal }

@freezed
abstract class SectionType implements _$SectionType {
  const SectionType._();

  const factory SectionType.circuit({
    @Default(MeasurableProperty.sets(start: 4, end: 4, isRange: false)) MeasurablePropertySets sets,
  }) = SectionTypeCircuit;

  const factory SectionType.emom({
    @Default(MeasurableProperty.timeDuration(start: 600, end: 600, isRange: false)) MeasurablePropertyTimeDuration duration,
  }) = SectionTypeEmom;

  const factory SectionType.amrap({
    @Default(MeasurableProperty.timeDuration(start: 600, end: 600, isRange: false)) MeasurablePropertyTimeDuration duration,
  }) = SectionTypeAmrap;

  const factory SectionType.normal() = SectionTypeNormal;
}

extension SectionTypes on SectionType {
  static KtList<SectionType> get availableTypes => SectionTypeEnum.values.map((e) {
        switch (e) {
          case SectionTypeEnum.circuit:
            return const SectionType.circuit();
          case SectionTypeEnum.emom:
            return const SectionType.emom();
          case SectionTypeEnum.amrap:
            return const SectionType.amrap();
          case SectionTypeEnum.normal:
            return const SectionType.normal();
        }
      }).toImmutableList();

  SectionTypeEnum get type => map(
        circuit: (_) => SectionTypeEnum.circuit,
        emom: (_) => SectionTypeEnum.emom,
        amrap: (_) => SectionTypeEnum.amrap,
        normal: (_) => SectionTypeEnum.normal,
      );

  String get title => type.title;

  String get subtitle => map(
        circuit: (prop) => prop.sets.formatValue(),
        emom: (prop) => prop.duration.formatValue(),
        amrap: (prop) => prop.duration.formatValue(),
        normal: (prop) => "",
      );
}

extension SectionTypeEnumResources on SectionTypeEnum {
  String get title {
    switch (this) {
      case SectionTypeEnum.circuit:
        return S.current.circuitTitle;
      case SectionTypeEnum.emom:
        return S.current.emomTitle;
      case SectionTypeEnum.amrap:
        return S.current.amrapTitle;
      case SectionTypeEnum.normal:
        return S.current.normalTitle;
    }
    throw StateError("Cannot map $this to title string");
  }

  String get stringVal {
    switch (this) {
      case SectionTypeEnum.circuit:
        return "circuit";
      case SectionTypeEnum.emom:
        return "emom";
      case SectionTypeEnum.amrap:
        return "amrap";
      case SectionTypeEnum.normal:
        return "normal";
    }
    throw StateError("Cannot map $this to stringVal");
  }
}
