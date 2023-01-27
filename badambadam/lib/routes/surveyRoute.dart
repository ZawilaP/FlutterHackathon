import 'package:flutter/material.dart';
import '../questionCardWidget.dart';

class SurveyRoute extends StatelessWidget {
  const SurveyRoute({super.key});

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
          QuestionCardWidget(),
          // ElevatedButton(
          //   onPressed: () {
          //     // Navigate to the second screen using a named route.
          //     Navigator.pushNamed(context, '/result');
          //   },
          //   child: const Text('Survey result'),
          // )
        ],
      ),
    );
  }
}