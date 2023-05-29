import 'package:flutter/material.dart';

import '../../model.dart';
import '../../storage.dart';

class SelectMetricQuestion extends StatefulWidget {
  SelectMetricQuestion(
      {super.key,
      this.questionNode,
      required this.questionId,
      required this.questionText,
      required this.localParamName,
      required this.valueList,
      this.hintText});

  final Node? questionNode;
  final String questionId;
  final String questionText;
  final String localParamName;
  final List<String> valueList;
  final String? hintText;

  @override
  State<SelectMetricQuestion> createState() => _SelectMetricQuestionState();
}

class _SelectMetricQuestionState extends State<SelectMetricQuestion>
    with AutomaticKeepAliveClientMixin {
  String? _dropdownValue;
  bool _otherFlag = false;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setMetricDataString(widget.localParamName, _dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500, width: 1),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(widget.hintText.toString()),
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10.0),
                      focusColor: Colors.transparent,
                      value: _dropdownValue,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      elevation: 16,
                      onChanged: (String? value) {
                        setState(() {
                          _dropdownValue = value!;
                          if (value == 'Inna osoba') {
                            _otherFlag = true;
                          } else {
                            _otherFlag = false;
                          }
                          setMetricDataString(
                              widget.localParamName, _dropdownValue);
                        });
                      },
                      items: widget.valueList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            _otherFlag
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Kim jest inna osoba?"),
                      onChanged: (text) {
                        print(myController.text);
                        setMetricDataString(widget.localParamName,
                            "$_dropdownValue+${myController.text}");
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
