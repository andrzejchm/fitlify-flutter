import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:flutter/foundation.dart';

class EditRestInitialParams {
  final Rest rest;

  const EditRestInitialParams.editRest({@required this.rest}) : assert(rest != null);

  const EditRestInitialParams.newRest() : rest = null;
}
