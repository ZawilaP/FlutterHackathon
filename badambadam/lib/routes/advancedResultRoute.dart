import 'package:badambadam/screens/resultScreen/advancedResultScreen.dart';
import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';

class AdvancedResultRoute extends StatelessWidget {
  const AdvancedResultRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'graphics/SYNAPSIS_herb_2.png',
            fit: BoxFit.cover,
            scale: 2,
          ),
        ),
        body: AdvancedResultDisplayScreen(
          allRawAnswers: getAllAdvancedRawAnswersMap(),
          score: getFinalAdvancedScore(),
        ));
  }
}
