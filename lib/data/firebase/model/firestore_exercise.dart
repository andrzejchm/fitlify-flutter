import 'package:fitlify_flutter/data/firebase/model/firestore_measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:uuid/uuid.dart';

import 'firestore_rest.dart';

part 'firestore_exercise.g.dart';

@JsonSerializable()
class FirestoreExercise {
  final String id;
  final String name;
  final String notes;
  final List<FirestoreMeasurableProperty> properties;
  final String type;
  final FirestoreRest rest;

  const FirestoreExercise({
    @required this.id,
    @required this.name,
    @required this.notes,
    @required this.properties,
    @required this.type,
    @required this.rest,
  });

  factory FirestoreExercise.fromExercise(Exercise exercise) {
    if (exercise == null) {
      return null;
    }
    return FirestoreExercise(
      id: exercise.id ?? Uuid().v4(),
      name: exercise.name,
      notes: exercise.notes,
      properties: exercise.properties.map((it) => FirestoreMeasurableProperty.fromProperty(it)).asList(),
      type: exercise.type.stringVal,
      rest: FirestoreRest.fromRest(exercise.rest),
    );
  }

  factory FirestoreExercise.fromJson(Map<String, dynamic> json) => _$FirestoreExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreExerciseToJson(this);

  Exercise toDomain() => Exercise(
        id: id,
        name: name ?? "",
        notes: notes ?? "",
        properties: properties?.map((it) => it.toDomain())?.toImmutableList() ?? const KtList.empty(),
        type: ExerciseType.values.firstWhere(
          (element) => element.stringVal == type,
          orElse: () => ExerciseType.exercise,
        ),
        rest: rest?.toDomain(),
      );
}
