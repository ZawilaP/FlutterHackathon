import 'package:flutter/material.dart';
import 'package:badambadam/screens/advancedSurveyScreen/radioResponseWidget.dart';

class AdvancedSurveyDisplayScreen extends StatelessWidget {
  
  final List<String> questionsArr = [
    "Play with another child?",
    "Talk to another child?",
    "Babble or make vocal noises?",
    "Watch another child?",
    "Smile at another child?",
    "Act shy at first but then smile?",
    "Get excited about another child?",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/advancedResult');
              },
              child: const Text('Advanced Survey result'),
            ),
            Text('Does your child'),
          ],
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.6,
            child: ListView.builder(
                itemCount: questionsArr.length,
                itemBuilder: ((context, index) {
                  return RadioButtons(question: questionsArr[index]);
                })))
      ],
    );
  }
}
