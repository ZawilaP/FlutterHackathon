import 'package:flutter/material.dart';

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