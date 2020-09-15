import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditableActionButtons extends StatelessWidget {
  const EditableActionButtons({
    Key key,
    @required this.visible,
    @required this.selectedCount,
    @required this.deleteClicked,
    @required this.vsync,
  }) : super(key: key);

  final bool visible;
  final int selectedCount;
  final VoidCallback deleteClicked;
  final TickerProvider vsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          alignment: Alignment.topCenter,
          curve: Curves.easeOutCubic,
          duration: const LongDuration(),
          vsync: vsync,
          child: Container(
            color: Theme.of(context).accentColor.withOpacity(0.2),
            height: visible ? null : 0,
            child: Padding(
              padding: EdgeInsets.only(
                top: 12.0,
                left: 12.0,
                right: 12.0,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  AccentButton(
                      enabled: selectedCount > 0,
                      color: Theme.of(context).colorScheme.error,
                      text: S.of(context).deleteSelectedAction(selectedCount),
                      onClicked: deleteClicked),
                ]),
              ),
            ),
          ),
        )
      ],
    );
  }
}
