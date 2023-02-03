import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';

class SurveysRoute extends StatefulWidget {
  @override
  State<SurveysRoute> createState() => _SurveysRoute();
}

class _SurveysRoute extends State<SurveysRoute> {
  @override
  Widget build(BuildContext context) {
   createFutureBuild() {
     return FutureBuilder(
         future: getSurveyAnswers(),
         initialData: "Loading text..",
         builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
           return new SingleChildScrollView(
               padding: new EdgeInsets.all(8.0),
               child: new Text(
                 text.data.toString(),
                 style: new TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 19.0,
                 ),
               ));
         });
   }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All surveys:'),
            content: SingleChildScrollView(
              child: createFutureBuild()
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
          ElevatedButton(
            child: Text("Show all past surveys"),
            onPressed: () async {
              print(await getAnswers());
              _showMyDialog();
            },
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

dynamic getAnswers() async {
  return await getSurveyAnswers().then((id) => [id]);
}