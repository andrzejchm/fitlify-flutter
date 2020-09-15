import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Shape pdfDownArrow(PdfColor color) => Shape(
      "M19,15l-1.41-1.41L13,18.17V2H11v16.17l-4.59-4.59L5,15l7,7L19,15z",
      width: 24,
      height: 24,
      fillColor: color,
    );
