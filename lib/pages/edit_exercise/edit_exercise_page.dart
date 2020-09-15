import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/utils/keyboard_utils.dart';
import 'package:fitlify_flutter/core/utils/mobx_aware_text_controller.dart';
import 'package:fitlify_flutter/core/widgets/app_ar_accent_action.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_text_field.dart';
import 'package:fitlify_flutter/core/widgets/gray_button.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/edit_measurable_property_row.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/edit_exercise_row.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/edit_exercise/edit_exercise_presenter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class EditExercisePage extends StatefulWidget with AutoRouteWrapper {
  final EditExerciseInitialParams initialParams;

  EditExercisePage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditExercisePresenter>(
        create: (_) => getIt(param1: EditExercisePresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditExercisePageState createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  EditExercisePresenter get presenter => Provider.of(context, listen: false);

  EditExerciseViewModel get model => presenter.viewModel;

  MobxAwareTextController _nameController;
  MobxAwareTextController _notesController;
  final List<ReactionDisposer> _disposeReactions = [];

  @override
  void initState() {
    super.initState();
    _nameController = MobxAwareTextController(listenTo: () => model.name);
    _notesController = MobxAwareTextController(listenTo: () => model.notes);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: FitlifyAppBar(
        title: widget.initialParams.exercise == null ? S.of(context).addExerciseTitle : S.of(context).editExerciseTitle,
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
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: EditExerciseRow.heroTag(model.id),
                  child: Stack(
                    children: [
                      Material(
                        color: colorScheme.surface,
                        borderRadius: AppTheme.borderRadiusM,
                        elevation: AppTheme.elevationM,
                        child: EditExerciseForm(
                          nameController: _nameController,
                          notesController: _notesController,
                          nameChanged: (text) => presenter.onViewInteraction(Interaction.nameChanged(text)),
                          model: model,
                          addPropertyClicked: () => presenter.onViewInteraction(const Interaction.addPropertyClicked()),
                          deletePropertyClicked: (prop) => () => presenter.onViewInteraction(Interaction.deletePropertyClicked(prop)),
                          propertyClicked: (prop) => presenter.onViewInteraction(Interaction.onPropertyClicked(prop)),
                          notesChanged: (notes) => presenter.onViewInteraction(Interaction.notesChanged(notes)),
                          addNotesClicked: () => presenter.onViewInteraction(const Interaction.addNotesClicked()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

class EditExerciseForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController notesController;
  final ValueChanged<String> nameChanged;
  final ValueChanged<String> notesChanged;
  final EditExerciseViewModel model;
  final VoidCallback addPropertyClicked;
  final ValueChanged<MeasurableProperty> deletePropertyClicked;
  final ValueChanged<MeasurableProperty> propertyClicked;
  final VoidCallback addNotesClicked;

  const EditExerciseForm({
    Key key,
    @required this.nameController,
    @required this.notesController,
    @required this.nameChanged,
    @required this.notesChanged,
    @required this.model,
    @required this.addPropertyClicked,
    @required this.deletePropertyClicked,
    @required this.propertyClicked,
    @required this.addNotesClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Observer(
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppTheme.spacingM),
                    FitlifyTextField(
                      controller: nameController,
                      label: S.of(context).exerciseNameLabel,
                      color: colorScheme.surface,
                      onChanged: nameChanged,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    if (model.showNotesTextField)
                      FitlifyTextField(
                        controller: notesController,
                        label: S.of(context).exerciseNotesLabel,
                        color: colorScheme.surface,
                        onChanged: notesChanged,
                      )
                    else
                      FlatButton(onPressed: addNotesClicked, child: Text(S.of(context).addNotesAction)),
                    const SizedBox(height: AppTheme.spacingL),
                    ..._properties(context),
                    const SizedBox(height: 10),
                    if (model.canAddMoreProperties)
                      GrayButton(
                        text: S.of(context).addPropertyAction,
                        onClicked: () => hideKeyboard(context, addPropertyClicked),
                      ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
                )),
      ),
    );
  }

  List<Widget> _properties(BuildContext context) {
    return model.sortedProperties
        .map((element) => EditMeasurablePropertyRow(
              key: ValueKey(element.type),
              property: element,
              onDeleteClicked: () => hideKeyboard(context, () => deletePropertyClicked(element)),
              onClicked: () => hideKeyboard(context, () => propertyClicked(element)),
            ))
        .toList();
  }
}
