import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/core/widgets/profile_image.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/presentation/main/main_presenter.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MainPresenter presenter;
  final MainViewModel model;

  const MainAppBar({
    Key key,
    @required this.presenter,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FitlifyAppBar(
      title: S.of(context).appName,
      titleStyle: GoogleFonts.montserrat(
        color: AppThemeColors.text,
        fontWeight: FontWeight.w700,
      ),
      actions: [
        Observer(
          builder: (context) => IconButton(
            icon: ProfileImage(url: model.user?.avatarUrl),
            onPressed: () => presenter.onViewInteraction(const Interaction.profileClicked()),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
