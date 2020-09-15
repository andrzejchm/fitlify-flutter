import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class MeasurablePropertyRow extends StatelessWidget {
  final MeasurableProperty property;
  final bool isRest;

  const MeasurablePropertyRow({
    Key key,
    @required this.property,
    @required this.isRest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                property.type.icon,
                color: (isRest ? colorScheme.onSurface : colorScheme.onSecondary).withOpacity(0.6),
                size: AppTheme.smallIconSize,
              ),
              const SizedBox(width: 5),
              Text(
                property.type.name,
                style: TextStyle(color: (isRest ? colorScheme.onSurface : colorScheme.onSecondary).withOpacity(0.6)),
              ),
              const Expanded(child: SizedBox.shrink()),
              Text(
                property.formatValue(),
                style: TextStyle(color: isRest ? colorScheme.onSurface : colorScheme.onSecondary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (property.rest != null) ...[
            const SizedBox(height: 5),
            _restContainer(context, colorScheme),
          ]
        ],
      ),
    );
  }

  Widget _restContainer(BuildContext context, ColorScheme colorScheme) {
    final colorScheme = Theme.of(context).colorScheme;
    return Transform.translate(
      offset: const Offset(AppTheme.spacingM, 0),
      child: Padding(
        padding: const EdgeInsets.only(left: AppTheme.spacingL),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: AppTheme.radiusM,
              bottomRight: AppTheme.radiusM,
              topRight: AppTheme.radiusM,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                child: Text(
                  S.of(context).restBetweenSetsTitle,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.w200, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                child: Row(
                  children: [
                    Icon(
                      property.rest.property.type.icon,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      property.rest.type.title,
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Text(
                      property.rest.property.formatValue(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
