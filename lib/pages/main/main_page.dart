import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/pages/main/widgets/main_app_bar.dart';
import 'package:fitlify_flutter/pages/workouts_list/workouts_list_page.dart';
import 'package:fitlify_flutter/presentation/workouts_list/workouts_list_initial_params.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/main/main_presenter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget with AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => Provider<MainPresenter>(
        create: (_) => getIt(param1: MainPresentationModel(getIt())),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainPresenter get presenter => Provider.of(context, listen: false);

  MainViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(model: model, presenter: presenter),
      body: WorkoutsListPage(initialParams: WorkoutsListInitialParams()).wrappedRoute(context),
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
