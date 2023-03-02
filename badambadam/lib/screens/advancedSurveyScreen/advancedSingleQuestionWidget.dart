import 'package:flutter/material.dart';
import '../../model.dart';

class AdvancedSingleQuestion extends StatefulWidget {
  AdvancedSingleQuestion({
    super.key,
    this.questionNode,
    required this.allAnswers,
    required this.mainIndex,
  });

  final Node? questionNode;
  final ValueNotifier<Map<String, List<String>>> allAnswers;
  final int mainIndex;

  @override
  State<AdvancedSingleQuestion> createState() => _AdvancedSingleQuestionState();
}

class _AdvancedSingleQuestionState extends State<AdvancedSingleQuestion>
    with AutomaticKeepAliveClientMixin {
  List<bool> selected = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 5),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300, width: 2), borderRadius: BorderRadius.circular(15.0),),
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
                                widget.questionNode!.id] = 
                                {'FAIL'}.toList();
                          } else {
                            widget.allAnswers.value[
                                widget.questionNode!.id] = {'PASS'}.toList();
                          }
                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          widget.allAnswers.notifyListeners();
                          print(widget.allAnswers);
                        });
                      },
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(10),
                      highlightColor: Theme.of(context).colorScheme.primary,
                      selectedBorderColor: Theme.of(context).colorScheme.primary,
                      children: <Widget>[Text('YES', style: TextStyle(fontSize: 21),), Text('NO', style: TextStyle(fontSize: 21),)]),
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