import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:badambadam/storage.dart';

class PDFSave extends StatefulWidget {
  const PDFSave({super.key, this.score, this.allAnswers});

  final int? score;
  final List<int>? allAnswers;

  @override
  _PDFSaveState createState() => _PDFSaveState();
}

class _PDFSaveState extends State<PDFSave> {
  final pdf = pw.Document();
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
    if (survey == null) {}
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('M-Chat-R Survey Results',
                style: pw.TextStyle(fontSize: 20)),
            pw.Divider(thickness: 0.5),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                            text: pw.TextSpan(children: <pw.TextSpan>[
                          pw.TextSpan(text: "Your child's score: "),
                          pw.TextSpan(
                              text: '${widget.score}/20',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold))
                        ])),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                            text: pw.TextSpan(children: <pw.TextSpan>[
                          pw.TextSpan(text: "SurveyID: "),
                          pw.TextSpan(
                              text: getCurrentGuid()
                                  .toString()
                                  .replaceAll(".", "-")
                                  .replaceAll(" ", "-")
                                  .replaceAll(":", "-")
                                  .replaceAll("_", "-"),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold))
                        ])),
                        pw.Text('Survey date: ${DateTime.now()}')
                      ])
                ]),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
                headers: <String>['Question', 'Answer', 'Score'],
                border: null,
                headerStyle:
                    pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 10),
                columnWidths: {
                  0: pw.FlexColumnWidth(2.5),
                  1: pw.FlexColumnWidth(1.5),
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
                          topLevelSurvey![index].split('+')[1] == 'true'
                              ? 'YES'
                              : 'NO',
                          widget.allAnswers![index].toString()
                        ]))
          ],
        ),
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
    return ElevatedButton.icon(
      icon: Icon(Icons.download_rounded),
      label: Text('Pobierz wyniki'),
      onPressed: () {
        anchor.click();
      },
    );
  }
}
