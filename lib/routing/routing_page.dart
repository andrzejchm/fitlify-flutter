import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/routing/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/routing/routing_presenter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class RoutingPage extends StatefulWidget with AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => Provider<RoutingPresenter>(
        create: (_) => getIt(),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _RoutingPageState createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  RoutingPresenter get presenter => Provider.of(context, listen: false);

  RoutingViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => presenter.onViewInteraction(const Interaction.appOpened()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLoading();
  }

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }
}
