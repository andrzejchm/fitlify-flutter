import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import 'firestore_section.dart';

part 'firestore_workout.g.dart';

@JsonSerializable()
class FirestoreWorkout {
  final String name;
  final String description;
  final List<FirestoreSection> sections;
  final dynamic createdAt;

  const FirestoreWorkout({
    @required this.name,
    @required this.description,
    @required this.sections,
    @required this.createdAt,
  });

  factory FirestoreWorkout.fromWorkout(Workout workout) {
    if (workout == null) {
      return null;
    }
    return FirestoreWorkout(
      name: workout.name,
      description: workout.description,
      sections: workout.sections.map((it) => FirestoreSection.fromSection(it)).asList(),
      createdAt: workout.createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(workout.createdAt),
    );
  }

  factory FirestoreWorkout.fromJson(Map<String, dynamic> json) => _$FirestoreWorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreWorkoutToJson(this);

  Workout toDomain(String workoutId) => Workout(
        createdAt: (createdAt as Timestamp).toDate(),
        id: workoutId,
        description: description ?? "",
        sections: sections.map((it) => it.toDomain()).toImmutableList(),
        name: name ?? "",
      );
}
