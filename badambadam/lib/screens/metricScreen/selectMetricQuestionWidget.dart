import 'package:flutter/material.dart';

import '../../model.dart';

List<String> list = <String>[
  'Ojciec',
  'Matka',
  'Dziadek',
  'Babcia',
  'Inna osoba z rodziny',
  'Opiekun prawny',
  'Inna osoba'
];

class SelectMetricQuestion extends StatefulWidget {
  SelectMetricQuestion(
      {super.key,
      this.questionNode,
      required this.questionId,
      required this.questionText,
      required this.localParamName
      });

  final Node? questionNode;
  final String questionId;
  final String questionText;
  final String localParamName;

  @override
  State<SelectMetricQuestion> createState() => _SelectMetricQuestionState();
}

class _SelectMetricQuestionState extends State<SelectMetricQuestion> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    print(dropdownValue);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text('Pytanie ${widget.questionId}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                subtitle: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(widget.questionText),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.primary),
                  elevation: 16,
                  // style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
