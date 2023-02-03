import 'package:badambadam/screens/resultScreen/pdfReport.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:badambadam/screens/resultScreen/result_texts_pl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:link_text/link_text.dart';

class AdvancedResultDisplayScreen extends StatefulWidget {
  const AdvancedResultDisplayScreen();


  @override
  State<AdvancedResultDisplayScreen> createState() => _AdvancedResultDisplayScreenState();
}

class _AdvancedResultDisplayScreenState extends State<AdvancedResultDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    String intro = " ";
    String paragraph = " ";
    List<String> actions = [];


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
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
              "Identyfikator Twojego badania wykonanego ${DateTime.now()}: ${getCurrentGuid().toString().replaceAll(".", "-").replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-")}"),
        ),
       
      ],
    );
  }
}

// Container for animated score display
class ScoreDisplayContainer extends StatelessWidget {


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
            percent: 5 / 20,
            center: Text(
              "5/20",
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