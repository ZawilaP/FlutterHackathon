import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import '../screens/basicSurveyScreen/basicSurveyDisplayScreen.dart';

class SurveyRoute extends StatelessWidget {
  const SurveyRoute({super.key});


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
      body: SurveyWidget(),
    );
  }
}
