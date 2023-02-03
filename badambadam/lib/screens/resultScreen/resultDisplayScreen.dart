import 'package:badambadam/screens/resultScreen/pdfReport.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:badambadam/screens/resultScreen/result_texts_pl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:link_text/link_text.dart';

class ResultDisplayScreen extends StatefulWidget {
  const ResultDisplayScreen({this.score, this.allAnswers});

  final int? score;
  final List<int>? allAnswers;

  @override
  State<ResultDisplayScreen> createState() => _ResultDisplayScreenState();
}

class _ResultDisplayScreenState extends State<ResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];

    // setting texts based on child's score
    setState(() {
      if (widget.score! <= 2) {
        intro = noRiskIntro;
        paragraph = noRiskParagraph;
        actions = noRiskActions;
      } else if (widget.score! >= 3 && widget.score! <= 7) {
        intro = smallRiskIntro;
        paragraph = smallRiskParagraph;
        actions = smallRiskActions;
      } else {
        intro = bigRiskIntro;
        paragraph = bigRiskParagraph;
        actions = bigRiskActions;
      }
    });

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
          allAnswers: widget.allAnswers,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
              "Identyfikator Twojego badania wykonanego ${DateTime.now()}: ${getCurrentGuid().toString().replaceAll(".", "-").replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-")}"),
        ),
        PDFSave(score: widget.score,),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            intro,
            style: widget.score! >= 3
                ? TextStyle(fontWeight: FontWeight.bold)
                : TextStyle(),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(paragraph),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(actions[0]),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: actions.sublist(1, actions.length).map((e) {
              return ListTile(leading: Icon(Icons.check), title: LinkText(e),);
            }).toList()
          ),
        ),
        widget.score! >= 3
            ? ElevatedButton(
                style: style,
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/advancedSurvey');
                },
                child: const Text('Take Advanced Survey'),
              )
            : SizedBox(),
      ],
    );
  }
}

// Container for animated score display
class ScoreDisplayContainer extends StatelessWidget {
  ScoreDisplayContainer(
      {Key? key, required this.score, required this.allAnswers})
      : super(key: key);

  final int? score;
  final List<int>? allAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
          CircularPercentIndicator(
            radius: 100.0,
            animation: true,
            animationDuration: 1000,
            lineWidth: 15.0,
            percent: score! / allAnswers!.length,
            center: Text(
              "$score/${allAnswers!.length}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white,
            progressColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
