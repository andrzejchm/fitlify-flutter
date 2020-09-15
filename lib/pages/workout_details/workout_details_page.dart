import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/core/widgets/app_ar_accent_action.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/workout_details/workout_details_presenter.dart';
import 'package:fitlify_flutter/presentation/workout_details/workout_details_initial_params.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class WorkoutDetailsPage extends StatefulWidget with AutoRouteWrapper {
  final WorkoutDetailsInitialParams initialParams;

  WorkoutDetailsPage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<WorkoutDetailsPresenter>(
        create: (_) => getIt(param1: WorkoutDetailsPresentationModel(initialParams, getIt())),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _WorkoutDetailsPageState createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  WorkoutDetailsPresenter get presenter => Provider.of(context, listen: false);

  WorkoutDetailsViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitlifyAppBar(
        title: S.of(context).workoutDetailsTitle,
        actions: [
          AppBarAccentAction(
            text: S.of(context).editAction,
            onClicked: () => presenter.onViewInteraction(const Interaction.editClicked()),
          )
        ],
      ),
      body: Center(
        child: Observer(
          builder: (context) => Text(model.workout.name),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AccentButton(
        text: S.of(context).exportAction,
        onClicked: () => presenter.onViewInteraction(const Interaction.exportToPdfClicked()),
      ),
    );
  }

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }
}
