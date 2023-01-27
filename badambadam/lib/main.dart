import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'questionCardWidget.dart';
import 'model.dart';
import 'dart:developer';
import 'routes/ageCheck.dart';
import 'routes/surveyRoute.dart';
import 'routes/surveysRoute.dart';
import 'routes/resultRoute.dart';
import 'routes/advancedSurveyRoute.dart';
import 'routes/advancedResultRoute.dart';
import 'routes/adminPanelRoute.dart';
import 'routes/editQuestionsRoute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print("czytam survey z backendu");
    // Survey s = FakeBackendSingleton().getSurvey(null);
    // print("nodes count = ${s.nodes.length}");
    // s.nodes.forEach((element) {
    //   log(element.toString());
    // });
    // print("koniec");
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'M-CHAT-RF',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(255, 222, 0, 1)),
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/age': (context) => const AgeCheckRoute(),
          '/survey': (context) => const SurveyRoute(),
          '/surveys': (context) => const SurveysRoute(),
          '/advancedSurvey': (context) => const AdvancedSurveyRoute(),
          '/result': (context) => const ResultRoute(),
          '/advancedResult': (context) => const AdvancedResultRoute(),
          '/admin': (context) => const AdminPanelRoute(),
          '/questions': (context) => const EditQuestionsRoute(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

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
          QuestionCardWidget(),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/age');
            },
            child: const Text("Check age"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/surveys');
            },
            child: const Text("Past Surveys"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/admin');
            },
            child: const Text("Admin Panel (will be separate page later)"),
          )
        ],
      ),
    );
  }
}
