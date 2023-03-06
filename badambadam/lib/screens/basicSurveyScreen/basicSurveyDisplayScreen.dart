import 'package:flutter/material.dart';
import '../../model.dart';
import 'singleQuestionWidget.dart';
import '../../storage.dart';

class SurveyWidget extends StatefulWidget {
  SurveyWidget({
    super.key,
  });

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
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
      List<Node> topLevelSurvey = survey!.getTopLevelNodesOnly();
      List<String> topLevelQuestions = [];

      // used for storing answers. Initialized with -1 for no answer.
      final ValueNotifier<Map<String, int>> allAnswers = ValueNotifier<Map<String, int>>({
        for (var item in topLevelSurvey)
          item.id: -1 
      });

      final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              topLevelQuestions
                  .add('${topLevelSurvey[index].id}. ${topLevelSurvey[index].questions[0]}+${topLevelSurvey[index].isInverted}');
              return SingleSurveyQuestion(
                questionNode: topLevelSurvey[index],
                allAnswers: allAnswers,
              );
            }, childCount: topLevelSurvey.length)),
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
                        if (allAnswers.value.values.contains(-1)) {
                          _showMyDialog();
                        } else {
                          updateGuidList(
                              DateTime.now().toString().trim());
                          addAllTopLevelNodes(topLevelQuestions);
                          addAllAnswersMap(allAnswers.value);
                          writeCurrentAnswers();
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
