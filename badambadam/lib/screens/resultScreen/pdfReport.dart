import 'dart:html';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class PDFSave extends StatefulWidget {
  const PDFSave({super.key, this.score});

  final int? score;

  @override
  _PDFSaveState createState() => _PDFSaveState();
}

class _PDFSaveState extends State<PDFSave> {
  final pdf = pw.Document();

  var anchor;

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
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('M-Chat-R Survey Results',
                style: pw.TextStyle(fontSize: 28)),
            pw.Text('Your child score is: ${widget.score}/20',
                style: pw.TextStyle(fontSize: 25)),
            pw.Table.fromTextArray(
              context: context,
              data: const <List<String>>[
                <String>['Question', 'Answer'],
                <String>[
                  'If you point at something across the room, does ___ look at it?',
                  "YES"
                ],
                <String>[
                  'You reported that you have wondered if you child is deaf. What led you to wonder that?',
                  "YES"
                ],
                <String>['Does ___ play pretend or make-believe?', "NO"],
                <String>['Does ___ like climbing on things ?', "NO"],
                <String>[
                  'Does ___ make unusual finger movements near his/her eyes?',
                  "YES"
                ],
                <String>[
                  'Does ___ point with one finger to ask for something or to get help?',
                  "YES"
                ],
                <String>[
                  'Is _____ interested in other children?',
                  "NO"
                ],
                <String>[
                  'Does _____ show you things by bringing them to you or holding them up for you to see?',
                  "YES"
                ],
                <String>[
                  'Does __ respond when you call his/her name?',
                  "NO"
                ],
                <String>[
                  'When you smile at___ does he /she smile back at you?',
                  "YES"
                ],
                <String>[
                  'Does __ get upset by everyday noises?',
                  "YES"
                ],
                <String>[
                  'Does he/she walk?',
                  "NO"
                ],
                <String>[
                  'If you point at something across the room, does ___ look at it?',
                  "YES"
                ],
                <String>[
                  'Does he/she try to copy what you do?',
                  "NO"
                ],
                <String>[
                  'Does ___ make unusual finger movements near his/her eyes?',
                  "YES"
                ],
                <String>[
                  'Does ___ point with one finger to ask for something or to get help?',
                  "YES"
                ],
                <String>[
                  'Does ___ point with one finger just to show you something interesting?',
                  "NO"
                ],
                <String>[
                  'If you point at something across the room, does ___ look at it?',
                  "YES"
                ],
                <String>[
                  'If you point at something across the room, does ___ look at it?',
                  "NO"
                ],
              ],
            ),
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
