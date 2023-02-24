import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';

class RadioButtons extends StatefulWidget {
  const RadioButtons({
    Key? key,
    required this.allAdvancedAnswersDetails,
    required this.question,
    required this.inputIndex,
  }) : super(key: key);

  final Node question;
  final int inputIndex;
  final ValueNotifier<Map<String, List<String>>> allAdvancedAnswersDetails;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons>
    with AutomaticKeepAliveClientMixin {
  String? _point;
  bool _otherFlag = false;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    String nodeQuestions = widget.question.questions
        .sublist(1, widget.question.questions.length)[widget.inputIndex]
        .toString();

    List<String> questionWordsList = nodeQuestions.split(' ');

    final otherRegex = RegExp(r'(Other..)');
    bool hasOtherWord =
        questionWordsList.any((item) => otherRegex.hasMatch(item));

    bool isReversed =
        questionWordsList.length > 1 && questionWordsList[0] == '[F]';

    return Column(
      children: [
        ListTile(
            title: Text(nodeQuestions),
            trailing: Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: isReversed ? 'FAIL_YES' : 'PASS_YES',
                    activeColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.primary),
                    groupValue: _point,
                    onChanged: (String? value) {
                      setState(() {
                        _point = value;
                        _otherFlag = true;
                        widget.allAdvancedAnswersDetails.value[
                            widget.question.id]![widget.inputIndex] = _point!;
                        print(widget.allAdvancedAnswersDetails
                            .value[widget.question.id]);
                        print(widget.allAdvancedAnswersDetails.value);
                      });
                    },
                  ),
                  Text('YES'),
                  SizedBox(
                    width: 8,
                  ),
                  Radio<String>(
                    value: isReversed ? 'FAIL_NO' : 'PASS_NO',
                    groupValue: _point,
                    activeColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.primary),
                    onChanged: (String? value) {
                      setState(() {
                        _point = value;
                        _otherFlag = false;
                        myController.clear();
                        widget.allAdvancedAnswersDetails.value[
                            widget.question.id]![widget.inputIndex] = _point!;
                        print(widget.allAdvancedAnswersDetails
                            .value[widget.question.id]);
                        print(widget.allAdvancedAnswersDetails.value);
                      });
                    },
                  ),
                  Text('NO')
                ],
              ),
            )),
        (_otherFlag && hasOtherWord)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe other behaviours'),
                  onChanged: (text) {
                    widget.allAdvancedAnswersDetails
                            .value[widget.question.id]![widget.inputIndex] =
                        "OPEN_${myController.text}";
                    print(widget.allAdvancedAnswersDetails.toString());
                  },
                ),
              )
            : SizedBox(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
