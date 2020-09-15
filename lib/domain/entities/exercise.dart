import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:kt_dart/collection.dart' hide nullable;

part 'exercise.freezed.dart';

enum ExerciseType { rest, exercise }

@freezed
abstract class Exercise implements _$Exercise {
  const factory Exercise({
    @required ExerciseType type,
    @required @nullable String id,
    @required String name,
    @required String notes,
    @required KtList<MeasurableProperty> properties,
    //used if type is ExerciseType.rest
    @required @nullable Rest rest,
  }) = _Exercise;

  const Exercise._();

  factory Exercise.newExercise() => const Exercise(
        id: null,
        name: "",
        notes: "",
        properties: KtList.empty(),
        type: ExerciseType.exercise,
        rest: null,
      );

  factory Exercise.rest(Rest rest) => Exercise(
        type: ExerciseType.rest,
        id: null,
        name: "",
        properties: const KtList.empty(),
        rest: rest,
        notes: "",
      );

  bool get isRest => type == ExerciseType.rest;
}

extension ExerciseTypeValues on ExerciseType {
  String get stringVal {
    switch (this) {
      case ExerciseType.rest:
        return "rest";
      case ExerciseType.exercise:
        return "exercise";
    }
    throw StateError("Cannot encode $this into stringVal");
  }
}
