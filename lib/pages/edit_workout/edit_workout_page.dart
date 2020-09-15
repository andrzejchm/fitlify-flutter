import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/core/utils/mobx_aware_text_controller.dart';
import 'package:fitlify_flutter/core/widgets/add_button.dart';
import 'package:fitlify_flutter/core/widgets/app_bar_progress_button.dart';
import 'package:fitlify_flutter/core/widgets/editable_action_buttons.dart';
import 'package:fitlify_flutter/core/widgets/caption_text.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_text_field.dart';
import 'package:fitlify_flutter/core/widgets/title_with_tooltip.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/edit_section_row.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_workout/edit_workout_presenter.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class EditWorkoutPage extends StatefulWidget with AutoRouteWrapper {
  final EditWorkoutInitialParams initialParams;

  const EditWorkoutPage({Key key, this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditWorkoutPresenter>(
        create: (_) => getIt(param1: EditWorkoutPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> with TickerProviderStateMixin {
  EditWorkoutPresenter get presenter => Provider.of(context, listen: false);

  EditWorkoutViewModel get model => presenter.viewModel;

  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  final List<ReactionDisposer> _disposeReactions = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    nameTextController = MobxAwareTextController(listenTo: () => model.name);
    descriptionTextController = MobxAwareTextController(listenTo: () => model.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: FitlifyAppBar(
        title: widget.initialParams.workout == null ? S.of(context).createWorkoutTitle : S.of(context).editWorkoutTitle,
        actions: [
          Observer(
            builder: (context) => AppBarProgressButton(
              progress: model.workoutSaveProgress,
              text: S.of(context).saveAction,
              onClicked: () => presenter.onViewInteraction(const Interaction.saveClicked()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Observer(
            builder: (context) => ReorderableColumn(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  header: _header(context),
                  onReorder: (oldIndex, newIndex) => presenter.onViewInteraction(Interaction.sectionReordered(oldIndex, newIndex)),
                  footer: _footer(),
                  children: _sections(),
                )),
      ),
      bottomNavigationBar: editControls(),
    );
  }

  List<Widget> _sections() => model.sectionsCount > 0
      ? List.generate(
          model.sectionsCount,
          (index) => ReorderableWidget(
                reorderable: model.editSectionsMode,
                key: ValueKey("$index ${model.editSectionsMode}"),
                child: Observer(
                    builder: (context) => EditSectionRow(
                          section: model.sections[index],
                          onSelected: (_) => presenter.onViewInteraction(Interaction.onSectionSelectClicked(index)),
                          onExpanded: (_) => presenter.onViewInteraction(Interaction.onSectionExpandClicked(index)),
                          editMode: model.editSectionsMode,
                          onClicked: model.editSectionsMode ? null : () => presenter.onViewInteraction(Interaction.sectionClicked(index)),
                          vsync: this,
                        )),
              ))
      : [ReorderableWidget(key: UniqueKey(), reorderable: false, child: CaptionText.emptyMessage(S.of(context).noSectionsEditMessage))];

  Column _header(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 20),
        Material(
          borderRadius: AppTheme.borderRadiusM,
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.only(),
            child: Column(
              children: [
                FitlifyTextField(
                  controller: nameTextController,
                  color: colorScheme.surface,
                  hint: S.of(context).workoutNameLabel,
                  onChanged: (text) => presenter.onViewInteraction(Interaction.nameChanged(text)),
                ),
                const Divider(
                  height: 1,
                ),
                FitlifyTextField(
                  controller: descriptionTextController,
                  color: colorScheme.surface,
                  hint: S.of(context).workoutDescriptionLabel,
                  onChanged: (text) => presenter.onViewInteraction(Interaction.descriptionChanged(text)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  TitleWithTooltip(
                    title: S.of(context).sectionsTitle,
                    tooltip: "TODO",
                  ), //TODO
                  Observer(
                      builder: (context) => IconButton(
                          icon: Icon(
                            model.allSectionsExpanded ? Icons.unfold_less : Icons.unfold_more,
                            size: 20,
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () => presenter.onViewInteraction(const Interaction.expandAllClicked())))
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () => presenter.onViewInteraction(const Interaction.editSectionsClicked()),
                child: Observer(builder: (context) => Text(model.editSectionsMode ? S.of(context).doneAction : S.of(context).editAction)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _footer() {
    return Observer(
      builder: (context) => AnimatedOpacity(
        opacity: model.editSectionsMode ? 0.0 : 1.0,
        duration: const ShortDuration(),
        child: Offstage(
          offstage: model.editSectionsMode,
          child: Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: MediaQuery.of(this.context).padding.bottom),
            child: _addButton(index: model.sections.length),
          ),
        ),
      ),
    );
  }

  Widget _addButton({@required int index}) {
    return AddButton(
      onClicked: () => presenter.onViewInteraction(Interaction.addSectionClicked(index)),
    );
  }

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }

  Widget editControls() {
    return Observer(
      builder: (context) => EditableActionButtons(
        visible: model.editSectionsMode,
        selectedCount: model.selectedSectionsCount,
        deleteClicked: () => presenter.onViewInteraction(const Interaction.deleteSelectedSectionsClicked()),
        vsync: this,
      ),
    );
  }
}
