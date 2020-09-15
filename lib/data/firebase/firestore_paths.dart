String workoutsCol(String userId) => "users/$userId/workouts";

String workoutDoc(String userId, String workoutId) => "${workoutsCol(userId)}/$workoutId";
