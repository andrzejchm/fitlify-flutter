import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:kt_dart/collection.dart';

class EditMeasurablePropertyInitialParams {
  final MeasurableProperty property;
  final KtList<MeasurablePropertyType> availableTypes;

  EditMeasurablePropertyInitialParams(this.property, this.availableTypes);
}
