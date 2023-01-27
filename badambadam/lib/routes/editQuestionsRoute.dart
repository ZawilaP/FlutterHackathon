import 'package:flutter/material.dart';

class EditQuestionsRoute extends StatelessWidget {
  const EditQuestionsRoute({super.key});

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
          Text("Do editing here somehow")
        ],
      ),
    );
  }
}