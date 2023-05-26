import 'package:flutter/material.dart';

import '../../model.dart';
import '../../storage.dart';
import 'package:quantity_input/quantity_input.dart';

class QuantityInputQuestion extends StatefulWidget {
  QuantityInputQuestion(
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
  State<QuantityInputQuestion> createState() => _QuantityInputQuestionState();
}

class _QuantityInputQuestionState extends State<QuantityInputQuestion> {

  int pregnancyWeek = 42;

  @override
  void initState() {
    super.initState();
    setMetricDataString(widget.localParamName, pregnancyWeek.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                QuantityInput(
                  value: pregnancyWeek,
                  minValue: 16,
                  maxValue: 42,
                  onChanged: (value) {
                    setState(() {
                      pregnancyWeek = int.parse(value.replaceAll(',', ''));
                      setMetricDataString(widget.localParamName, pregnancyWeek.toString());
                    });
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
