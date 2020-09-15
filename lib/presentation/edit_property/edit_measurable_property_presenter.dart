import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/presentation/edit_property/edit_measurable_property_initial_params.dart';
import 'package:fitlify_flutter/presentation/edit_rest/edit_rest_initial_params.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'edit_measurable_property_presenter.g.dart';

part 'edit_measurable_property_presentation_model.dart';

part 'edit_measurable_property_presenter.freezed.dart';

@injectable
class EditMeasurablePropertyPresenter {
  final AppNavigator _appNavigator;
  final EditMeasurablePropertyPresentationModel presentationModel;

  EditMeasurablePropertyViewModel get viewModel => presentationModel;

  EditMeasurablePropertyPresenter(@factoryParam this.presentationModel, this._appNavigator);

  void onViewInteraction(Interaction viewInteraction) {
    viewInteraction.when(
      onTypeSelected: (type) => presentationModel.type = type,
      saveClicked: () => _appNavigator.closeWithResult(presentationModel.property),
      propertyChanged: (property) => _updateProperty(property),
      addRestClicked: () => _editRest(rest: null),
      restClicked: () => _editRest(rest: presentationModel.rest),
      deleteRestClicked: () => _updateRest(rest: null),
    );
  }

  Future<void> close() async {}

  Future<void> _editRest({@required Rest rest}) async {
    final editedRest = await _appNavigator.openPage(AppPageRoute.editRest(
      initialParams: rest == null //
          ? const EditRestInitialParams.newRest()
          : EditRestInitialParams.editRest(rest: rest),
    ));
    if (editedRest != null) {
      _updateRest(rest: editedRest as Rest);
    }
  }

  void _updateRest({@required Rest rest}) {
    final updated = presentationModel.property.maybeMap(
      sets: (prop) => prop.copyWith(restBetweenSets: rest),
      orElse: () => presentationModel.property,
    );
    _updateProperty(updated);
  }

  void _updateProperty(MeasurableProperty property) {
    presentationModel.propertiesByType[property.type] = property;
  }
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.onTypeSelected(MeasurablePropertyType type) = InteractionOnTypeSelected;

  const factory Interaction.saveClicked() = InteractionSaveClicked;

  const factory Interaction.propertyChanged(MeasurableProperty property) = InteractionPropertyChanged;

  const factory Interaction.addRestClicked() = InteractionAddRestClicked;

  const factory Interaction.restClicked() = InteractionRestClicked;

  const factory Interaction.deleteRestClicked() = InteractionDeleteRestClicked;
}
