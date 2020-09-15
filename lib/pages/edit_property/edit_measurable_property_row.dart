import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/pages/edit_property/rest_list_item.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class EditMeasurablePropertyRow extends StatelessWidget {
  final MeasurableProperty property;
  final VoidCallback onClicked;
  final VoidCallback onDeleteClicked;

  const EditMeasurablePropertyRow({
    Key key,
    @required this.property,
    @required this.onClicked,
    this.onDeleteClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        borderRadius: AppTheme.borderRadiusM,
        child: InkWell(
          onTap: onClicked,
          borderRadius: AppTheme.borderRadiusM,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(property.type.icon),
                      const SizedBox(width: 10),
                      Text(property.type.name),
                      const Expanded(child: SizedBox()),
                      Text(
                        property.formatValue(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Theme.of(context).colorScheme.error),
                        onPressed: onDeleteClicked,
                      ),
                    ],
                  ),
                  if (property.rest != null)
                    RestListItem(
                      rest: property.rest,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
