import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';

class SingleSelect extends StatefulWidget {
  const SingleSelect({
    Key? key,
    required this.allAdvancedAnswersDetails,
    required this.question,
    required this.inputIndex,
  }) : super(key: key);

  final Node question;
  final int inputIndex;
  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetails;

  @override
  State<SingleSelect> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect>
    with AutomaticKeepAliveClientMixin {
  bool chosen = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<String> questionWordsList = widget.question.questions
        .sublist(1, widget.question.questions.length)[widget.inputIndex]
        .toString()
        .split(' ');
    bool isFail =
        questionWordsList.length > 1 && questionWordsList[1] == '[F]';

    return SwitchListTile(
      activeColor: Theme.of(context).colorScheme.primary,
      title: Text(
        widget.question.questions
            .sublist(1, widget.question.questions.length)[widget.inputIndex]
            .toString(),
      ),
      value: chosen,
      onChanged: (bool value) {
        setState(() {
          chosen = value;
          widget.allAdvancedAnswersDetails
                  .value[widget.question.id]![widget.inputIndex] =
              chosen ? (isFail ? 'FAIL_YES' : 'PASS_YES') : 'NO_ANSWER';
          print(widget.allAdvancedAnswersDetails.value[widget.question.id]);
          print(widget.allAdvancedAnswersDetails.value);
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
