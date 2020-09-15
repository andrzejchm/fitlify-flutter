import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/profile_image.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/profile/profile_presenter.dart';
import 'package:fitlify_flutter/presentation/profile/profile_initial_params.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget with AutoRouteWrapper {
  final ProfileInitialParams initialParams;

  ProfilePage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<ProfilePresenter>(
        create: (_) => getIt(param1: ProfilePresentationModel(initialParams, getIt())),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilePresenter get presenter => Provider.of(context, listen: false);

  ProfileViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitlifyAppBar(title: S.of(context).profileTitle),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Observer(builder: (context) => ProfileImage(url: model.user?.avatarUrl, size: 60)),
              Observer(builder: (context) => Text(model.user?.displayName ?? "")),
              const Expanded(child: SizedBox.shrink()),
              Observer(builder: (context) => _logOutButton(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _logOutButton(BuildContext context) => AnimatedSwitcher(
        duration: const MediumDuration(),
        child: model.logOutProgress
            ? const CircularProgressIndicator()
            : FlatButton(
                onPressed: () => presenter.onViewInteraction(const Interaction.logOutClicked()),
                child: Text(S.of(context).logOutAction),
              ),
      );

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }
}
