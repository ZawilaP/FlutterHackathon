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
  final Future<Map<String, dynamic>> _answersCalculated =
      getAdvancedSurveyAnswers();
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
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
                  style: Theme.of(context).textTheme.titleLarge, maxLines: 10,),
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
                              var currentAnswer =
                                  answers[question['id']][index];

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
        ),
      );
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 8);

    Future<void> showCaluculatedResults(String surveyId) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(surveyId),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.7,
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic>? answersMap = snapshot.data;
                      Map<String, dynamic> currentMap = answersMap![surveyId];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Poniżej wyświetlono pytania, które pojawiły się w badaniu rozszerzonym na podstawie odpowiedzi udzielonych w badaniu podstawowym.'),
                            ),
                            Card(
                              child: ListTile(
                                leading: Text(
                                  'Numer pytania',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                trailing: Text('Punktacja',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child:
                                          Text(currentMap.keys.toList()[index]),
                                    ),
                                    trailing: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Text(currentMap.values
                                          .toList()[index]
                                          .toString()),
                                    ),
                                  ),
                                );
                              },
                              itemCount: currentMap.keys.length,
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  future: _answersCalculated,
                )),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surveyId),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showCaluculatedResults(widget.surveyId);
              },
              style: style,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11),
                child: Text(
                  'Wyświetl punktację',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FirebaseAnimatedList(
              shrinkWrap: true,
              defaultChild: Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
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
            )
          ],
        ),
      ),
    );
  }
}
