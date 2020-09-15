import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/error_dialog.dart';
import 'package:fitlify_flutter/domain/failures/displayable_error.dart';
import 'package:fitlify_flutter/pages/edit_property/edit_measurable_property_page.dart';
import 'package:fitlify_flutter/pages/edit_section/choose_exercise_type_dialog.dart';
import 'package:fitlify_flutter/pages/edit_section_type/edit_section_type_page.dart';
import 'package:fitlify_flutter/presentation/edit_exercise/edit_exercise_presenter.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_section/edit_section_presenter.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:fitlify_flutter/presentation/profile/profile_initial_params.dart';
import 'package:fitlify_flutter/presentation/workout_details/workout_details_initial_params.dart';
import 'package:fitlify_flutter/presentation/workout_pdf_preview/workout_pdf_preview_initial_params.dart';
import 'package:fitlify_flutter/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

part 'app_navigator.freezed.dart';

@singleton
class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  ExtendedNavigatorState get _navigator => ExtendedNavigator.root;

  Future<T> openPage<T>(AppPageRoute appPageRoute) async {
    return appPageRoute.map(
      routing: (_) => _openPage(appPageRoute),
      main: (_) => _openPage(appPageRoute),
      history: (_) => _openPage(appPageRoute),
      workoutDetails: (params) => _openPage(
        appPageRoute,
        arguments: WorkoutDetailsPageArguments(initialParams: params.initialParams),
      ),
      workoutPdfPreview: (params) => _openPage(
        appPageRoute,
        arguments: WorkoutPdfPreviewPageArguments(initialParams: params.initialParams),
      ),
      editWorkout: (params) => _openPage(
        appPageRoute,
        arguments: EditWorkoutPageArguments(initialParams: params.initialParams),
      ),
      editSection: (params) => _openPage(
        appPageRoute,
        arguments: EditSectionPageArguments(initialParams: params.initialParams),
      ),
      editExercise: (params) => _openPage(
        appPageRoute,
        arguments: EditExercisePageArguments(initialParams: params.initialParams),
      ),
      loginPage: (params) => _openPage(
        params.copyWith(route: params.fadeIn ? Routes.logInPageFadeIn : params.route),
        arguments: LoginPageArguments(initialParams: params.initialParams),
      ),
      editRest: (params) => _openPage(
        appPageRoute,
        arguments: EditRestPageArguments(initialParams: params.initialParams),
      ),
      profilePage: (params) => _openPage(
        appPageRoute,
        arguments: ProfilePageArguments(initialParams: params.initialParams),
      ),
      chooseExerciseTypeDialog: (params) => _openDialog((context) => ChooseExerciseTypeDialog(params.initialParams)),
      editMeasurableProperty: (params) => _openBottomSheet(
          (context) => EditMeasurablePropertyPage(initialParams: params.initialParams).wrappedRoute(context),
          enableDrag: false),
      editSectionType: (params) =>
          _openBottomSheet((context) => EditSectionTypePage(initialParams: params.initialParams).wrappedRoute(context), enableDrag: false),
      errorDialog: (params) => _openDialog((context) => ErrorDialog(error: params.error)),
    );
  }

  Future<T> _openDialog<T>(WidgetBuilder dialog) {
    return showDialog(context: navigatorKey.currentContext, builder: dialog);
  }

  Future<T> _openBottomSheet<T>(WidgetBuilder bottomSheet, {bool enableDrag, double closeProgressThreshold}) {
    return showMaterialModalBottomSheet(
      closeProgressThreshold: closeProgressThreshold,
      enableDrag: enableDrag,
      context: navigatorKey.currentContext,
      builder: (context, controller) => bottomSheet(context),
    );
  }

  Future<T> _openPage<T>(AppPageRoute appPageRoute, {Object arguments}) async {
    if (appPageRoute.settings?.popUntilRoot ?? false) {
      _navigator.popUntilRoot();
      return _navigator.popAndPush(appPageRoute.route, arguments: arguments);
    } else if (appPageRoute.settings?.popCurrent ?? false) {
      return _navigator.popAndPush(appPageRoute.route, arguments: arguments);
    } else {
      return _navigator.push(appPageRoute.route, arguments: arguments);
    }
  }

  void closeWithResult<T>(T result) => _navigator.pop(result);

  void close() => closeWithResult(null);
}

@freezed
abstract class AppPageRoute with _$AppPageRoute {
  const factory AppPageRoute.routing({
    @Default(Routes.routingPage) String route,
    @Default(AppPageRouteSettings(popUntilRoot: true)) AppPageRouteSettings settings,
  }) = AppPageRouteRouting;

  const factory AppPageRoute.main({
    @Default(Routes.mainPage) String route,
    AppPageRouteSettings settings,
  }) = AppPageRouteMain;

  const factory AppPageRoute.history({
    @Default(Routes.historyPage) String route,
    AppPageRouteSettings settings,
  }) = AppPageRouteHistory;

  const factory AppPageRoute.editWorkout({
    @Default(Routes.editWorkoutPage) String route,
    AppPageRouteSettings settings,
    @required EditWorkoutInitialParams initialParams,
  }) = AppPageRouteCreateWorkout;

  const factory AppPageRoute.editSection({
    @Default(Routes.editSectionPage) String route,
    AppPageRouteSettings settings,
    @required EditSectionInitialParams initialParams,
  }) = AppPageRouteEditSection;

  const factory AppPageRoute.editExercise({
    @Default(Routes.editExercisePage) String route,
    AppPageRouteSettings settings,
    @required EditExerciseInitialParams initialParams,
  }) = AppPageRouteEditExercise;

  const factory AppPageRoute.editRest({
    @Default(Routes.editRestPage) String route,
    AppPageRouteSettings settings,
    @required EditRestInitialParams initialParams,
  }) = AppPageRouteEditRest;

  const factory AppPageRoute.loginPage({
    @Default(Routes.loginPage) String route,
    @Default(false) bool fadeIn,
    AppPageRouteSettings settings,
    @required LoginInitialParams initialParams,
  }) = AppPageRouteLoginPage;

  const factory AppPageRoute.chooseExerciseTypeDialog({
    @Default("") String route,
    AppPageRouteSettings settings,
    @required ChooseExerciseTypeInitialParams initialParams,
  }) = AppPageRouteChooseExerciseTypeDialog;

  const factory AppPageRoute.editMeasurableProperty({
    @Default("") String route,
    AppPageRouteSettings settings,
    EditMeasurablePropertyInitialParams initialParams,
  }) = AppPageRouteEditMeasurableProperty;

  const factory AppPageRoute.editSectionType({
    @Default("") String route,
    AppPageRouteSettings settings,
    EditSectionTypeInitialParams initialParams,
  }) = AppPageRouteEditSectionType;

  const factory AppPageRoute.errorDialog({
    @Default("") String route,
    AppPageRouteSettings settings,
    DisplayableError error,
  }) = AppPageRouteErrorDialog;

  const factory AppPageRoute.workoutDetails({
    @Default(Routes.workoutDetailsPage) String route,
    AppPageRouteSettings settings,
    WorkoutDetailsInitialParams initialParams,
  }) = AppPageRouteWorkoutDetails;

  const factory AppPageRoute.workoutPdfPreview({
    @Default(Routes.workoutPdfPreviewPage) String route,
    AppPageRouteSettings settings,
    WorkoutPdfPreviewInitialParams initialParams,
  }) = AppPageRouteWorkoutPdfPreview;

  const factory AppPageRoute.profilePage({
    @Default(Routes.profilePage) String route,
    AppPageRouteSettings settings,
    ProfileInitialParams initialParams,
  }) = AppPageRouteProfilePage;
}

class AppPageRouteSettings {
  final bool popCurrent;
  final bool popUntilRoot;

  const AppPageRouteSettings({this.popCurrent = false, this.popUntilRoot = false})
      : assert(!popCurrent || !popUntilRoot, "you can specify popCurrent or popUntilRoot, not both");
}
