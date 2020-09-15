import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:flutter/material.dart';

class MeasurablePropertyMenuItem extends DropdownMenuItem<MeasurablePropertyType> {
  MeasurablePropertyMenuItem(MeasurablePropertyType type)
      : super(
          child: buildChild(type),
          value: type,
        );

  static Widget buildChild(MeasurablePropertyType type) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(type.icon),
            const SizedBox(width: 20),
            Text(type.name),
          ],
        ),
      );
}
