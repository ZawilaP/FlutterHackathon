import 'package:badambadam/storage.dart';
import 'package:flutter/material.dart';
import '../../model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BinaryMetricQuestion extends StatefulWidget {
  BinaryMetricQuestion({
    super.key,
    this.questionNode,
    required this.questionId,
    required this.questionText,
    required this.firstOption,
    required this.secondOption,
    required this.localParamName
  });

  final Node? questionNode;
  final String questionId;
  final String questionText;
  final String firstOption;
  final String secondOption;
  final String localParamName;

  @override
  State<BinaryMetricQuestion> createState() => _BinaryMetricQuestionState();
}

class _BinaryMetricQuestionState extends State<BinaryMetricQuestion>
    with AutomaticKeepAliveClientMixin {
  List<bool> selected = <bool>[false, false];

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text('${AppLocalizations.of(context).question} ${widget.questionId}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                subtitle: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(widget.questionText),
                )),
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
                          if (index == 0) {
                            setMetricDataString(widget.localParamName, widget.firstOption);
                          }
                          if (index == 1) {
                            setMetricDataString(widget.localParamName, widget.secondOption);
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
                          widget.firstOption,
                          style: TextStyle(fontSize: 21),
                        ),
                        Text(
                          widget.secondOption,
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
