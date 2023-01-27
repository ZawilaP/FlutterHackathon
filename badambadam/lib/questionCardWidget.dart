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

      print("Build");
      print(survey!.nodes.length);
      return SizedBox(
        height: 400,
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
                        // leading: Icon(Icons.help_center_outlined),
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
                                print(topLevelSurvey[index].answer);
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
                                print(topLevelSurvey[index].answer);
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
