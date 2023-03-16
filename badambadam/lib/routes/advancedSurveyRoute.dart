import 'package:flutter/material.dart';
import 'package:badambadam/screens/advancedSurveyScreen/advancedSurveyDisplayScreen.dart';
import 'package:badambadam/storage.dart';

class AdvancedSurveyRoute extends StatelessWidget {
  const AdvancedSurveyRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => Navigator.pushNamed(context, '/'),
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
          //   '3': 0,
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
          //   '18': 1,
          //   '19': 0,
          //   '20': 0
          // }),
        ));
  }
}
