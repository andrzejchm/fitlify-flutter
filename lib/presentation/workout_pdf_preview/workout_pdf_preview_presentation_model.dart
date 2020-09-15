part of 'workout_pdf_preview_presenter.dart';

abstract class WorkoutPdfPreviewViewModel {
  Workout get workout;
}

class WorkoutPdfPreviewPresentationModel = WorkoutPdfPreviewPresentationModelBase with _$WorkoutPdfPreviewPresentationModel;

abstract class WorkoutPdfPreviewPresentationModelBase with Store implements WorkoutPdfPreviewViewModel {
  final WorkoutPdfPreviewInitialParams initialParams;

  @observable
  @override
  Workout workout;

  WorkoutPdfPreviewPresentationModelBase(this.initialParams) : workout = initialParams.workout;
}
