import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/icons/fitlify_icons_icons.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/loading_state_switcher.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/login/login_presenter.dart';
import 'package:fitlify_flutter/presentation/login/login_initial_params.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget with AutoRouteWrapper {
  final LoginInitialParams initialParams;

  LoginPage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<LoginPresenter>(
        create: (_) => getIt(param1: LoginPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPresenter get presenter => Provider.of(context, listen: false);

  LoginViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitlifyAppBar(
        title: S.of(context).loginTitle,
      ),
      body: SafeArea(
        child: Center(
          child: Observer(builder: (context) => _pageContent()),
        ),
      ),
    );
  }

  LoadingStateSwitcher _pageContent() {
    return LoadingStateSwitcher(
      loadingBuilder: (context) => const CircularProgressIndicator(),
      isLoading: model.logInProgress,
      childBuilder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          RaisedButton.icon(
            color: Colors.black,
            textColor: Colors.white,
            label: Text(S.of(context).logInWithAppleAction),
            onPressed: () => presenter.onViewInteraction(const Interaction.appleLogInClicked()),
            icon: const Icon(FitlifyIcons.apple),
          ),
          const Spacer(),
          FlatButton(
            onPressed: () => presenter.onViewInteraction(const Interaction.anonymousLogInClicked()),
            child: Text(S.of(context).anonymousLoginAction),
          )
        ],
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
