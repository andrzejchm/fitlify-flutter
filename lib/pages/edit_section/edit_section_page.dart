import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/utils/keyboard_utils.dart';
import 'package:fitlify_flutter/core/utils/mobx_aware_text_controller.dart';
import 'package:fitlify_flutter/core/widgets/add_button.dart';
import 'package:fitlify_flutter/core/widgets/app_ar_accent_action.dart';
import 'package:fitlify_flutter/core/widgets/editable_action_buttons.dart';
import 'package:fitlify_flutter/core/widgets/caption_text.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_text_field.dart';
import 'package:fitlify_flutter/core/widgets/title_with_tooltip.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_section/section_type_row.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/edit_exercise_row.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/edit_section_row.dart';
import 'package:fitlify_flutter/presentation/edit_section/edit_section_presenter.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

typedef SectionTypeEditorCallback = Future<SectionType> Function(SectionType);

class EditSectionPage extends StatefulWidget with AutoRouteWrapper {
  const EditSectionPage({Key key, @required this.initialParams}) : super(key: key);

  final EditSectionInitialParams initialParams;

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditSectionPresenter>(
        create: (_) => getIt(param1: EditSectionPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditSectionPageState createState() => _EditSectionPageState();
}

class _EditSectionPageState extends State<EditSectionPage> with TickerProviderStateMixin {
  EditSectionPresenter get presenter => Provider.of(context, listen: false);

  EditSectionViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  MobxAwareTextController _nameController;
  MobxAwareTextController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = MobxAwareTextController(listenTo: () => model.name);
    _descriptionController = MobxAwareTextController(listenTo: () => model.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitlifyAppBar(
        title: S.of(context).editSectionTitle,
        actions: [
          AppBarAccentAction(
            onClicked: () => presenter.onViewInteraction(const Interaction.saveClicked()),
            text: S.of(context).saveAction,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
          child: Observer(
              builder: (context) => Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: EditSectionRow.heroTag(model.sectionId),
                          child: Material(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: AppTheme.borderRadiusM,
                            child: Stack(
                              /// stack is needed so that Material does not expand
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReorderableColumn(
                                    header: _header(context),
                                    mainAxisSize: MainAxisSize.min,
                                    footer: Observer(
                                      builder: (context) => _addButton(index: model.exercises.length),
                                    ),
                                    onReorder: (prev, next) => presenter.onViewInteraction(Interaction.onExerciseReordered(prev, next)),
                                    children: _exercises(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
      bottomNavigationBar: Observer(
          builder: (context) => EditableActionButtons(
                visible: model.editExercisesMode,
                selectedCount: model.selectedExercisesCount,
                deleteClicked: () => presenter.onViewInteraction(const Interaction.deleteSelectedClicked()),
                vsync: this,
              )),
    );
  }

  Widget _textFieldsSection(BuildContext context) {
    return Column(
      children: [
        FitlifyTextField(
          controller: _nameController,
          color: Theme.of(context).colorScheme.surface,
          hint: S.of(context).sectionNameLabel,
          onChanged: (text) => presenter.onViewInteraction(Interaction.nameChanged(text)),
        ),
        const Divider(height: 1),
        FitlifyTextField(
          controller: _descriptionController,
          color: Theme.of(context).colorScheme.surface,
          hint: S.of(context).sectionDescriptionLabel,
          onChanged: (text) => presenter.onViewInteraction(Interaction.descriptionChanged(text)),
        ),
        const Divider(height: 1),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TitleWithTooltip(title: S.of(context).typeTitle, tooltip: S.of(context).sectionTypeTooltip),
            ),
            SectionTypeRow(
              sectionType: model.sectionType,
              onClicked: () => hideKeyboard(context, () => presenter.onViewInteraction(const Interaction.specifyTypeClicked())),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _exercises() => model.exercisesCount > 0
      ? List.generate(
          model.exercisesCount,
          (index) => ReorderableWidget(
                key: UniqueKey(),
                reorderable: model.editExercisesMode,
                child: EditExerciseRow(
                  onClicked: () => presenter.onViewInteraction(Interaction.exerciseClicked(index)),
                  exercise: model.exercises[index],
                  onSelected: (selected) => presenter.onViewInteraction(Interaction.onExerciseSelected(index, selected)),
                  editMode: model.editExercisesMode,
                ),
              ))
      : [
          ReorderableWidget(
            key: UniqueKey(),
            reorderable: false,
            child: CaptionText.emptyMessage(S.of(context).noExercisesEditMessage),
          )
        ];

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }

  Widget _addButton({@required int index}) {
    return ReorderableWidget(
      key: ValueKey(index),
      reorderable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddButton(
            onClicked: () => presenter.onViewInteraction(Interaction.addButtonClicked(index)),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        _textFieldsSection(context),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            TitleWithTooltip(
              title: S.of(context).exercisesTitle, tooltip: "TODO", //TODO
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () => presenter.onViewInteraction(const Interaction.editExercisesClicked()),
                child: Observer(builder: (context) => Text(model.editExercisesMode ? S.of(context).doneAction : S.of(context).editAction)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
