import 'package:flutter/material.dart';
import 'package:badambadam/screens/advancedSurveyScreen/advancedSurveyDisplayScreen.dart';

import '../storage.dart';

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
          //   '1': 0,
          //   '2': 0,
          //   '3': 0,
          //   '4': 1,
          //   '5': 0,
          //   '6': 1,
          //   '7': 0,
          //   '8': 1,
          //   '9': 1,
          //   '10': 1,
          //   '11': 0,
          //   '12': 0,
          //   '13': 1,
          //   '14': 0,
          //   '15': 1,
          //   '16': 1,
          //   '17': 0,
          //   '18': 0,
          //   '19': 1,
          //   '20': 1
          // }),
        ));
  }
}
