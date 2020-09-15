import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/presentation/workout_pdf_preview/workout_pdf_preview_initial_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'workout_pdf_preview_presenter.g.dart';
part 'workout_pdf_preview_presentation_model.dart';
part 'workout_pdf_preview_presenter.freezed.dart';

@injectable
class WorkoutPdfPreviewPresenter {
  final WorkoutPdfPreviewPresentationModel _model;

  WorkoutPdfPreviewViewModel get viewModel => _model;

  WorkoutPdfPreviewPresenter(@factoryParam this._model);

  Future<void> onViewInteraction(Interaction viewInteraction) async => viewInteraction.when(buttonClicked: () {});

  Future<void> close() async {}
}

@freezed
abstract class Interaction with _$Interaction {
  const factory Interaction.buttonClicked() = InteractionButtonClicked;
}
