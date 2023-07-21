import 'package:flutter/material.dart';
import 'package:badambadam/screens/advancedSurveyScreen/advancedSurveyDisplayScreen.dart';
import 'package:badambadam/storage.dart';

class AdvancedSurveyRoute extends StatelessWidget {
  const AdvancedSurveyRoute({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog3() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Zmiany nie zostaną zapisane, czy chcesz kontynuować?'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Nie',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Tak',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context)..pop()..pop();
                  cleanDataString("autismSigns");
                  cleanDataString("skillsIssues");
                  cleanDataString("mobilityRehab");
                  cleanDataString("mobilityIssues");
                  cleanDataString("hearingIssues");
                  cleanDataString("visionIssues");
                  cleanDataString("healthIssues");
                  cleanDataString("geneticDiseases");
                  cleanDataString("gender");
                  cleanDataString("postalCode");
                  cleanDataString("familyAutismSigns");
                  cleanDataString("familyAtypicalAutismSigns");
                  cleanDataString("familyAspergerAutismSigns");
                  cleanDataString("familyDevelopmentIssues");
                  cleanDataString("familyOtherAutismSigns");
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showMyDialog4() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Zmiany nie zostaną zapisane, czy chcesz kontynuować?'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Nie',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Tak',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                  cleanDataString("autismSigns");
                  cleanDataString("skillsIssues");
                  cleanDataString("mobilityRehab");
                  cleanDataString("mobilityIssues");
                  cleanDataString("hearingIssues");
                  cleanDataString("visionIssues");
                  cleanDataString("healthIssues");
                  cleanDataString("geneticDiseases");
                  cleanDataString("gender");
                  cleanDataString("postalCode");
                  cleanDataString("familyAutismSigns");
                  cleanDataString("familyAtypicalAutismSigns");
                  cleanDataString("familyAspergerAutismSigns");
                  cleanDataString("familyDevelopmentIssues");
                  cleanDataString("familyOtherAutismSigns");
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => _showMyDialog3(),
          ),
          title: InkWell(
            onTap: () => _showMyDialog4(),
            child: Image.asset(
              'graphics/SYNAPSIS_herb_2.png',
              fit: BoxFit.cover,
              scale: 2,
            ),
          ),
        ),
        body: AdvancedSurveyDisplayScreen(
          allPrimaryAnswers: getAllAnswersMap().cast<String, int>(),
          // I leave this one for testing
          // allPrimaryAnswers: Map<String, int>.from({
          //   '1': 1,
          //   '2': 1,
          //   '3': 1,
          //   '4': 0,
          //   '5': 0,
          //   '6': 0,
          //   '7': 0,
          //   '8': 0,
          //   '9': 0,
          //   '10': 0,
          //   '11': 0,
          //   '12': 0,
          //   '13': 0,
          //   '14': 0,
          //   '15': 0,
          //   '16': 0,
          //   '17': 0,
          //   '18': 0,
          //   '19': 0,
          //   '20': 0
          // }),
        ));
  }
}
