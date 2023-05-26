import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import '../screens/basicSurveyScreen/basicSurveyDisplayScreen.dart';

class SurveyRoute extends StatelessWidget {
  const SurveyRoute({super.key});


  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Zmiany nie zostaną zapisane, czy chcesz kontynuować?'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Nie',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Tak',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  cleanMetricData();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => _showMyDialog2(),
        ),
        title: InkWell(
            onTap: () => _showMyDialog2(),
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
