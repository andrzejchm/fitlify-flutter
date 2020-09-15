import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_dropdown_button.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_section_type/section_type_menu_item.dart';
import 'package:fitlify_flutter/pages/edit_section_type/section_type_params_selector.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_section_type/edit_section_type_presenter.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class EditSectionTypePage extends StatefulWidget with AutoRouteWrapper {
  final EditSectionTypeInitialParams initialParams;

  EditSectionTypePage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditSectionTypePresenter>(
        create: (_) => getIt(param1: EditSectionTypePresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditSectionTypePageState createState() => _EditSectionTypePageState();
}

class _EditSectionTypePageState extends State<EditSectionTypePage> {
  EditSectionTypePresenter get presenter => Provider.of(context, listen: false);

  EditSectionTypeViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  List<SectionTypeMenuItem> get dropdownMenuItems => model.availableTypes.map((type) => SectionTypeMenuItem(type)).toList();

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
                return FitlifyDropdownButton<SectionTypeEnum>(
                  dropdownMenuItems: dropdownMenuItems,
                  value: model.type.type,
                  onChanged: (type) => presenter.onViewInteraction(Interaction.onTypeSelected(type)),
                );
              },
            ),
            const SizedBox(height: 20),
            Observer(
                builder: (context) => SectionTypeParamsSelector(
                      type: model.type,
                      onChanged: (property) => presenter.onViewInteraction(Interaction.onTypeChanged(property)),
                    )),
            Observer(
                builder: (context) => SizedBox(
                      height: model.type.type == SectionTypeEnum.normal ? 0 : 120,
                    )),
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
