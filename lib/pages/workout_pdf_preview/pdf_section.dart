import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/pdf_exercise.dart';
import 'package:kt_dart/collection.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfSection {
  final Section section;

  PdfSection(this.section);

  List<Widget> build(Context context) {
    const borderColor = PdfColor(0.7, 0.7, 0.7);
    const leftAndRightBorder = BoxDecoration(
        color: PdfColor.fromInt(0xffF2F2F3),
        border: BoxBorder(
          left: true,
          right: true,
          color: borderColor,
        ));
    return [
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: BoxBorder(
            bottom: true,
            color: borderColor,
          ),
        ),
      ),
      Container(
        decoration: leftAndRightBorder,
        child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Stack(
              children: [
                Align(
                    child: Text(
                  section.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
                _sectionTypeBadge(
                  section.type.map(
                    circuit: (prop) => S.current.circuitTitle,
                    emom: (prop) => S.current.emomTitle,
                    amrap: (prop) => S.current.amrapTitle,
                    normal: (prop) => null,
                  ),
                  section.type.subtitle,
                ),
              ].where((element) => element != null).toList(),
            )),
      ),
      Container(
        width: double.infinity,
        decoration: leftAndRightBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text(section.description)),
        ),
      ),
      ...section.exercises
          .map(
            (it) => Container(
              decoration: leftAndRightBorder,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PdfExercise(it),
              ),
            ),
          )
          .asList(),
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: BoxBorder(
            bottom: true,
            color: borderColor,
          ),
        ),
      ),
      SizedBox(height: 10),
    ];
  }

  Widget _sectionTypeBadge(String name, String formattedValue) {
    if (name == null) {
      return null;
    }
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: 8,
            color: PdfColor(0.9, 0.9, 0.9),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(name, style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 5), Text(formattedValue)]),
          ),
        ));
  }
}
