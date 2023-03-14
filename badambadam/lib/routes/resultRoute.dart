import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import 'package:badambadam/screens/resultScreen/basicResultScreen.dart';

class ResultRoute extends StatelessWidget {
  const ResultRoute({super.key});

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
      body: ResultDisplayScreen(
        score: getFinalScore(), 
        allAnswers: getAllAnswersMap().cast<String, int>(),
      ),
    );
  }
}