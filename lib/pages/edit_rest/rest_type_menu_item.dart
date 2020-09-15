import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:flutter/material.dart';

class RestTypeMenuItem extends DropdownMenuItem<RestType> {
  RestTypeMenuItem({Key key, RestType restType}) : super(key: key, value: restType, child: buildChild(restType));

  static Widget buildChild(RestType restType) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(restType.title),
      );
}
