import 'package:flutter/material.dart';

class QuestionCardWidget extends StatelessWidget {
  final String questionId;
  final String questionText;
  QuestionCardWidget({
    super.key,
    required this.questionId,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.help_center_outlined),
              title: Text('Question $questionId', style: Theme.of(context).textTheme.titleLarge ,),
              subtitle: Text(questionText, style: Theme.of(context).textTheme.bodyMedium,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child:  Text('YES',),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('NO'),
                  onPressed: () {/* ... */},
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
