import 'package:flutter/material.dart';
import 'model.dart';
import 'dart:developer';

class QuestionCardWidget extends StatefulWidget {
  final String questionId;
  final String questionText;
  QuestionCardWidget({
    super.key,
    required this.questionId,
    required this.questionText,
  });

  @override
  State<QuestionCardWidget> createState() => _QuestionCardWidgetState();
}

class _QuestionCardWidgetState extends State<QuestionCardWidget> {
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
       return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.help_center_outlined),
              title: Text('Question dupa', style: Theme.of(context).textTheme.titleLarge ,),
              subtitle: Text('dupa', style: Theme.of(context).textTheme.bodyMedium,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'YES',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary),
                    onPressed: () {/* ... */},
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text('NO',
                        style: Theme.of(context).textTheme.titleLarge),
                    onPressed: () {/* ... */},
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );

    } else {
      print("Build");
      print(survey!.nodes.length);
       return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.help_center_outlined),
              title: Text('Question ${survey!.nodes[0].id}', style: Theme.of(context).textTheme.titleLarge ,),
              subtitle: Text('${survey!.nodes[0].questions[0]}', style: Theme.of(context).textTheme.bodyMedium,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'YES',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary),
                    onPressed: () {/* ... */},
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text('NO',
                        style: Theme.of(context).textTheme.titleLarge),
                    onPressed: () {/* ... */},
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
    }
  }
}
