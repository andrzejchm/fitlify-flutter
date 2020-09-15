import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_measurable_property.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_utils.dart';
import 'package:kt_dart/collection.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfExercise extends StatelessWidget {
  final Exercise exercise;

  PdfExercise(this.exercise);

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: exercise.isRest ? FitlifyPdfColors.surface : FitlifyPdfColors.accentVariant,
          border: const BoxBorder(color: PdfColor(0.8, 0.8, 0.8)),
          borderRadius: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Text(
              exercise.isRest ? S.current.restTypeOption : exercise.name,
              style: TextStyle(
                color: exercise.isRest ? const PdfColor(0.3, 0.3, 0.3) : FitlifyPdfColors.onAccent,
                fontWeight: exercise.isRest ? FontWeight.normal : FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (exercise.notes.isNotEmpty)
              Opacity(
                child: Text(
                  exercise.notes,
                  style: TextStyle(
                    color: exercise.isRest ? FitlifyPdfColors.onBackground : FitlifyPdfColors.onAccent,
                    fontWeight: exercise.isRest ? FontWeight.normal : FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                opacity: 0.7,
              ),
            SizedBox(height: exercise.properties.isEmpty() ? 0 : 10),
            ...exercise.properties.map((it) => PdfMeasurableProperty(it, isRest: exercise.isRest)).asList(),
            SizedBox(height: exercise.properties.isEmpty() ? 0 : 10),
            if (exercise.rest != null)
              PdfMeasurableProperty(
                exercise.rest.property,
                isRest: exercise.isRest,
              )
          ]),
        ),
      ),
    );
  }
}
