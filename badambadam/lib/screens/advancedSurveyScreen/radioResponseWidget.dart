import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final otherRegexPL = RegExp(r'(Inne..)');
    bool hasOtherWord =
        questionWordsList.any((item) => otherRegex.hasMatch(item));
    bool hasOtherWordPL = questionWordsList.any((item) => otherRegexPL.hasMatch(item));

    bool isReversed =
        questionWordsList.length > 1 && questionWordsList[0] == '[F]';

    void updateAnswers(String questionId, int inputIndex, String? pointValue) {
      widget.allAdvancedAnswersDetails
          .value[questionId]![inputIndex] = pointValue!;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      widget.allAdvancedAnswersDetails.notifyListeners();
    }

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
                        updateAnswers(widget.question.id, widget.inputIndex, _point);
                        print(widget.allAdvancedAnswersDetails
                            .value[widget.question.id]);
                        print(widget.allAdvancedAnswersDetails.value);
                      });
                    },
                  ),
                  Text(AppLocalizations.of(context).yes),
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
                        updateAnswers(widget.question.id, widget.inputIndex, _point);
                        print(widget.allAdvancedAnswersDetails
                            .value[widget.question.id]);
                        print(widget.allAdvancedAnswersDetails.value);
                      });
                    },
                  ),
                  Text(AppLocalizations.of(context).no)
                ],
              ),
            )),
        (_otherFlag && (hasOtherWord || hasOtherWordPL))
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: hasOtherWord ? 'Describe other behaviours' : "Proszę opisać inne zachowania"),
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
