import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdvancedSurveyDetail extends StatefulWidget {
  final String surveyId;
  final Map answers;

  const AdvancedSurveyDetail(
      {super.key, required this.surveyId, required this.answers});

  @override
  State<AdvancedSurveyDetail> createState() => _AdvancedSurveyDetailState();
}

class _AdvancedSurveyDetailState extends State<AdvancedSurveyDetail> {
  Query dbRef = FirebaseDatabase.instance.ref().child('questions');
  Widget listWidget(
      {required Map question,
      required int index,
      required Map answers,
      required String surveyId}) {
    // var point = answers[int.parse(question['id']) - 1];
    if (answers.keys.contains(question['id'])) {
      var questionText = question['questions'].toString();
      return Card(
        child: ListTile(
          leading: Text(question['id']),
          title: Text(questionText),
          subtitle: Text(answers[question['id']].toString()),
        ),
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surveyId),
      ),
      body: FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map question = snapshot.value as Map;
          question['key'] = snapshot.key;
          return listWidget(
              question: question,
              index: index,
              answers: widget.answers,
              surveyId: widget.surveyId);
        },
      ),
    );
  }
}
