import 'package:flutter/material.dart';
import 'questionCardWidget.dart';

class MyHomePage extends StatelessWidget {
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
          QuestionCardWidget(
            questionId: '1',
            questionText:
                'If you point at something across the room, does your child look at it?',
          ),
          QuestionCardWidget(
              questionId: '2',
              questionText:
                  'Have you ever wondered if your child might be deaf?')
        ],
      ),
    );
  }
}