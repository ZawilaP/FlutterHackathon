import 'dart:html';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
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
          children: [
            pw.Text('M-Chat-R Survey Results',
                style: pw.TextStyle(fontSize: 25)),
            pw.Text("Your child's score is: ${widget.score}/20",
                style: pw.TextStyle(fontSize: 25)),
                pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: <String>['Question', 'Score'],
                data: List<List<String>>.generate(
                    topLevelSurvey!.length,
                    (index) => <String>[
                          topLevelSurvey![index],
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
