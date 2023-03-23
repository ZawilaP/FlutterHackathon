import 'package:flutter/material.dart';
import 'package:badambadam/screens/adminPanelScreen/basicSurveyList.dart';

class AdminBasicSurveyListRoute extends StatelessWidget {
  const AdminBasicSurveyListRoute({super.key});

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
        body: BasicSurveyList());
  }
}
