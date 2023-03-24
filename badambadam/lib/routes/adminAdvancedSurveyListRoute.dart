import 'package:flutter/material.dart';
import 'package:badambadam/screens/adminPanelScreen/advancedSurveyList.dart';

class AdminAdvancedSurveyListRoute extends StatelessWidget {
  const AdminAdvancedSurveyListRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => Navigator.pushNamed(context, '/admin'),
            child: Image.asset(
              'graphics/SYNAPSIS_herb_2.png',
              fit: BoxFit.cover,
              scale: 2,
            ),
          ),
        ),
        body: AdvancedSurveyList());
  }
}
