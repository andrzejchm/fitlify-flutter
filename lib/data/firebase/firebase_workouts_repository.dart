import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/data/firebase/firestore_paths.dart';
import 'package:fitlify_flutter/data/firebase/model/firestore_workout.dart';
import 'package:fitlify_flutter/domain/entities/paginated_list.dart';
import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/domain/failures/save_workout_failure.dart';
import 'package:fitlify_flutter/domain/repositories/workouts_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

@Injectable(as: WorkoutsRepository)
class FirebaseWorkoutsRepository implements WorkoutsRepository {
  static const DEFAULT_PAGE_SIZE = 20;
  final FirebaseFirestore firestore;

  FirebaseWorkoutsRepository(this.firestore);

  @override
  Future<Either<SaveWorkoutFailure, Workout>> saveWorkout(String userId, Workout workout) async {
    assert(userId != null && userId.isNotEmpty, "userId cannot be empty");

    final data = FirestoreWorkout.fromWorkout(workout).toJson();
    var id = workout.id;
    if (workout.id == null || workout.id.isEmpty) {
      final docRef = await firestore.collection(workoutsCol(userId)).add(data);
      id = docRef.id;
    } else {
      await firestore.doc(workoutDoc(userId, id)).set(data, SetOptions(merge: true));
    }
    final updatedWorkout = FirestoreWorkout.fromJson((await firestore.doc(workoutDoc(userId, id)).get()).data());

    return right(updatedWorkout.toDomain(id));
  }

  @override
  Future<Either<SaveWorkoutFailure, PaginatedList<Workout>>> getWorkouts(String userId, Pagination page) async {
    assert(userId != null && userId.isNotEmpty, "userId cannot be empty");
    try {
      final result = await firestore
          .collection(workoutsCol(userId)) //
          .orderBy("createdAt")
          .startAfter([page?.next])
          .limit(DEFAULT_PAGE_SIZE)
          .get();

      final workouts = result.docs.map((e) => FirestoreWorkout.fromJson(e.data()).toDomain(e.id));
      final pagination = workouts.length < DEFAULT_PAGE_SIZE ? null : Pagination(result.docs.last.data()["created_at"]);

      return right(PaginatedList(pagination, workouts.toImmutableList()));
    } catch (e, stack) {
      return left(SaveWorkoutFailure.unknown(e, stack));
    }
  }
}
