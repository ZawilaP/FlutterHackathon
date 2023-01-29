import 'package:flutter/material.dart';
import 'model.dart';
import 'package:get_storage/get_storage.dart';

class SingleSurveyQuestion extends StatefulWidget {
  SingleSurveyQuestion({
    super.key,
    this.questionNode,
    required this.scoredQuestionNotifier,
  });

  final Node? questionNode;
  final ValueNotifier<Set> scoredQuestionNotifier;

  @override
  State<SingleSurveyQuestion> createState() => _SingleSurveyQuestionState();
}

class _SingleSurveyQuestionState extends State<SingleSurveyQuestion> {
  List<bool> selected = <bool>[false, false];
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              'Question ${widget.questionNode!.id}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              '${widget.questionNode!.questions[0]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleButtons(
                  isSelected: selected,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < selected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          selected[buttonIndex] = true;
                        } else {
                          selected[buttonIndex] = false;
                        }
                      }

                      // I know it's super shitty but works well
                      if ((widget.questionNode!.isInverted && index == 0) ||
                          (!widget.questionNode!.isInverted && index == 1)) {
                        widget.scoredQuestionNotifier.value
                            .add(widget.questionNode!.id);
                      } else {
                        widget.scoredQuestionNotifier.value
                            .remove(widget.questionNode!.id);
                      }

                      print(widget.scoredQuestionNotifier.value);
                    });
                  },
                  borderColor: Colors.transparent,
                  children: const <Widget>[Text('YES'), Text('NO')]),
            ],
          )
        ],
      ),
    );
  }
}
