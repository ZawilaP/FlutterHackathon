import 'package:flutter/material.dart';
import 'model.dart';
import 'singleQuestionWidget.dart';
import 'storage.dart';

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

      // used for storing answers. Initialized with -1.
      // for now hard-coded 20 questions because we don't have them all
      final ValueNotifier<List<int>> allAnswers =
          ValueNotifier<List<int>>(List<int>.generate(20, (i) => -1));

      // that's correct version, will be uncommented once we have all questions
      // final ValueNotifier<List<int>> allAnswers = ValueNotifier<List<int>>(
      //     List<int>.generate(topLevelSurvey.length, (i) => -1));

      final ButtonStyle style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8);

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
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
                        updateGuidList(
                            "${DateTime.now().toString().trim()}_test");
                        addAllAnswersList(allAnswers.value);
                        addFinalScore();
                        Navigator.pushNamed(context, '/result');
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
