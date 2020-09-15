import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:flutter/material.dart';

class SectionTypeMenuItem extends DropdownMenuItem<SectionTypeEnum> {
  SectionTypeMenuItem(SectionTypeEnum type) : super(value: type, child: buildChild(type));

  static Widget buildChild(SectionTypeEnum type) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(type.title),
      );
}
