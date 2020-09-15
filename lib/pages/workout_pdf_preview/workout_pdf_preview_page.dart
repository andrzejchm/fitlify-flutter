import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/core/widgets/fitlify_app_bar.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/workout_pdf_preview/workout_pdf_builder.dart';
import 'package:flutter/material.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/presentation/workout_pdf_preview/workout_pdf_preview_presenter.dart';
import 'package:fitlify_flutter/presentation/workout_pdf_preview/workout_pdf_preview_initial_params.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class WorkoutPdfPreviewPage extends StatefulWidget with AutoRouteWrapper {
  final WorkoutPdfPreviewInitialParams initialParams;

  WorkoutPdfPreviewPage({Key key, @required this.initialParams}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => Provider<WorkoutPdfPreviewPresenter>(
        create: (_) => getIt(param1: WorkoutPdfPreviewPresentationModel(initialParams)),
        dispose: (_, it) => it.close(),
        child: this,
      );

  @override
  _WorkoutPdfPreviewPageState createState() => _WorkoutPdfPreviewPageState();
}

class _WorkoutPdfPreviewPageState extends State<WorkoutPdfPreviewPage> {
  WorkoutPdfPreviewPresenter get presenter => Provider.of(context, listen: false);

  WorkoutPdfPreviewViewModel get model => presenter.viewModel;

  final List<ReactionDisposer> _disposeReactions = [];
  WorkoutPdfBuilder pdfBuilder;

  @override
  void initState() {
    pdfBuilder = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formats = {
      "A4": PdfPageFormat.a4,
      S.of(context).continuousPageFormat: PdfPageFormat.a4.copyWith(height: double.infinity),
    };
    return Scaffold(
      appBar: FitlifyAppBar(
        title: S.of(context).pdfExportTitle,
      ),
      body: Observer(builder: (context) {
        final workout = model.workout;
        final theme = Theme.of(context);
        return PdfPreview(
          build: (format) async => pdfBuilder.build(format, workout, theme.colorScheme),
          // canChangePageFormat: false,
          initialPageFormat: formats[S.of(context).continuousPageFormat],
          pageFormats: formats,
          pdfPreviewPageDecoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                color: Color(0x22000000),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (final dispose in _disposeReactions) {
      dispose();
    }
    super.dispose();
  }
}
