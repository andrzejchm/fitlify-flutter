import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TitleWithTooltip extends StatelessWidget {
  final String title;
  final String tooltip;

  const TitleWithTooltip({Key key, @required this.title, this.tooltip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        if (tooltip != null)
          Builder(
            builder: (context) => IconButton(
              padding: const EdgeInsets.all(0),
              iconSize: 20,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              icon: const Icon(Icons.info),
              onPressed: () {
                SuperTooltip(
                  popupDirection: TooltipDirection.down,
                  borderWidth: 0,
                  shadowColor: Colors.black38,
                  shadowBlurRadius: 20,
                  shadowSpreadRadius: 1,
                  borderColor: Colors.transparent,
                  content: Material(color: Theme.of(context).colorScheme.surface, child: Text(tooltip)),
                ).show(context);
              },
            ),
          ),
      ],
    );
  }
}
