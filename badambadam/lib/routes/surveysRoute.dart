import 'package:flutter/material.dart';

import '../storage.dart';

class SurveysRoute extends StatelessWidget {
  const SurveysRoute({super.key});

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
          Text("If you got here from Admin Panel it needs to know about it and show all surveys and load them from db"),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
                "Twoje guid i odpowiedzi to: ${getCurrentAnswers().toString()}"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/result');
            },
            child: const Text('Survey result'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/advancedResult');
            },
            child: const Text('Advanced Survey result'),
          )
        ],
      ),
    );
  }
}