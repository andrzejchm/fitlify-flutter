import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:fitlify_flutter/pages/edit_exercise/edit_exercise_page.dart';
import 'package:fitlify_flutter/pages/edit_rest/edit_rest_page.dart';
import 'package:fitlify_flutter/pages/edit_section/edit_section_page.dart';
import 'package:fitlify_flutter/pages/edit_workout/edit_workout_page.dart';
import 'package:fitlify_flutter/pages/history/history_page.dart';
import 'package:fitlify_flutter/pages/login/login_page.dart';
import 'package:fitlify_flutter/pages/main/main_page.dart';
import 'package:fitlify_flutter/pages/profile/profile_page.dart';
import 'package:fitlify_flutter/pages/workout_details/workout_details_page.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/workout_pdf_preview_page.dart';
import 'package:fitlify_flutter/routing/routing_page.dart';

@MaterialAutoRouter(routes: [
  CustomRoute(page: RoutingPage, initial: true, transitionsBuilder: TransitionsBuilders.fadeIn),
  CustomRoute(page: MainPage, transitionsBuilder: TransitionsBuilders.fadeIn),
  MaterialRoute(page: HistoryPage),
  MaterialRoute(page: LoginPage),
  CustomRoute(page: LoginPage, name: "logInPageFadeIn", path: "login-page-fade-in", transitionsBuilder: TransitionsBuilders.fadeIn),
  MaterialRoute(page: WorkoutDetailsPage),
  MaterialRoute(page: WorkoutPdfPreviewPage),
  MaterialRoute(page: ProfilePage),
  CustomRoute(page: EditWorkoutPage, transitionsBuilder: TransitionsBuilders.slideBottom, fullscreenDialog: true),
  CustomRoute(page: EditSectionPage, transitionsBuilder: TransitionsBuilders.fadeIn, fullscreenDialog: true),
  CustomRoute(page: EditExercisePage, transitionsBuilder: TransitionsBuilders.fadeIn, fullscreenDialog: true),
  CustomRoute(page: EditRestPage, transitionsBuilder: TransitionsBuilders.slideBottom, fullscreenDialog: true),
])
class $Router {}
