import 'package:flutter/material.dart';
import '../../model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleSurveyQuestion extends StatefulWidget {
  SingleSurveyQuestion({
    super.key,
    this.questionNode,
    required this.allAnswers,
  });

  final Node? questionNode;
  final ValueNotifier<Map<String, int>> allAnswers;

  @override
  State<SingleSurveyQuestion> createState() => _SingleSurveyQuestionState();
}

class _SingleSurveyQuestionState extends State<SingleSurveyQuestion>
    with AutomaticKeepAliveClientMixin {
  List<bool> selected = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var wholeQuestionText = widget.questionNode!.questions[0]
        .toString()
        .replaceAll('(', '\n')
        .replaceAll(')', '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black45, width: 0.75),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text('${AppLocalizations.of(context).question} ${widget.questionNode!.id}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                subtitle: Text(wholeQuestionText)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                            widget.allAnswers.value[widget.questionNode!.id] =
                                1;
                          } else {
                            widget.allAnswers.value[widget.questionNode!.id] =
                                0;
                          }
                        });
                      },
                      borderWidth: 1.5,
                      highlightColor: Theme.of(context).colorScheme.primary,
                      selectedBorderColor:
                          Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      children: <Widget>[
                         Text(
                          AppLocalizations.of(context).yes,
                          style: TextStyle(fontSize: 21),
                        ),
                        Text(
                          AppLocalizations.of(context).no,
                          style: TextStyle(fontSize: 21),
                        )
                      ]),
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
