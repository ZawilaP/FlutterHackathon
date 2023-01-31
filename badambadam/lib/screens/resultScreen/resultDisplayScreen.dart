import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:badambadam/screens/resultScreen/result_texts_pl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultDisplayScreen extends StatefulWidget {
  const ResultDisplayScreen({this.score});

  final int? score;

  @override
  State<ResultDisplayScreen> createState() => _ResultDisplayScreenState();
}

class _ResultDisplayScreenState extends State<ResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];

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
        ScoreDisplayContainer(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              "Identyfikator Twojego badania wykonanego ${DateTime.now()}: ${getGuidList().toString()}"),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            intro,
            style: widget.score! >= 3
                ? TextStyle(fontWeight: FontWeight.bold)
                : TextStyle(),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(paragraph),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(actions[0]),
        ),
        // TODO: displaying this shit
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(actions.toString()),
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

class ScoreDisplayContainer extends StatelessWidget {
  const ScoreDisplayContainer({
    Key? key,
  }) : super(key: key);

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
            // percent: 1 / 3, // comment lines below and uncomment percent and center if you don't want to be bothered by state
            percent: int.parse(getFinalScore().toString()) /
                getAllAnswersList().length,
            center: Text(
              "${getFinalScore().toString()}/${getAllAnswersList().length}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
            ),
            // center: Text('1/3'),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white,
            progressColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
