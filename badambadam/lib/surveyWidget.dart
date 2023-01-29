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

  // used for storing scored questions (their ids)
  final ValueNotifier<Set> _scoredQuestionSet =
      ValueNotifier<Set>(<dynamic>{});

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
                  scoredQuestionNotifier: _scoredQuestionSet,
                );
              }),
            ),
          ),
          ElevatedButton(onPressed: () {
            addScoredQuestionsList(_scoredQuestionSet.value);
            Navigator.pushNamed(context, '/result');
          }, child: Text('Submit'))
        ],
      );
    }
  }
}
