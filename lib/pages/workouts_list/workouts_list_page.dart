import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/core/widgets/caption_text.dart';
import 'package:fitlify_flutter/core/widgets/loading_state_switcher.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workouts_list/workout_list_item.dart';
import 'package:fitlify_flutter/presentation/workouts_list/workouts_list_initial_params.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/workouts_list/workouts_list_presenter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class WorkoutsListPage extends StatefulWidget with AutoRouteWrapper {
  final WorkoutsListInitialParams initialParams;

  const WorkoutsListPage({Key key, this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<WorkoutsListPresenter>(
        create: (_) => getIt(param1: WorkoutsListPresentationModel(initialParams, getIt())),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _WorkoutsListPageState createState() => _WorkoutsListPageState();
}

class _WorkoutsListPageState extends State<WorkoutsListPage> {
  WorkoutsListPresenter get presenter => Provider.of(context, listen: false);

  WorkoutsListViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Observer(
          builder: (context) => LoadingStateSwitcher(
              isEmpty: model.isWorkoutsListEmpty,
              isLoading: model.isLoading,
              emptyBuilder: (context) => const Center(child: CaptionText.emptyMessage("No workouts yet")),
              loadingBuilder: (context) => const Center(child: CircularProgressIndicator()) /* TODO */,
              childBuilder: (context) => _workoutsList()),
        ),
        _createWorkoutButton(context),
      ],
    );
  }

  Align _createWorkoutButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: AccentButton(
            text: S.of(context).createWorkoutAction,
            onClicked: () => presenter.onViewInteraction(const Interaction.createWorkoutClicked()),
          ),
        ),
      ),
    );
  }

  CustomScrollView _workoutsList() {
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: AppTheme.spacingS)),
        Observer(
            builder: (context) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Observer(builder: (context) {
                        final workout = model.workouts[index];
                        return WorkoutListItem(
                          workout: workout,
                          onClicked: () => presenter.onViewInteraction(Interaction.onWorkoutClicked(workout)),
                        );
                      });
                    },
                    childCount: model.workoutsCount,
                  ),
                )),
        const SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight)),
      ],
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
