import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_dropdown_button.dart';
import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_property/edit_rest_container.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_menu_item.dart';
import 'package:fitlify_flutter/pages/edit_property/measurable_property_params_selector.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_initial_params.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_presenter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class EditMeasurablePropertyPage extends StatefulWidget with AutoRouteWrapper {
  final EditMeasurablePropertyInitialParams initialParams;

  EditMeasurablePropertyPage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditMeasurablePropertyPresenter>(
        create: (_) => getIt(param1: EditMeasurablePropertyPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditMeasurablePropertyPageState createState() => _EditMeasurablePropertyPageState();
}

class _EditMeasurablePropertyPageState extends State<EditMeasurablePropertyPage> {
  EditMeasurablePropertyPresenter get presenter => Provider.of(context, listen: false);

  EditMeasurablePropertyViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  List<MeasurablePropertyMenuItem> get dropdownMenuItems => model.availableTypes.map((type) => MeasurablePropertyMenuItem(type)).asList();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(
              builder: (context) {
                return FitlifyDropdownButton<MeasurablePropertyType>(
                  dropdownMenuItems: dropdownMenuItems,
                  value: model.type,
                  onChanged: (type) => presenter.onViewInteraction(Interaction.onTypeSelected(type)),
                );
              },
            ),
            const SizedBox(height: 20),
            Observer(
                builder: (context) => MeasurablePropertyParamsSelector(
                      property: model.property,
                      onChanged: (property) => presenter.onViewInteraction(Interaction.propertyChanged(property)),
                    )),
            const SizedBox(height: 20),
            Observer(
              builder: (context) => EditRestContainer(
                rest: model.rest,
                showAddRestButton: model.showAddRestButton,
                onRestClicked: () => presenter.onViewInteraction(const Interaction.restClicked()),
                onAddClicked: () => presenter.onViewInteraction(const Interaction.addRestClicked()),
                onDeleteClicked: () => presenter.onViewInteraction(const Interaction.deleteRestClicked()),
              ),
            ),
            const SizedBox(height: 20),
            AccentButton(
              text: S.of(context).saveAction,
              onClicked: () => presenter.onViewInteraction(const Interaction.saveClicked()),
            ),
            const SizedBox(height: 20),
          ],
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
