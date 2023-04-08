import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../model.dart';

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
  // final Future<dynamic> _summaryAnswers = getAdvancedAnswers();

  String getYesNoAnswers(String currentAnswer) {
    String answer = '';
    if (currentAnswer == '-1') {
      answer = 'Brak odpowiedzi';
    } else {
      var currentAnswerSplit = currentAnswer.split('_');
      if (currentAnswerSplit[1] == 'YES') {
        answer = 'TAK';
      } else if (currentAnswerSplit[1] == 'NO') {
        answer = 'NIE';
      } else {
        answer = currentAnswerSplit[1];
      }
    }
    return answer;
  }

  Widget listWidget(
      {required Map question,
      required int index,
      required Map answers,
      required String surveyId}) {
    // var point = answers[int.parse(question['id']) - 1];
    if (answers.keys.contains(question['id'])) {
      var questionText = question['questions'];

      return Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black45, width: 0.75),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Text(
            '${question['id'].replaceAll('_0', '.')}',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${questionText[0]}',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          subtitle: questionText.length > 1
              ? Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: questionText.length - 1,
                          itemBuilder: (context, index) {
                            var currentAnswer = answers[question['id']][index];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(questionText[index + 1]),
                                Text(getYesNoAnswers(currentAnswer))
                              ],
                            );
                          }),
                    )
                  ],
                )
              : Text(answers[question['id']][0] == '-1'
                  ? 'Brak odpowiedzi'
                  : (answers[question['id']][0] == 'FAIL'
                      ? 'Niezaliczone'
                      : 'Zaliczone')),
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
