import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/pages/edit_property/add_rest_button.dart';
import 'package:fitlify_flutter/pages/edit_property/rest_list_item.dart';
import 'package:flutter/material.dart';

class EditRestContainer extends StatelessWidget {
  final bool showAddRestButton;
  final VoidCallback onAddClicked;
  final VoidCallback onRestClicked;
  final VoidCallback onDeleteClicked;
  final Rest rest;

  const EditRestContainer({
    Key key,
    @required this.showAddRestButton,
    @required this.onAddClicked,
    @required this.onRestClicked,
    @required this.rest,
    @required this.onDeleteClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return rest != null
        ? RestListItem(rest: rest, onClicked: onRestClicked, deleteClicked: onDeleteClicked)
        : showAddRestButton
            ? AddRestButton(onClicked: onAddClicked)
            : const SizedBox.shrink();
  }
}
