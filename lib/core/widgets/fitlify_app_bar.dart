import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FitlifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool automaticallyImplyLeading;
  final TextStyle titleStyle;

  const FitlifyAppBar({
    Key key,
    this.title,
    this.titleStyle,
    this.actions,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              key: const ValueKey("pageTitle"),
              style: titleStyle,
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
