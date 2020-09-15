import 'package:fitlify_flutter/domain/repositories/workouts_repository.dart';
import 'package:fitlify_flutter/domain/services/app_restarter.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:fitlify_flutter/domain/stores/workouts_store.dart';
import 'package:fitlify_flutter/domain/use_cases/get_workouts_list_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/initialize_app_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/is_logged_in_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_anonymously_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/log_in_with_apple_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/log_out_use_case.dart';
import 'package:fitlify_flutter/domain/use_cases/save_workout_use_case.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:mockito/mockito.dart';

class MockAppNavigator extends Mock implements AppNavigator {}

class MockAuthService extends Mock implements AuthService {}

class MockLogInAnonymouslyUseCase extends Mock implements LogInAnonymouslyUseCase {}

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

class MockSaveWorkoutUseCase extends Mock implements SaveWorkoutUseCase {}

class MockInitializeAppUseCase extends Mock implements InitializeAppUseCase {}

class MockWorkoutsRepository extends Mock implements WorkoutsRepository {}

class MockWorkoutsStore extends Mock implements WorkoutsStore {}

class MockCurrentUserStore extends Mock implements CurrentUserStore {}

class MockLogInWithAppleUseCase extends Mock implements LogInWithAppleUseCase {}

class MockGetWorkoutsListUseCase extends Mock implements GetWorkoutsListUseCase {}

class MockLogOutUseCase extends Mock implements LogOutUseCase {}

class MockAppRestarter extends Mock implements AppRestarter {}
