import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:badambadam/screens/advancedSurveyScreen/advancedSurveyDisplayScreen.dart';

class AdvancedSurveyRoute extends StatelessWidget {
  const AdvancedSurveyRoute({super.key});

  final bool? _confirm = true;

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
      body: AdvancedSurveyDisplayScreen()
    );
  }
}


