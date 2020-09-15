import 'package:fitlify_flutter/domain/entities/measurable_property.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfMeasurableProperty extends StatelessWidget {
  final MeasurableProperty property;
  final bool isRest;

  // ignore: avoid_positional_boolean_parameters
  PdfMeasurableProperty(
    this.property, {
    @required this.isRest,
  });

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: Text(property.type.name,
                    style: TextStyle(
                      color: isRest ? FitlifyPdfColors.onBackground : FitlifyPdfColors.onAccent,
                    ))),
            Text(
              property.formatValue(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isRest ? FitlifyPdfColors.onBackground : FitlifyPdfColors.onAccent,
              ),
            ),
          ],
        ),
        if (property.rest?.property != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Transform.translate(
              offset: const PdfPoint(8, 0),
              child: Stack(
                children: [
                  Container(width: 8, height: 8, color: PdfColors.white),
                  Container(
                    decoration: const BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: 8,
                    ),
                    child: Column(
                      children: [
                        Text(S.current.restBetweenSetsTitle,
                            style: TextStyle(
                              color: const PdfColor(0.4, 0.4, 0.4),
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            )),
                        PdfMeasurableProperty(property.rest.property, isRest: true),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
        ],
      ]),
    );
  }
}
