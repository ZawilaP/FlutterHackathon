import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../model.dart';

class AdminPanelRoute extends StatefulWidget {
  @override
  _AdminPanelRoute createState() => _AdminPanelRoute();
}

class _AdminPanelRoute extends State<AdminPanelRoute> {
  _AdminPanelRoute() {
    // Register for login changes upon LoginFormValidation instance creation.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/');
      }
    });
  }

  final Future<Map<String, dynamic>> _answers = getSurveyAnswers();

  @override
  Widget build(BuildContext context) {
    createAdvancedSurveysBuild() {
      return FutureBuilder(
          future: getAdvancedSurveyAnswers(),
          initialData: "Loading advanced surveys..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.data
                      .toString()
                      .replaceAll("],", "],\n")
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    createAdvancedRawSurveysBuild() {
      return FutureBuilder(
          future: getAdvancedSurveyRawAnswers(),
          initialData: "Loading advanced surveys..",
          builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.data
                      .toString()
                      .replaceAll("],", "],\n")
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ));
          });
    }

    Future<void> showAdvancedSurveys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All advanced surveys:'),
            content: SingleChildScrollView(child: createAdvancedSurveysBuild()),
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

    Future<void> showAdvancedRawSurveys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All advanced raw surveys:'),
            content:
                SingleChildScrollView(child: createAdvancedRawSurveysBuild()),
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

    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        backgroundColor: Colors.white,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 1);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'graphics/SYNAPSIS_herb_2.png',
          fit: BoxFit.cover,
          scale: 2,
        ),
      ),
      body: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          OutlinedButton(
            style: style,
            child: const Text(
              "Edytuj pytania",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/questions');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Przeglądaj ankiety podstawowe",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/adminBasicSurvey');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Przeglądaj ankiety rozszerzone",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/adminAdvancedSurvey');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Dodaj nowego admina",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/newAdmin');
            },
          ),
          OutlinedButton(
            style: style,
            child: const Text(
              "Wyloguj się",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}

dynamic getAnswers() async {
  return await getSurveyAnswers().then((id) => [id]);
}

dynamic getAdvancedAnswers() async {
  return await getAdvancedSurveyAnswers().then((id) => [id]);
}

dynamic getAdvancedRawAnswers() async {
  return await getAdvancedSurveyRawAnswers().then((id) => [id]);
}
