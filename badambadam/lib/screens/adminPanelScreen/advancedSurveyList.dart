import 'dart:async';
import 'package:badambadam/screens/adminPanelScreen/advancedSurveyDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../model.dart';

class AdvancedSurveyList extends StatefulWidget {
  @override
  State<AdvancedSurveyList> createState() => _AdvancedSurveyListState();
}

class _AdvancedSurveyListState extends State<AdvancedSurveyList> {
  final Future<Map<String, dynamic>> _answers = getAdvancedSurveyRawAnswers();
  final Future<Map<String, dynamic>> _answersCalculated =
      getAdvancedSurveyAnswers();
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('questions');
  DatabaseReference referenceCalculatedPoints =
      FirebaseDatabase.instance.ref().child('advancedAnswers');

  @override
  Widget build(BuildContext context) {
  

    return FutureBuilder(
        future: _answers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> answersMap = snapshot.data;

            return ListView.builder(
                shrinkWrap: true,
                itemCount: answersMap.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  var surveyId = answersMap.keys.toList()[index];
                  var transformedId = surveyId
                      .replaceAll(".", "-")
                      .replaceAll(" ", "-")
                      .replaceAll(":", "-")
                      .replaceAll("_", "-")
                      .toString()
                      .split('-');

                  var currentId = transformedId[transformedId.length - 1];

                  return Card(
                      color: Theme.of(context).colorScheme.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black45, width: 0.75),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Numer badania: $currentId',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0,
                          ),
                        ),
                        subtitle: Text(
                            'Data wykonania badania: ${surveyId.replaceAll(r'-' + currentId, '')}'),
                        trailing: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Tooltip(
                                message: 'Zobacz szczegóły',
                                child: IconButton(
                                  icon: Icon(Icons.remove_red_eye_outlined),
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdvancedSurveyDetail(
                                                    surveyId: surveyId,
                                                    answers: answersMap.values
                                                        .toList()[index])));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                });
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
        });
  }
}
