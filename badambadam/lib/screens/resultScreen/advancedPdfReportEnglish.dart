import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:badambadam/storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnglishAdvancedPDFSave extends StatefulWidget {
  const EnglishAdvancedPDFSave(
      {super.key, this.score, this.allRawAnswers, this.allCalculatedAnswers});

  final int? score;
  final Map<String, List<String>>? allRawAnswers;
  final Map<dynamic, dynamic>? allCalculatedAnswers;

  @override
  _EnglishAdvancedPDFSaveState createState() => _EnglishAdvancedPDFSaveState();
}

class _EnglishAdvancedPDFSaveState extends State<EnglishAdvancedPDFSave> {
  var pdf = pw.Document();
  Survey? survey;
  List<List<String>>? advancedSurveyQuestions = getAdvancedSurveyQuestions();

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

  String getQuestions(String questionType, List<String> questionList) {
    if (questionType == 'Simple_Yes_No') {
      return questionList[0].toString();
    }

    if (questionType == 'YesNoBranching' ||
        questionType == 'OneYesWillDoStopAsking' ||
        questionType == 'SingleSelect') {
      var tempQuestionList = questionList;
      for (int i = 1; i < tempQuestionList.length; i++) {
        tempQuestionList[i] = '$i. ${tempQuestionList[i]}';
      }

      return tempQuestionList
          .getRange(0, tempQuestionList.length - 1)
          .join('\n');
    }
    return 'Error';
  }

  String getAnswers(String questionType, List<String>? answers,
      List<String> questionList, String questionId) {
    // bool noAnswer = !answers!.contains('FAIL_YES') &&
    //     !answers.contains('FAIL_NO') &&
    //     !answers.contains('PASS_YES') &&
    //     !answers.contains('PASS_NO') ;

    print(answers.toString());

    var noAnswerCount = answers!.where((element) => element == '-1');

    bool noAnswer = answers.length == noAnswerCount.length;

    var reversedQuestionsIds = ['2', '5', '7']; // hardcoded for now

    if (questionType == 'Simple_Yes_No') {
      var isReversed = reversedQuestionsIds.contains(questionId);
      return noAnswer
          ? 'No answer.'
          : (answers[0] == 'PASS'
              ? (isReversed ? 'NO' : 'YES')
              : (isReversed ? 'YES' : 'NO'));
    }
    if (questionType == 'YesNoBranching' ||
        questionType == 'OneYesWillDoStopAsking' ||
        questionType == 'OneYesWillDoKeepAsking') {
      for (int i = 0; i < answers.length; i++) {
        var answerWordsList = answers[i].toString().split('_');

        if (!answerWordsList.contains('-1')) {
          var passOrFailWords =
              answers[i].toString().split('_')[0] == 'PASS' ? '(P)' : '(F)';
          var newAnswerWords =
              answers[i].toString().split('_')[1] == 'YES' ? 'YES' : 'NO';
          bool isOpenAnswer = answers[i].toString().split('_')[0] == 'OPEN';

          if (isOpenAnswer) {
            answers[i] = '${i + 1}. ${answers[i].toString().split('_')[1]}';
          } else {
            answers[i] = '${i + 1}. $passOrFailWords $newAnswerWords';
          }
        } else {
          answers[i] = '${i + 1}. No answer.';
        }
      }

      return noAnswer
          ? 'No answer'
          : answers
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll(',', '\n');
    }
    if (questionType == 'SingleSelect') {
      if (answers.contains('PASS_YES')) {
        return questionList[answers.indexOf('PASS_YES') + 1].toString();
      } else if (answers.contains('FAIL_YES')) {
        return questionList[answers.indexOf('FAIL_YES') + 1].toString();
      } else {
        return 'No answer';
      }
    }

    return 'No answer';
  }

  String getScoreText(int? score) {
    String currText = '';

    if (score == 1) {
      currText = 'point';
    } else {
      currText = 'points';
    }

    return currText;
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

    bool noAnswerFlag = false;

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: ttfBase),
        build: (pw.Context context) => [
          pw.Text('Results of the M-CHAT R/F exam',
              style: pw.TextStyle(fontSize: 18)),
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
                      ])),
                      pw.RichText(
                          text: pw.TextSpan(children: <pw.TextSpan>[
                        pw.TextSpan(
                            text:
                                '${widget.score} ${getScoreText(widget.score)} - ${widget.score! >= 2 ? 'passed' : 'failed'}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                          text: pw.TextSpan(children: <pw.TextSpan>[
                        pw.TextSpan(text: "Survey ID: "),
                        pw.TextSpan(
                            text: currentGuidUserNumber,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ])),
                      pw.Text(
                          'Date of completion: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()}')
                    ])
              ]),
          pw.SizedBox(height: 8),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text('Summary of your answers:'),
          ),
          pw.Table.fromTextArray(
              headers: <String>['Question number', 'Answer'],
              border: null,
              headerStyle: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(
                fontSize: 10,
              ),
              // columnWidths: {
              //   0: pw.FlexColumnWidth(1),
              //   1: pw.FlexColumnWidth(4),
              // },
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                // 2: pw.Alignment.centerLeft
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
              data: List<List<String>>.generate(
                  widget.allCalculatedAnswers!.length, (index) {
                return <String>[
                  widget.allCalculatedAnswers!.keys.toList()[index].toString(),
                  widget.allCalculatedAnswers!.values.toList()[index] == 1
                      ? 'Fail'
                      : 'Pass'
                ];
              })),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text('Detailed answers:'),
          ),
          pw.Table.fromTextArray(
              headers: <String>['Question number', 'Question', 'Answer'],
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
                1: pw.FlexColumnWidth(4),
                2: pw.FlexColumnWidth(2)
              },
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                // 2: pw.Alignment.centerLeft
              },
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFB200'),
              ),
              rowDecoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    width: .5,
                  ),
                ),
              ),
              data: List<List<String>>.generate(widget.allRawAnswers!.length,
                  (index) {
                List<String> questionList = advancedSurveyQuestions![index];
                String questionType = questionList[questionList.length - 1];
                List<String>? answers = widget
                    .allRawAnswers![widget.allRawAnswers!.keys.toList()[index]];
                var noAnswerCount =
                    answers!.where((element) => element == '-1');

                bool noAnswer = answers.length == noAnswerCount.length;

                return noAnswer ? <String>[''] : <String>[
                  widget.allRawAnswers!.keys
                      .toList()[index]
                      .replaceAll('_0', '.'),
                  getQuestions(questionType, questionList),
                  getAnswers(questionType, answers, questionList,
                      widget.allRawAnswers!.keys.toList()[index])
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
            AppLocalizations.of(context).downloadResults,
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
