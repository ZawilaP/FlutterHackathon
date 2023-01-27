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
  // Survey s = FakeBackendSingleton().getSurvey(null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.help_center_outlined),
              // title: Text('Question ${s.nodes[0].id}', style: Theme.of(context).textTheme.titleLarge ,),
              // subtitle: Text('${s.nodes[0].questions[0]}', style: Theme.of(context).textTheme.bodyMedium,),
              title: Text(widget.questionId,
                  style: Theme.of(context).textTheme.titleLarge.apply(color: Colors.yellow)),
              subtitle: Text(widget.questionText,
                  style: Theme.of(context).textTheme.bodyMedium),
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
