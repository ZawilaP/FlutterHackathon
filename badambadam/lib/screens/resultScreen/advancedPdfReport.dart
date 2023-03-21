import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:badambadam/storage.dart';
import 'package:intl/intl.dart';

class AdvancedPDFSave extends StatefulWidget {
  const AdvancedPDFSave({super.key, this.score, this.allRawAnswers});

  final int? score;
  final Map<String, List<String>>? allRawAnswers;

  @override
  _AdvancedPDFSaveState createState() => _AdvancedPDFSaveState();
}

class _AdvancedPDFSaveState extends State<AdvancedPDFSave> {
  var pdf = pw.Document();
  Survey? survey;
  List<String>? advancedSurveyQuestions = getAdvancedSurveyQuestions();
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
      ..download = 'm-chat-rf-results';
    html.document.body?.children.add(anchor);
  }

  String getQuestions(String questionType, String questionList) {
    if (questionType == 'Simple_Yes_No') {
      return questionList.substring(1, questionList.length - 1);
    }

    if (questionType == 'YesNoBranching' ||
        questionType == 'OneYesWillDoStopAsking') {
      return questionList
          .substring(1, questionList.length - 1)
          .replaceAll('?,', '?,\n');
    }

    if (questionType == 'SingleSelect') {
      return questionList.substring(1, questionList.length - 1).split('?,')[0];
    }
    return 'Text';
  }

  String getAnswers(
      String questionType, List<String>? answers, String questionList) {
    bool noAnswer = !answers!.contains('FAIL_YES') &&
        !answers.contains('FAIL_NO') &&
        !answers.contains('PASS_YES') &&
        !answers.contains('PASS_NO');

    if (questionType == 'Simple_Yes_No') {
      return answers.contains('PASS') || answers.contains('FAIL')
          ? answers[0]
          : 'No Answer';
    }
    if (questionType == 'YesNoBranching' ||
        questionType == 'OneYesWillDoStopAsking' ||
        questionType == 'OneYesWillDoKeepAsking') {
      return noAnswer ? 'No Answer' : answers.toString().replaceAll(',', '\n');
    }
    if (questionType == 'SingleSelect') {
      if (answers.contains('PASS_YES')) {
        return questionList
            .substring(1, questionList.length - 1)
            .split('?,')[answers.indexOf('PASS_YES') + 1];
      } else if (answers.contains('FAIL_YES')) {
        return questionList
            .substring(1, questionList.length - 1)
            .split('?,')[answers.indexOf('FAIL_YES') + 1];
      } else {
        return 'No Answer';
      }
    }

    return 'Dupa';
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
          pw.Text('M-Chat-RF Survey Results',
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
                            text: widget.score! >= 2 ? 'Dodatni' : 'Ujemny',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                          text: pw.TextSpan(children: <pw.TextSpan>[
                        pw.TextSpan(text: "SurveyID: "),
                        pw.TextSpan(
                            text: currentGuidUserNumber,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                      pw.Text(
                          'Survey date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()}')
                    ])
              ]),
          pw.SizedBox(height: 8),
          pw.Table.fromTextArray(
              headers: <String>['', 'Question', 'Answer'],
              border: null,
              headerStyle: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(
                fontSize: 10,
              ),
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(2)
              },
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft
              },
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
              data: List<List<String>>.generate(widget.allRawAnswers!.length,
                  (index) {
                String questionType =
                    advancedSurveyQuestions![index].split('+')[1];
                String questionList =
                    advancedSurveyQuestions![index].split('+')[0];
                List<String>? answers = widget
                    .allRawAnswers![widget.allRawAnswers!.keys.toList()[index]];
                return <String>[
                  widget.allRawAnswers!.keys.toList()[index],
                  getQuestions(questionType, questionList),
                  getAnswers(questionType, answers, questionList)
                ];
              }))
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
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
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
