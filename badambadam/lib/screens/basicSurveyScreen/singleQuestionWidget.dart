import 'package:flutter/material.dart';
import '../../model.dart';

class SingleSurveyQuestion extends StatefulWidget {
  SingleSurveyQuestion({
    super.key,
    this.questionNode,
    required this.allAnswers,
  });

  final Node? questionNode;
  final ValueNotifier<List<int>> allAnswers;

  @override
  State<SingleSurveyQuestion> createState() => _SingleSurveyQuestionState();
}

class _SingleSurveyQuestionState extends State<SingleSurveyQuestion>
    with AutomaticKeepAliveClientMixin {
  List<bool> selected = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Card(
        color: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
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

                          // I know it's a bit shitty but works well.
                          if ((widget.questionNode!.isInverted && index == 0) ||
                              (!widget.questionNode!.isInverted &&
                                  index == 1)) {
                            widget.allAnswers.value[
                                int.parse(widget.questionNode!.id) - 1] = 1;
                          } else {
                            widget.allAnswers.value[
                                int.parse(widget.questionNode!.id) - 1] = 0;
                          }

                          print(widget.allAnswers);
                        });
                      },
                      borderColor: Colors.transparent,
                      highlightColor: Theme.of(context).colorScheme.primary,
                      selectedBorderColor: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      children: <Widget>[Text('YES'), Text('NO')]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
