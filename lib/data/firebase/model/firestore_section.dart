import 'package:fitlify_flutter/data/firebase/model/firestore_section_type.dart';
import 'package:fitlify_flutter/data/firebase/model/firestore_exercise.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:uuid/uuid.dart';

part 'firestore_section.g.dart';

@JsonSerializable()
class FirestoreSection {
  final String id;
  final String name;
  final String description;
  final FirestoreSectionType type;
  final List<FirestoreExercise> exercises;

  FirestoreSection({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.type,
    @required this.exercises,
  });

  factory FirestoreSection.fromSection(Section section) {
    if (section == null) {
      return null;
    }
    return FirestoreSection(
      id: section.id ?? Uuid().v4(),
      name: section.name,
      description: section.description,
      type: FirestoreSectionType.fromType(section.type),
      exercises: section.exercises.map((it) => FirestoreExercise.fromExercise(it)).asList(),
    );
  }

  factory FirestoreSection.fromJson(Map<String, dynamic> json) => _$FirestoreSectionFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreSectionToJson(this);

  Section toDomain() => Section(
        id: id,
        name: name ?? "",
        description: description ?? "",
        type: type.toDomain(),
        exercises: exercises.map((it) => it.toDomain()).toImmutableList(),
      );
}
