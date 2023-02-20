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

class _RadioButtonsState extends State<RadioButtons> with AutomaticKeepAliveClientMixin {
  String? _point;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<String> questionWordsList = widget.question.questions
        .sublist(1, widget.question.questions.length)[widget.inputIndex]
        .toString()
        .split(' ');
    bool isReversed = questionWordsList.length > 1 && questionWordsList[1] == '[F]'; 

    return ListTile(
        title: Text(
          widget.question.questions
              .sublist(1, widget.question.questions.length)[widget.inputIndex]
              .toString(),
        ),
        trailing: Container(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<String>(
                value: isReversed ? 'FAIL' : 'PASS',
                activeColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).colorScheme.primary),
                groupValue: _point,
                onChanged: (String? value) {
                  setState(() {
                    _point = value;
                    widget.allAdvancedAnswersDetails
                            .value[widget.question.id]![widget.inputIndex] = _point!;
                    print(widget
                        .allAdvancedAnswersDetails.value[widget.question.id]);
                    print(widget.allAdvancedAnswersDetails.value);
                  });
                },
              ),
              Text('YES'),
              SizedBox(
                width: 8,
              ),
              Radio<String>(
                value: isReversed ? 'PASS' : 'FAIL',
                groupValue: _point,
                activeColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).colorScheme.primary),
                onChanged: (String? value) {
                  setState(() {
                    _point = value;
                    widget.allAdvancedAnswersDetails
                            .value[widget.question.id]![widget.inputIndex] = _point!;
                    print(widget
                        .allAdvancedAnswersDetails.value[widget.question.id]);
                    print(widget.allAdvancedAnswersDetails.value);
                  });
                },
              ),
              Text('NO')
            ],
          ),
        ));
  }
  
  @override
  bool get wantKeepAlive => true;
}
