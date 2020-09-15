import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/core/widgets/app_ar_accent_action.dart';
import 'package:flutter/material.dart';

class AppBarProgressButton extends StatelessWidget {
  final VoidCallback onClicked;
  final String text;
  final bool progress;

  const AppBarProgressButton({
    Key key,
    @required this.onClicked,
    @required this.text,
    @required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedCrossFade(
        duration: const MediumDuration(),
        layoutBuilder: (top, topKey, bottom, bottomKey) => Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              key: topKey,
              child: top,
            ),
            Positioned(
              key: bottomKey,
              child: bottom,
            )
          ],
        ),
        crossFadeState: progress ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
        secondChild: SizedBox(height: kToolbarHeight, child: AppBarAccentAction(onClicked: onClicked, text: text)),
      ),
    );
  }
}
