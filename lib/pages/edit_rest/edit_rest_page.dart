import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/app_ar_accent_action.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_dropdown_button.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_rest/rest_params_selector.dart';
import 'package:fitlify_flutter/pages/edit_rest/rest_type_menu_item.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_presenter.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class EditRestPage extends StatefulWidget with AutoRouteWrapper {
  final EditRestInitialParams initialParams;

  EditRestPage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<EditRestPresenter>(
        create: (_) => getIt(param1: EditRestPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _EditRestPageState createState() => _EditRestPageState();
}

class _EditRestPageState extends State<EditRestPage> {
  EditRestPresenter get presenter => Provider.of(context, listen: false);

  EditRestViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  List<RestTypeMenuItem> get dropdownMenuItems => model.availableTypes.map((it) => RestTypeMenuItem(restType: it)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitlifyAppBar(
        title: widget.initialParams.rest == null ? S.of(context).addRestTitle : S.of(context).editRestTitle,
        actions: [
          AppBarAccentAction(
            onClicked: () => presenter.onViewInteraction(const Interaction.saveClicked()),
            text: S.of(context).saveAction,
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: AppTheme.borderRadiusM,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  Observer(
                      builder: (context) => FitlifyDropdownButton<RestType>(
                            dropdownMenuItems: dropdownMenuItems,
                            value: model.type,
                            onChanged: (type) => presenter.onViewInteraction(Interaction.onTypeSelected(type)),
                          )),
                  const SizedBox(height: 20),
                  Observer(
                      builder: (context) => Text(model.rest.map(
                            timeDuration: (prop) => S.current.restTimeDurationRationale,
                            heartRate: (prop) => S.current.restHeartRateRationale,
                          ))),
                  const SizedBox(height: 20),
                  Observer(
                      builder: (context) => RestParamsSelector(
                            rest: model.rest,
                            onChanged: (rest) => presenter.onViewInteraction(Interaction.onRestChanged(rest)),
                          )),
                  const Expanded(child: SizedBox.expand()),
                ],
              ),
            ),
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
