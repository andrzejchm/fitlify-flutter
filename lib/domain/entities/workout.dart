import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:kt_dart/collection.dart' hide nullable;

part 'workout.freezed.dart';

@freezed
abstract class Workout implements _$Workout {
  const factory Workout({
    @required @nullable String id,
    @required String name,
    @required String description,
    @required KtList<Section> sections,
    @required @nullable DateTime createdAt,
  }) = _Workout;

  const Workout._();
}
