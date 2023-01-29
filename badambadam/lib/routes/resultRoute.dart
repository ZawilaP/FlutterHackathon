import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';

class ResultRoute extends StatelessWidget {
  const ResultRoute({super.key});

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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/advancedSurvey');
            },
            child: const Text('Take Advanced Survey'),
          ),
          Text("Your Survey GUIDs ${getGuidList().toString()}"),
          Text('Scored questions ${getAllAnswersList().toString()}'),
          Text('Final score ${getFinalScore().toString()}')
        ],
      ),
    );
  }
}