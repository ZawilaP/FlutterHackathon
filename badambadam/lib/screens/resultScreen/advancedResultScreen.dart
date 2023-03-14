import 'package:badambadam/screens/resultScreen/advancedPdfReport.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvancedResultDisplayScreen extends StatefulWidget {
  const AdvancedResultDisplayScreen({super.key, this.score, this.allRawAnswers});

  final int? score;
  final Map<String, List<String>>? allRawAnswers;


  @override
  State<AdvancedResultDisplayScreen> createState() => _AdvancedResultDisplayScreenState();
}

class _AdvancedResultDisplayScreenState extends State<AdvancedResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];

    var currentGuid = getCurrentGuid()
        .toString()
        .replaceAll(".", "-")
        .replaceAll(" ", "-")
        .replaceAll(":", "-")
        .replaceAll("_", "-")
        .toString()
        .split('-');

    var currentGuidUserNumber = currentGuid[currentGuid.length - 1];

    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 8);

    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        ScoreDisplayContainer(
          score: widget.score,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Identyfikator Twojego badania wykonanego ",
                style: DefaultTextStyle.of(context).style),
            TextSpan(
                text:
                    "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()} ",
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold)),
            TextSpan(text: 'to: ', style: DefaultTextStyle.of(context).style),
            TextSpan(
                text: currentGuidUserNumber,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold))
          ])),
        ),
       AdvancedPDFSave(
          score: widget.score,
          allRawAnswers: widget.allRawAnswers,
        ),
      ],
    );
  }
}

class ScoreDisplayContainer extends StatelessWidget {

  const ScoreDisplayContainer({super.key, this.score});
  final int? score;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Wynik Twojego dziecka: '),
          ),
          SizedBox(
            height: 15,
          ),
          Text(score! >= 2 ? 'Dodatni' : 'Ujemny', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}