import 'dart:typed_data';

import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_icons.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_section.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

@injectable
class WorkoutPdfBuilder {
  Future<Uint8List> build(PdfPageFormat format, Workout workout, material.ColorScheme scheme) async {
    final doc = Document(title: workout.name, author: 'Fitlify');
    final pageTheme = await _myPageTheme(format);
    if (format.height == double.infinity) {
      doc.addPage(
        Page(
          pageTheme: pageTheme,
          // header: _buildPageHeader,
          build: (context) => Column(
            children: [
              ..._buildWorkoutHeader(context, workout, scheme),
              ..._buildWorkout(context, workout, scheme),
            ],
          ),
        ),
      );
    } else {
      doc.addPage(
        MultiPage(
          pageTheme: pageTheme,
          crossAxisAlignment: CrossAxisAlignment.center,
          footer: _buildPageFooter,
          build: (context) => [
            ..._buildWorkoutHeader(context, workout, scheme),
            ..._buildWorkout(context, workout, scheme),
          ],
        ),
      );
    }
    return doc.save();
  }

  List<Widget> _buildWorkoutHeader(Context context, Workout workout, material.ColorScheme colorScheme) {
    return [
      Text(
        workout.name,
        style: TextStyle(color: colorScheme.onSurface.pdfColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        workout.description,
        style: TextStyle(color: colorScheme.onSurface.pdfColor),
      ),
      SizedBox(height: 20),
    ];
  }

  Future<PageTheme> _myPageTheme(PdfPageFormat orgFormat) async {
    final regularFont = await rootBundle.load("assets/font/Lato-Regular.ttf");
    final boldFont = await rootBundle.load("assets/font/Lato-Bold.ttf");
    final format = orgFormat.copyWith(
      marginLeft: 1 * PdfPageFormat.cm,
      marginTop: 1 * PdfPageFormat.cm,
      marginRight: 1 * PdfPageFormat.cm,
      marginBottom: 1 * PdfPageFormat.cm,
    );
    return PageTheme(
      pageFormat: format,
      // margin: EdgeInsets.all(20),
      theme: ThemeData.withFont(
        base: TtfFont(regularFont),
        bold: TtfFont(boldFont),
      ),
    );
  }

  List<Widget> _buildWorkout(Context context, Workout workout, material.ColorScheme colorScheme) {
    if (workout.sections.isEmpty()) {
      return [];
    }
    return workout.sections
        .mapIndexed((index, it) => [
              ...PdfSection(it).build(context),
              pdfDownArrow(const PdfColor(0.3, 0.3, 0.3)),
            ]) //
        .flatMap((it) => it.toImmutableList())
        .asList()
          ..removeLast();
  }

  Widget _buildPageFooter(Context context) {
    const headerColor = PdfColor(0.6, 0.6, 0.6);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              S.current.appName,
              style: const TextStyle(color: headerColor),
            )),
            Text(
              S.current.pageNumberFormat(context.pageNumber, context.pagesCount),
              style: const TextStyle(color: headerColor),
            ),
          ],
        ),
      ],
    );
  }
}
