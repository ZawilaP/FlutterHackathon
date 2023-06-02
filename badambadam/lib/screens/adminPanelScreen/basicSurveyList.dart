import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../model.dart';

class BasicSurveyList extends StatefulWidget {
  @override
  State<BasicSurveyList> createState() => _BasicSurveyListState();
}

class _BasicSurveyListState extends State<BasicSurveyList> {
  final Future<Map<String, dynamic>> _answers = getSurveyAnswers();
  Query dbRef = FirebaseDatabase.instance.ref().child('questions');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('questions');
  String _searchQuery = '';
  Map<String, dynamic> filteredMap = {};
  Map<String, dynamic> answersMap = {};

  Widget listWidget(
      {required Map question,
      required int index,
      required List answers,
      required String surveyId}) {
    var questionText = question['questions'][0].toString();

    if (question['is_top_level'] == 'YES') {
      var point = answers[int.parse(question['id']) - 1];
      return Card(
        child: ListTile(
          leading: Text(question['id']),
          title: Text(questionText),
          trailing: Text(
            '${point == 1 ? (question['is_inverted'] == "YES" ? "TAK" : "NIE") : (question['is_inverted'] == "YES" ? "NIE" : "TAK")} (${point.toString()})',
            style: TextStyle(
                color: point > 0
                    ? Colors.red[300]
                    : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String surveyId, List<dynamic> answers) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(surveyId),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.7,
              child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map question = snapshot.value as Map;
                  question['key'] = snapshot.key;

                  return listWidget(
                      question: question,
                      index: index,
                      answers: answers,
                      surveyId: surveyId);
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Zamknij',
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

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
              // create a new map by iterating over the old map and checking if the value is in the key
              filteredMap = {};
              for (var entry in answersMap.entries) {
                if (entry.key.toLowerCase().contains(_searchQuery)) {
                  filteredMap[entry.key] = entry.value;
                }
              }
            });
          },
          decoration: InputDecoration(
            labelText: "Identyfikator badania",
            hintText: "Wpisz identyfikator badania",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
      Expanded(
          child: FutureBuilder(
              future: _answers,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  answersMap = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredMap.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                      var surveyId = filteredMap.keys.toList()[index];
                      var transformedId = surveyId
                          .replaceAll(".", "-")
                          .replaceAll(" ", "-")
                          .replaceAll(":", "-")
                          .replaceAll("_", "-")
                          .toString()
                          .split('-');

                      var currentId = transformedId[transformedId.length - 1];

                      return currentId == 'test'
                          ? SizedBox()
                          : Card(
                              color: Theme.of(context).colorScheme.background,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black45, width: 0.75),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  _showMyDialog(
                                      filteredMap.keys.toList()[index],
                                      filteredMap.values.toList()[index]);
                                },
                                title: Text(
                                  'Numer badania: $currentId',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.0,
                                  ),
                                ),
                                subtitle: Text(
                                    'Data wykonania badania: ${surveyId.replaceAll(r'-' + currentId, '')}'),
                                trailing: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Wystąpił błąd. Przepraszamy!'));
                }

                return Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              }))
    ]);
  }
}
