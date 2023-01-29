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
      return Center(child: Text('loading'));
    } else {
      List<Node> topLevelSurvey = survey!.getTopLevelNodesOnly();

      // used for storing answers. Initialized with -1.
      final ValueNotifier<List<int>> allAnswers = ValueNotifier<List<int>>(
          List<int>.generate(topLevelSurvey.length, (i) => -1));

      return Column(
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: topLevelSurvey.length,
              itemBuilder: ((context, index) {
                return SingleSurveyQuestion(
                  questionNode: topLevelSurvey[index],
                  allAnswers: allAnswers,
                );
              }),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                addAllAnswersList(allAnswers.value);
                addFinalScore();
                Navigator.pushNamed(context, '/result');
              },
              child: Text('Submit'))
        ],
      );
    }
  }
}
