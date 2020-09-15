import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class SectionTypeRow extends StatelessWidget {
  final VoidCallback onClicked;
  final SectionType sectionType;
  final EdgeInsets padding;

  const SectionTypeRow({
    Key key,
    @required this.onClicked,
    @required this.sectionType,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  const SectionTypeRow.small(this.sectionType)
      : onClicked = null,
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      borderRadius: AppTheme.borderRadiusM,
      child: InkWell(
        onTap: onClicked,
        borderRadius: AppTheme.borderRadiusM,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sectionType.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (sectionType.subtitle.isNotEmpty) ...[
                const SizedBox(width: 5),
                Text(
                  sectionType.subtitle,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
