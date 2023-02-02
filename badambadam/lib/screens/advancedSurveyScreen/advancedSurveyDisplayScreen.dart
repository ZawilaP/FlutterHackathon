import 'package:flutter/material.dart';
import '../../model.dart';
import '../basicSurveyScreen/singleQuestionWidget.dart';
import '../../storage.dart';
import 'radioResponseWidget.dart';

class AdvancedSurveyDisplayScreen extends StatefulWidget {
  AdvancedSurveyDisplayScreen({
    super.key,
  });

  @override
  State<AdvancedSurveyDisplayScreen> createState() =>
      _AdvancedSurveyDisplayScreenState();
}

class _AdvancedSurveyDisplayScreenState
    extends State<AdvancedSurveyDisplayScreen> {
  Survey? survey;

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (survey == null) {
      // if not there - then load one
      FakeBackendSingleton().getSurvey(null).then(showSurvey);
      return Center(child: Text('Loading...'));
    } else {
      List<Node> allNodes = survey!.nodes;

      // used for storing answers. Initialized with -1 for no answer.
      final ValueNotifier<List<int>> allAdvancedAnswers =
          ValueNotifier<List<int>>(
              List<int>.generate(allNodes.length, (i) => -1));

      final ButtonStyle style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);

      Future<void> _showMyDialog() async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Please check yes or no for every question'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Keep in mind how your child usually behaves.'),
                    Text(
                      'If you have seen your child do the behavior a few times, but he or she does not usually do it, then please answer no.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              Node questionNode = allNodes[index];
              if (allNodes[index].nodeType == 'Simple_Yes_No') {
                return SingleSurveyQuestion(
                  questionNode: questionNode,
                  allAnswers: allAdvancedAnswers,
                );
              } else if (questionNode.nodeType == 'OneYesWillDoStopAsking' ||
                  questionNode.nodeType == 'YesNoBranching') {
                return Column(
                  children: [
                    Text(questionNode.id),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView.builder(
                            itemCount: questionNode.questions.length,
                            itemBuilder: ((context, inputIndex) {
                              return RadioButtons(
                                  question: questionNode.questions[inputIndex]
                                      .toString());
                            }))),
                  ],
                );
              } else if (questionNode.nodeType == 'OpenTextAnyAnswerWillDo') {
                return TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '${questionNode.id} + ${questionNode.questions[0].toString()}',
                  ),
                );
              }
              return Text('dupa');
            }, childCount: allNodes.length)),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                      style: style,
                      onPressed: () {
                        if (allAdvancedAnswers.value.contains(-1)) {
                          _showMyDialog();
                        } else {
                          updateGuidList(
                              "${DateTime.now().toString().trim()}_test");
                          addAllAnswersList(allAdvancedAnswers.value);
                          addFinalScore();
                          Navigator.pushNamed(context, '/result');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 11),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      );
    }
  }
}
