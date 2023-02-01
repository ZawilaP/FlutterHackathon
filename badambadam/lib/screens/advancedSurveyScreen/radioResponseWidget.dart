import 'package:flutter/material.dart';
import 'package:badambadam/model.dart';

class RadioButtons extends StatefulWidget {
  const RadioButtons({
    Key? key,
    required this.question,
  }) : super(key: key);

  final String question;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  NodeAnswer? _answer = NodeAnswer.yes;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.question),
        trailing: Container(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<NodeAnswer>(
                value: NodeAnswer.yes,
                activeColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primary),
                groupValue: _answer,
                onChanged: (NodeAnswer? value) {
                  setState(() {
                    _answer = value;
                    print(_answer);
                  });
                },
              ),
              Text('YES'),
              SizedBox(
                width: 8,
              ),
              Radio<NodeAnswer>(
                value: NodeAnswer.no,
                groupValue: _answer,
                activeColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primary),
                onChanged: (NodeAnswer? value) {
                  setState(() {
                    _answer = value;
                    print(_answer);
                  });
                },
              ),
              Text('NO')
            ],
          ),
        ));
  }
}