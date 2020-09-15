import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'save_workout_failure.freezed.dart';

@freezed
abstract class SaveWorkoutFailure with _$SaveWorkoutFailure {
  const factory SaveWorkoutFailure.notLoggedIn() = SaveWorkoutFailureNotLoggedIn;

  const factory SaveWorkoutFailure.unknown(dynamic error, StackTrace stackTrace) = SaveWorkoutFailureUnknown;
}
