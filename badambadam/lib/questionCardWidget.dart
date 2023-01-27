import 'package:flutter/material.dart';
import 'model.dart';

class QuestionCardWidget extends StatefulWidget {
  QuestionCardWidget({
    super.key,
  });

  @override
  State<QuestionCardWidget> createState() => _QuestionCardWidgetState();
}

class _QuestionCardWidgetState extends State<QuestionCardWidget> {
  Survey? survey;
  NodeAnswer? nodeAnswer;
  NodeStatus? nodeStatus = NodeStatus.unansweredYet;

  void showSurvey(Survey s) {
    setState(() {
      survey = s;
    });
  }

  void updateStatus() {
    nodeStatus = NodeStatus.answered;
  }

  void buttonClick(List<Node> topLevelSurvey, int index, NodeAnswer answer) {
    return setState(() {
      topLevelSurvey[index].status = NodeStatus.answered;
      topLevelSurvey[index].answer = NodeAnswer.yes;
      print(survey!.calculateResult());
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
      return SizedBox(
        height: 500,
        child: Center(
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: topLevelSurvey.length,
            itemBuilder: ((context, index) => Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Question ${topLevelSurvey[index].id}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          '${topLevelSurvey[index].questions[0]}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text('YES',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              onPressed: () {
                                buttonClick(
                                    topLevelSurvey, index, NodeAnswer.yes);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text('NO',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              onPressed: () {
                                buttonClick(
                                    topLevelSurvey, index, NodeAnswer.no);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
    }
  }
}
