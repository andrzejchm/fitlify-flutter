import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart' hide nullable;
import 'package:uuid/uuid.dart';

part 'section.freezed.dart';

@freezed
abstract class Section implements _$Section {
  const factory Section({
    @required @nullable String id,
    @required String name,
    @required String description,
    @required SectionType type,
    @required KtList<Exercise> exercises,
  }) = _Section;

  const Section._();

  factory Section.newSection() => Section(
        id: Uuid().v4(),
        name: "",
        description: "",
        type: const SectionType.normal(),
        exercises: const KtList.empty(),
      );
}
