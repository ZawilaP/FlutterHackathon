import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:badambadam/storage.dart';
import 'package:intl/intl.dart';

class PDFSave extends StatefulWidget {
  const PDFSave({super.key, this.score, this.allAnswers});

  final int? score;
  final List<int>? allAnswers;

  @override
  _PDFSaveState createState() => _PDFSaveState();
}

class _PDFSaveState extends State<PDFSave> {
  var pdf = pw.Document();
  Survey? survey;
  List<String>? topLevelSurvey = getTopLevelNodes();
  
  var anchor;

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'm-chat-r-results';
    html.document.body?.children.add(anchor);
  }

  createPDF() async {
    final fontBase = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttfBase = pw.Font.ttf(fontBase);

    var currentGuid = getCurrentGuid()
        .toString()
        .replaceAll(".", "-")
        .replaceAll(" ", "-")
        .replaceAll(":", "-")
        .replaceAll("_", "-")
        .toString()
        .split('-');

    var currentGuidUserNumber = currentGuid[currentGuid.length - 1];


    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: ttfBase),
        build: (pw.Context context) => [
          pw.Text('Wyniki badania M-Chat-R', style: pw.TextStyle(fontSize: 20)),
          pw.Divider(thickness: 0.5),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                          text: pw.TextSpan(children: <pw.TextSpan>[
                        pw.TextSpan(text: "Wynik: "),
                        pw.TextSpan(
                            text: '${widget.score}/20',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                          text: pw.TextSpan(children: <pw.TextSpan>[
                        pw.TextSpan(text: "Identyfikator ankiety: "),
                        pw.TextSpan(
                            text: currentGuidUserNumber,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                      pw.Text(
                          'Data wykonania badania: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()}')
                    ])
              ]),
          pw.SizedBox(height: 8),
          pw.Table.fromTextArray(
              headers: <String>['Pytanie', 'Odpowiedz', 'Wynik'],
              border: null,
              headerStyle: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(
                fontSize: 10,
              ),
              columnWidths: {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1)
              },
              cellAlignment: pw.Alignment.center,
              cellAlignments: {0: pw.Alignment.centerLeft},
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFB200'),
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    width: .5,
                  ),
                ),
              ),
              data: List<List<String>>.generate(
                  topLevelSurvey!.length,
                  (index) => <String>[
                       topLevelSurvey![index].split('+')[0],
                        widget.allAnswers![index] == 0
                            ? (topLevelSurvey![index].split('+')[1] == 'true' ? 'NIE' : 'TAK')
                            : (topLevelSurvey![index].split('+')[1] == 'true' ? 'TAK' :'NIE'),
                       widget.allAnswers![index].toString()
                      ]))
        ],
      ),
    );

    savePDF();
  }

  @override
  void initState() {
    super.initState();
    createPDF();
  }

  @override
  Widget build(BuildContext context) {
    print(topLevelSurvey);
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        backgroundColor: Colors.white,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 1);

    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.download_rounded),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Pobierz wyniki',
            style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 15, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        style: style,
        onPressed: () {
          anchor.click();
        },
      ),
    );
  }
}
