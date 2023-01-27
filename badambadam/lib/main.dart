import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'questionCardWidget.dart';
import 'model.dart';
import 'dart:developer';


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
        home: MyHomePage(),
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
          QuestionCardWidget(
            questionId: '1',
            questionText:
                'Does your child play pretend or make-believe?\nFOR EXAMPLE, pretend to drink from an empty cup, pretend to talk on a phone, or pretend to feed a doll or stuffed animal?',
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
