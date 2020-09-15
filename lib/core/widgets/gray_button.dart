import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class GrayButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onClicked;
  final Color color;
  final bool enabled;
  final double padding;

  const GrayButton({
    Key key,
    this.text,
    this.icon,
    @required this.onClicked,
    this.color,
    this.enabled = true,
    this.padding = 16,
  })  : assert((text != null) != (icon != null), "You have to specify icon or text, not both"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(kToolbarHeight / 2));
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      borderRadius: borderRadius,
      elevation: AppTheme.elevationXS,
      shadowColor: Colors.black87,
      color: (color ?? colorScheme.surface).withOpacity(enabled ? 1.0 : 0.5),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: enabled ? onClicked : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: padding,
            horizontal: icon != null ? padding : padding * 2,
          ),
          child: text != null
              ? Text(
                  text,
                  style: AppThemeTextStyles.title.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onBackground,
                  ),
                )
              : Icon(icon, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
