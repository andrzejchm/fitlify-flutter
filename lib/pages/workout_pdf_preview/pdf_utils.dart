import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';

extension ToPdf on material.Color {
  PdfColor get pdfColor => PdfColor.fromInt(value);
}

// ignore: avoid_classes_with_only_static_members
class FitlifyPdfColors {
  static PdfColor accent = AppThemeColors.accent.pdfColor;
  static PdfColor accentVariant = AppThemeColors.accentVariant.pdfColor;
  static PdfColor onAccent = const PdfColor.fromInt(0xFFFFFFFF);
  static PdfColor background = const PdfColor.fromInt(0xffF2F2F3);
  static PdfColor surface = const PdfColor.fromInt(0xFFFFFFFF);
  static PdfColor onBackground = const PdfColor.fromInt(0xFF000000);
}
